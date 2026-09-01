import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/dio_provdier.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/uuid_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_log_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_task_local_datasource.dart';
import 'package:tele_book/feature/sync/model/request/auth_request.dart';
import 'package:tele_book/feature/sync/model/request/history_request.dart';
import 'package:tele_book/feature/sync/model/request/refresh_request.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';
import 'package:tele_book/feature/sync/model/response/auth_response.dart';
import 'package:tele_book/feature/sync/model/response/refresh_response.dart';
import 'package:tele_book/feature/sync/model/response/sync_response.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_log_session.dart';
import 'package:tele_book/feature/sync/service/sync_queue.dart';

final syncMutationServiceProvider = Provider<SyncMutationService>((ref) {
  return SyncMutationService(
    ref.watch(settingRepositoryProvider),
    ref.watch(bookRepositoryProvider),
    ref.watch(syncStateLocalDatasourceProvider),
    ref.watch(syncTaskLocalDatasourceProvider),
    ref.watch(syncLogLocalDatasourceProvider),
    ref.watch(serverDioProvider),
    ref.watch(fileSyncServiceProvider),
  );
});

/// 本地优先（离线优先）的书籍变更编排：
///
/// 变更（修改/删除/导入）**立即落本地**（用户无感、离线可用），
/// 同时写一条"待同步任务"（outbox：稳定 change_id + 变更快照）；
/// 后台 [drain] 串行推送服务器：成功移除任务、冲突标记（底栏提示）、
/// 网络错误保留任务下次重试。底栏只显示同步状态（待同步数/同步中/冲突）。
///
/// 未配置同步服务器时只做本地操作（不产生 outbox 任务）。
class SyncMutationService {
  final SettingRepository _settings;
  final BookRepository _books;
  final SyncStateLocalDatasource _syncState;
  final SyncTaskLocalDatasource _syncTasks;
  final SyncLogLocalDatasource _syncLogs;
  final Dio _dio;
  final FileSyncService _fileSync;
  final SyncQueue _queue = SyncQueue();

  /// 本地冲突标记（实体 uuid → 冲突）；底栏据此提示"需先解决"。
  final ValueNotifier<Set<String>> conflictedBookIds = ValueNotifier({});

  /// outbox 变动计数（入队/清空后自增），SyncStatusNotifier 监听刷新底栏。
  final ValueNotifier<int> outboxRevision = ValueNotifier(0);

  /// 最近一次同步错误（drain 失败时设置；UI 监听弹窗提示，展示后清空）。
  final ValueNotifier<String?> lastError = ValueNotifier(null);

  /// drain 是否进行中（底栏"同步中"据此显示，任意导入/删除触发也会亮）。
  final ValueNotifier<bool> draining = ValueNotifier(false);

  /// 当前同步会话（drain + pull 共用一条本地记录）。
  SyncLogSession? _session;
  bool _sessionDirty = false;

  SyncMutationService(
    this._settings,
    this._books,
    this._syncState,
    this._syncTasks,
    this._syncLogs,
    this._dio,
    this._fileSync,
  );

  /// 当前是否有可用的同步配置（serverUrl + token）。
  Future<bool> isConfigured() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    return url != null && token != null;
  }

  // ── 本地优先变更：立即落库 + 写 outbox，后台 drain ─────────

  /// 修改书籍：本地立即生效，同步任务后台推送；操作完成后捕获整库快照 → 记 modify。
  Future<void> enqueueBookUpsert({required BookTableData book}) async {
    final configured = await isConfigured();
    await _books.updateBook(book);
    if (configured) {
      final files = await _fileSync.buildBookFiles(book);
      await _syncTasks.insertTask(
        _task(
          op: 'upsert',
          entityId: book.uuid,
          payload: _payloadOf(
            name: book.name,
            currentPage: book.currentPage,
            files: files,
          ),
        ),
      );
      final postSnapshot = await buildSnapshot(); // 操作完成后的状态
      await _syncTasks.insertTask(
        _historyTask(opType: 'modify', tag: 'auto', snapshot: postSnapshot),
      );
      _bump();
      unawaited(drain());
    }
  }

  /// 阅读进度：本地立即落库，同步任务后台推送。
  ///
  /// 高频变更防膨胀：合并到已有 pending upsert（只更新 current_page），
  /// 不新增任务、不记整库快照历史（进度不是内容变更，历史无意义）。
  Future<void> enqueueBookProgress({required BookTableData book}) async {
    await _books.updateBook(book); // 本地优先，立即生效（未配置也落库）
    if (!await isConfigured()) return;
    final merged = await _syncTasks.mergePendingUpsert(
      entityId: book.uuid,
      name: book.name,
      currentPage: book.currentPage,
    );
    if (!merged) {
      final files = await _fileSync.buildBookFiles(book);
      await _syncTasks.insertTask(
        _task(
          op: 'upsert',
          entityId: book.uuid,
          payload: _payloadOf(
            name: book.name,
            currentPage: book.currentPage,
            files: files,
          ),
        ),
      );
    }
    _bump();
    unawaited(drain());
  }

  /// 删除书籍：本地立即删除（含图片文件），同步任务后台推送墓碑；
  /// 删除完成后捕获整库快照 → 记 delete（快照 = 删除后的状态）。
  Future<void> enqueueBookDelete({required String uuid}) async {
    final configured = await isConfigured();
    await _deleteLocalBook(uuid);
    if (configured) {
      await _syncTasks.insertTask(
        _task(op: 'delete', entityId: uuid, payload: null),
      );
      final postSnapshot = await buildSnapshot(); // 删除完成后的状态
      await _syncTasks.insertTask(
        _historyTask(opType: 'delete', tag: 'auto', snapshot: postSnapshot),
      );
      _bump();
      unawaited(drain());
    }
  }

  /// 导入书籍（单个）：本地立即生成图片并落库，同步任务后台推送；
  /// 导入完成后捕获整库快照 → 记 import（快照 = 导入后的状态）。
  Future<void> enqueueBookImport(
    SaveAsBookDto dto, {
    void Function(SaveStep step, int current, int total)? onStepProgress,
  }) async {
    final configured = await isConfigured();
    final prepared = await _books.prepareBookImages(
      dto,
      onStepProgress: onStepProgress,
    );
    await _books.insertPreparedBook(prepared);
    if (configured) {
      final files = await _fileSync.buildBookFilesFor(
        localSubPaths: prepared.localSubPaths,
        coverSubPath: prepared.coverSubPath,
      );
      await _syncTasks.insertTask(
        _task(
          op: 'upsert',
          entityId: prepared.uuid,
          payload: _payloadOf(
            name: prepared.name,
            currentPage: 0,
            files: files,
          ),
        ),
      );
      final postSnapshot = await buildSnapshot(); // 导入完成后的状态
      await _syncTasks.insertTask(
        _historyTask(opType: 'import', tag: 'auto', snapshot: postSnapshot),
      );
      _bump();
      unawaited(drain());
    }
  }

  /// 批量导入：逐本落库 + 写 outbox；批次完成后捕获整库快照 → 记一条 import。
  Future<void> enqueueBatchBookImport(
    List<SaveAsBookDto> dos, {
    void Function(int count)? onProgress,
  }) async {
    final configured = await isConfigured();
    for (var i = 0; i < dos.length; i++) {
      final prepared = await _books.prepareBookImages(dos[i]);
      await _books.insertPreparedBook(prepared);
      if (configured) {
        final files = await _fileSync.buildBookFilesFor(
          localSubPaths: prepared.localSubPaths,
          coverSubPath: prepared.coverSubPath,
        );
        await _syncTasks.insertTask(
          _task(
            op: 'upsert',
            entityId: prepared.uuid,
            payload: _payloadOf(
              name: prepared.name,
              currentPage: 0,
              files: files,
            ),
          ),
        );
      }
      onProgress?.call(i + 1);
    }
    if (configured) {
      // 整个批次记一条 import 历史（快照 = 导入完成后的状态）
      final postSnapshot = await buildSnapshot();
      await _syncTasks.insertTask(
        _historyTask(opType: 'import', tag: 'auto', snapshot: postSnapshot),
      );
      _bump();
      unawaited(drain());
    }
  }

  /// 手动同步：同步前捕获快照，同步完成后记录 manual_sync（供手动同步页调用）。
  Future<void> recordManualSync({required List<BookSnapshotItem> snapshot}) async {
    if (!await isConfigured()) return;
    await _syncTasks.insertTask(
      _historyTask(opType: 'manual_sync', tag: 'manual', snapshot: snapshot),
    );
    _bump();
    unawaited(drain());
  }

  // ── 后台 drain：串行推送 outbox ───────────────────────────

  /// 排空 outbox（串行）；返回完成信号（供手动同步等待）。
  Future<void> drain() => _queue.enqueue(_drainOnce);

  Future<void> _drainOnce() async {
    if (!await isConfigured()) return;
    draining.value = true;
    var allOk = true;
    try {
      final tasks = await _syncTasks.listPending();
      if (tasks.isNotEmpty) {
        await beginSyncSession();
      }
      for (final task in tasks) {
        final proceed = await _pushTask(task);
        if (!proceed) {
          allOk = false;
          break; // 网络/服务器错误：停止本次 drain，保留顺序，下轮重试
        }
      }
    } catch (e) {
      allOk = false;
      _reportError('同步出错: $e');
    } finally {
      if (_session != null) {
        await endSyncSession(ok: allOk);
      }
      draining.value = false;
    }
    _bump();
  }

  /// 推送单个任务。返回 true=已处理（成功/冲突/失败），false=错误（停止）。
  Future<bool> _pushTask(SyncTaskTableData task) async {
    try {
      final url = await _settings.getString(SyncSettings.serverUrl);
      final token = await _settings.getString(SyncSettings.token);
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      // 历史记录任务：整库快照直接 POST /books/history
      if (task.entityType == 'history') {
        final req = RecordHistoryRequest.fromJson(
          jsonDecode(task.payload!) as Map<String, dynamic>,
        );
        await _dio.post<Map<String, dynamic>>(
          '$url/api/v1/books/history',
          data: req.toJson(),
          options: options,
        );
        await _syncTasks.removeTask(task.id);
        return true;
      }

      final baseRev =
          await _syncState.getRevision(task.entityType, task.entityId) ?? 0;
      // outbox 存的是 BookPayload 的 JSON 快照；delete 任务无 payload
      BookPayload? payload;
      if (task.payload != null && task.payload!.isNotEmpty) {
        payload = BookPayload.fromJson(
          jsonDecode(task.payload!) as Map<String, dynamic>,
        );
      }

      // 图片文件：按快照 hash 上传缺失（内容寻址去重）
      final fileItems = _fileItemsFromPayload(payload, task.entityId);
      if (task.op == 'upsert' && payload != null) {
        sessionUpsertBook(
          task.entityId,
          payload.name,
          fileItems.map((f) => f.relPath).toList(),
        );
      }
      if (fileItems.isNotEmpty) {
        final missing = await _fileSync.checkMissing(
          fileItems.map((f) => f.hash).toList(),
        );
        for (final f in fileItems) {
          if (!missing.contains(f.hash) || !File(f.absPath).existsSync()) {
            sessionMarkFile(task.entityId, f.relPath, 'done'); // 已存在/已上传
            continue;
          }
          sessionMarkFile(task.entityId, f.relPath, 'syncing');
          try {
            await _fileSync.uploadFile(
              path: f.absPath,
              hash: f.hash,
              size: f.size,
            );
            sessionMarkFile(task.entityId, f.relPath, 'done');
          } catch (_) {
            sessionMarkFile(task.entityId, f.relPath, 'failed');
          }
        }
      }

      final res = await _dio.post<Map<String, dynamic>>(
        '$url/api/v1/sync/push',
        data: SyncPushRequest(
          source: 'auto',
          changes: [
            BookChange(
              changeId: task.changeId,
              entityType: task.entityType,
              entityId: task.entityId,
              op: task.op,
              baseRevision: baseRev,
              payload: payload,
            ),
          ],
        ).toJson(),
        options: options,
      );
      final response = SyncPushResponse.fromJson(res.data ?? {});
      if (response.results.isEmpty) {
        await _syncTasks.removeTask(task.id);
        return true;
      }
      final r = response.results.first;
      if (r.accepted) {
        if (r.revision > 0) {
          await _syncState.upsertRevision(
            task.entityType,
            task.entityId,
            r.revision,
          );
        }
        await _syncTasks.removeTask(task.id);
        sessionMarkBook(task.entityId, 'done');
        return true;
      }
      if (r.reason == 'conflict') {
        // 服务器已有更新版本：本地保留，标记冲突走解决流程，任务移除
        _markConflict(task.entityId);
        await _syncTasks.removeTask(task.id);
        sessionMarkBook(task.entityId, 'failed');
        return true;
      }
      // 其它失败：标记 failed（保留任务，下次 drain 重试）
      await _syncTasks.markFailed(task.id);
      sessionMarkBook(task.entityId, 'failed');
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // 1) 先尝试 refresh token 换新 access（正常过期路径）
        if (await _refreshAccessToken()) return _pushTask(task);
        // 2) refresh 也失效（服务器重置/设备丢失）→ 用连接密钥重新注册
        if (await _ensureRegistered()) return _pushTask(task);
        _reportError('登录已失效，请到设置重新连接同步服务器');
        return false;
      }
      _reportError(
        '同步失败（${e.response?.statusCode ?? e.type}）: '
        '${e.response?.statusMessage ?? e.message}',
      );
      return false;
    } catch (e) {
      _reportError('同步出错: $e');
      return false;
    }
  }

  /// 用 refresh token 换新 access token（服务端轮换 refresh token）。
  Future<bool> _refreshAccessToken() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final refreshToken = await _settings.getString(SyncSettings.refreshToken);
    if (url == null || refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$url/api/v1/auth/refresh',
        data: RefreshRequest(refreshToken: refreshToken).toJson(),
      );
      final response = RefreshResponse.fromJson(res.data ?? {});
      if (response.accessToken.isEmpty) return false;
      await _settings.setString(SyncSettings.token, response.accessToken);
      await _settings.setString(SyncSettings.refreshToken, response.refreshToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 服务器丢失设备（数据重置）时用本地保存的配置重新注册，换新 token。
  Future<bool> _ensureRegistered() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final key = await _settings.getString(SyncSettings.connectionKey);
    final deviceId = await _settings.getString(SyncSettings.deviceId) ?? Uuid.v4();
    if (url == null || key == null) return false;
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$url/api/v1/auth/register',
        data: RegisterRequest(
          connectionKey: key,
          deviceId: deviceId,
          deviceName: 'android-${deviceId.substring(0, 4)}',
          platform: 'android',
        ).toJson(),
      );
      final response = RegisterResponse.fromJson(res.data ?? {});
      if (response.accessToken.isEmpty) return false;
      await _settings.setString(SyncSettings.token, response.accessToken);
      await _settings.setString(SyncSettings.refreshToken, response.refreshToken);
      await _settings.setString(SyncSettings.deviceId, deviceId);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── 本地同步记录（会话） ──────────────────────────────────

  /// 开始一次同步会话（创建本地记录行；已存在则复用）。
  Future<void> beginSyncSession() async {
    if (_session != null) return;
    final now = DateTime.now();
    final id = await _syncLogs.insertLog(
      SyncLogTableCompanion.insert(
        startedAt: now,
        status: 'running',
      ),
    );
    _session = SyncLogSession(id: id, startedAt: now);
    _sessionDirty = true;
    _schedulePersist();
  }

  /// 注册一本书及其文件清单（drain 上传 / pull 下载共用）。
  void sessionUpsertBook(String uuid, String name, List<String> relPaths) {
    final session = _session;
    if (session == null) return;
    final book = session.book(uuid, name);
    for (final rel in relPaths) {
      book.files.putIfAbsent(rel, () => 'pending');
    }
    _schedulePersist();
  }

  /// 标记某本书的一个文件状态（上传/下载进度）。
  void sessionMarkFile(String uuid, String relPath, String status) {
    final session = _session;
    if (session == null) return;
    final book = session.bookByUuid(uuid);
    if (book == null) return;
    book.files[relPath] = status;
    if (status == 'syncing' && book.status == 'pending') {
      book.status = 'syncing';
    }
    _schedulePersist();
  }

  /// 标记某本书整体状态（done / failed）。
  void sessionMarkBook(String uuid, String status) {
    final session = _session;
    if (session == null) return;
    final book = session.bookByUuid(uuid);
    if (book == null) return;
    book.status = status;
    if (status == 'done') {
      for (final k in book.files.keys) {
        book.files[k] = 'done';
      }
    }
    _schedulePersist();
  }

  /// pull 下载的书本聚合进度（done/total 文件）。
  void sessionReportBookAggregate(String uuid, String name, int done, int total) {
    final session = _session;
    if (session == null) return;
    final book = session.book(uuid, name);
    // 无明细文件时按计数补齐占位
    final rels = List<String>.of(book.files.keys);
    if (rels.isEmpty) {
      for (var i = 0; i < total; i++) {
        book.files['#${i + 1}'] = 'pending';
      }
    }
    final keys = List<String>.of(book.files.keys);
    var count = 0;
    for (final k in keys) {
      if (count < done) {
        book.files[k] = 'done';
      } else {
        book.files[k] = 'pending';
      }
      count++;
    }
    if (book.status == 'pending') book.status = 'syncing';
    if (done >= total) book.status = 'done';
    _schedulePersist();
  }

  /// 结束会话：落库最终状态（completed / failed）。
  Future<void> endSyncSession({required bool ok, String? error}) async {
    final session = _session;
    if (session == null) return;
    session.status = ok ? 'completed' : 'failed';
    _schedulePersist(); // 立即刷
    await _persistSessionNow();
    _session = null;
  }

  Timer? _persistTimer;
  void _schedulePersist() {
    if (!_sessionDirty) return;
    _sessionDirty = false;
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(milliseconds: 300), () {
      _persistSessionNow();
    });
  }

  Future<void> _persistSessionNow() async {
    final session = _session;
    if (session == null) return;
    try {
      await _syncLogs.updateLog(
        session.id,
        status: session.status,
        totalBooks: session.totalBooks,
        syncedBooks: session.syncedBooks,
        failedBooks: session.failedBooks,
        detail: session.toDetailJson(),
        finishedAt: session.status != 'running' ? DateTime.now() : null,
      );
    } catch (_) {}
  }

  /// 上报同步错误（UI 弹窗提示）。
  void reportError(String message) {
    lastError.value = message;
  }

  void _reportError(String message) {
    reportError(message);
  }

  // ── 工具 ───────────────────────────────────────────────────

  SyncTaskTableCompanion _task({
    required String op,
    required String entityId,
    required BookPayload? payload,
  }) {
    return SyncTaskTableCompanion.insert(
      changeId: Uuid.v4(),
      entityType: 'book',
      entityId: entityId,
      op: op,
      payload: Value(payload == null ? null : jsonEncode(payload.toJson())),
    );
  }

  /// 历史记录任务（整库快照，客户端驱动）。
  SyncTaskTableCompanion _historyTask({
    required String opType,
    required String tag,
    required List<BookSnapshotItem> snapshot,
  }) {
    return SyncTaskTableCompanion.insert(
      changeId: Uuid.v4(),
      entityType: 'history',
      entityId: 'history-$opType',
      op: 'record',
      payload: Value(
        jsonEncode(
          RecordHistoryRequest(
            opType: opType,
            tag: tag,
            snapshot: snapshot,
          ).toJson(),
        ),
      ),
    );
  }

  /// 构建当前整库快照（deleted 之外的所有书，含文件 hash）。
  Future<List<BookSnapshotItem>> buildSnapshot() async {
    final books = await _books.getAllBooks();
    final items = <BookSnapshotItem>[];
    for (final book in books) {
      final files = await _fileSync.buildBookFiles(book);
      items.add(
        BookSnapshotItem(
          uuid: book.uuid,
          name: book.name,
          currentPage: book.currentPage,
          coverHash: files.where((f) => f.relPath == 'cover.jpg').firstOrNull?.hash,
          files: files
              .map(
                (f) => BookFileMeta(
                  relPath: f.relPath,
                  hash: f.hash,
                  size: f.size,
                ),
              )
              .toList(),
        ),
      );
    }
    return items;
  }

  BookPayload _payloadOf({
    required String name,
    required int currentPage,
    required List<BookFileItem> files,
  }) {
    return BookPayload(
      name: name,
      currentPage: currentPage,
      coverHash: files.where((f) => f.relPath == 'cover.jpg').firstOrNull?.hash,
      files: files
          .map(
            (f) => BookFileMeta(
              relPath: f.relPath,
              hash: f.hash,
              size: f.size,
            ),
          )
          .toList(),
    );
  }

  /// 从快照 payload 重建本地文件项（abs 路径 = booksDir/`entityId`/`rel_path`）。
  List<BookFileItem> _fileItemsFromPayload(
    BookPayload? payload,
    String entityId,
  ) {
    if (payload == null) return const [];
    return payload.files
        .where((f) => f.hash.isNotEmpty)
        .map(
          (f) => BookFileItem(
            relPath: f.relPath,
            absPath: GlobalConfig.resolveBookPath('$entityId/${f.relPath}'),
            hash: f.hash,
            size: f.size,
          ),
        )
        .toList();
  }

  Future<void> _deleteLocalBook(String uuid) async {
    final row = await _books.getBookByUuid(uuid);
    if (row == null) return;
    await _books.deleteBook(row.id);
  }

  void _markConflict(String uuid) {
    conflictedBookIds.value = {...conflictedBookIds.value, uuid};
  }

  void _bump() {
    outboxRevision.value++;
  }
}
