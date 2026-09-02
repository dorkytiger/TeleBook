import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/dio_provdier.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/core/util/uuid_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_task_local_datasource.dart';
import 'package:tele_book/feature/sync/model/request/history_request.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';
import 'package:tele_book/feature/sync/model/response/sync_response.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';
import 'package:tele_book/feature/sync/service/sync_op_service.dart';
import 'package:tele_book/feature/sync/service/sync_queue.dart';

final syncMutationServiceProvider = Provider<SyncMutationService>((ref) {
  return SyncMutationService(
    ref.watch(settingRepositoryProvider),
    ref.watch(bookRepositoryProvider),
    ref.watch(syncStateLocalDatasourceProvider),
    ref.watch(syncTaskLocalDatasourceProvider),
    ref.watch(serverDioProvider),
    ref.watch(fileSyncServiceProvider),
    ref.watch(syncOpServiceProvider),
  );
});

/// 本地优先（离线优先）的书籍变更编排（队列单一化，§5/§8.5）。
///
/// **内容型变更（导入/批量导入/修改/删除）**：立即落本地（乐观），随后作为
/// 一组 SyncOp 组任务（type=push，组 = 该次用户操作，含多本书）入队执行：
/// 逐书上传缺失文件（内容寻址跳过已有）→ push 元数据/墓碑 → 成功后自动记录
/// 整库快照历史（§3）。因此它天然获得：全局通知「上传中 第X/共N本 · 页a/b」、
/// 可点开的组内书/页明细、失败可重试、App 中断后按落库规格（payload）恢复，
/// 并写入本地同步记录。不再走独立的 outbox 双通道。
///
/// **阅读进度（progress）**：高频小推送，**不进组任务、不进本地记录/通知**，
/// 静默直推（失败静默保留，下次翻页/内容型任务后补推；跨设备进度靠刷新同步
/// 顺带拉取收敛）。
class SyncMutationService {
  final SettingRepository _settings;
  final BookRepository _books;
  final SyncStateLocalDatasource _syncState;
  final SyncTaskLocalDatasource _syncTasks;
  final Dio _dio;
  final FileSyncService _fileSync;
  final SyncOpService _opsSync;

  /// 本进程内所有网络推送（内容型组任务执行体 + 进度静默）串行互斥。
  final SyncQueue _queue = SyncQueue();

  SyncMutationService(
    this._settings,
    this._books,
    this._syncState,
    this._syncTasks,
    this._dio,
    this._fileSync,
    this._opsSync,
  );

  /// 当前是否有可用的同步配置（serverUrl + token）。
  Future<bool> isConfigured() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    return url != null && token != null;
  }

  // ── 内容型变更：本地立即生效 + 提交 push 组任务 ────────────

  /// 修改书籍：本地立即生效；提交一组「上传修改的书籍」。
  Future<void> enqueueBookUpsert({required BookTableData book}) async {
    await _books.updateBook(book);
    if (!await isConfigured()) return;
    await _submitPushGroup(
      title: '上传修改的书籍',
      opType: 'modify',
      items: [
        PushBookItem(uuid: book.uuid, op: 'upsert', name: book.name),
      ],
    );
  }

  /// 删除书籍：本地立即删除（含图片文件）；提交一组「上传删除的书籍」。
  Future<void> enqueueBookDelete({required String uuid}) async {
    final row = await _books.getBookByUuid(uuid);
    final name = row?.name;
    await _deleteLocalBook(uuid);
    if (!await isConfigured()) return;
    await _submitPushGroup(
      title: '上传删除的书籍',
      opType: 'delete',
      items: [PushBookItem(uuid: uuid, op: 'delete', name: name)],
    );
  }

  /// 导入书籍（单个）：本地立即生成图片并落库；提交一组「上传导入的书籍」。
  Future<void> enqueueBookImport(
    SaveAsBookDto dto, {
    void Function(SaveStep step, int current, int total)? onStepProgress,
  }) async {
    final prepared = await _books.prepareBookImages(
      dto,
      onStepProgress: onStepProgress,
    );
    await _books.insertPreparedBook(prepared);
    if (!await isConfigured()) return;
    await _submitPushGroup(
      title: '上传导入的书籍',
      opType: 'import',
      items: [
        PushBookItem(uuid: prepared.uuid, op: 'upsert', name: prepared.name),
      ],
    );
  }

  /// 批量导入：逐本本地落库；整批提交一组「上传导入的 N 本书」。
  Future<void> enqueueBatchBookImport(
    List<SaveAsBookDto> dos, {
    void Function(int count)? onProgress,
  }) async {
    final items = <PushBookItem>[];
    for (var i = 0; i < dos.length; i++) {
      final prepared = await _books.prepareBookImages(dos[i]);
      await _books.insertPreparedBook(prepared);
      items.add(PushBookItem(uuid: prepared.uuid, op: 'upsert', name: prepared.name));
      onProgress?.call(i + 1);
    }
    if (!await isConfigured()) return;
    await _submitPushGroup(
      title: dos.length > 1 ? '上传导入的 ${dos.length} 本书' : '上传导入的书籍',
      opType: 'import',
      items: items,
    );
  }

  // ── push 组任务：提交 / 执行 / 恢复 ─────────────────────────

  /// 提交一组内容型变更推送。规格（书清单 + 快照类型）随任务落库
  /// （sync_op.payload，当前 schema 新增列），重启后可按它重建（[enqueuePushFromPayload]）。
  Future<int> _submitPushGroup({
    required String title,
    required String opType,
    required List<PushBookItem> items,
  }) {
    final payload = jsonEncode({
      'opType': opType,
      'items': [for (final it in items) it.toJson()],
    });
    return _enqueuePushFromPayload(payload, title: title);
  }

  /// 按 payload 入队 push 组任务（提交与重启恢复共用）。
  Future<int> _enqueuePushFromPayload(String payload, {required String title}) {
    return _opsSync.enqueue(
      type: SyncOpType.push,
      title: title,
      payload: payload,
      executor: (progress, detail) async {
        // 执行体放入本服务串行队列，与进度静默推送互斥
        await _queue.enqueue(() => _runPushGroup(payload, progress, detail));
      },
    );
  }

  /// 重启恢复入口：读取遗留 failed/interrupted 的 push 任务（行内 payload），
  /// **复用原任务行**重新入队执行（成功后原行 done、通知不残留；失败可再重试）。
  /// 返回是否已调度。
  Future<bool> enqueuePushFromPayload(SyncOpTableData op) async {
    final payload = op.payload;
    if (payload == null || payload.isEmpty) {
      throw StateError('该任务没有可恢复的规格');
    }
    return _opsSync.retryWithExecutor(op.id, (progress, detail) async {
      await _queue.enqueue(() => _runPushGroup(payload, progress, detail));
    });
  }

  /// 执行一组内容型推送（幂等可重放，§8.7.7）：
  /// 逐书：文件按 hash 只传缺失 → push 元数据/墓碑 → 收尾记录整库快照历史。
  /// **断点续传（§8.2）**：行内已落库的 doneBooks 经 [detail.resumeFrom] 注入，
  /// 重跑/恢复时从上次完成的本数继续，已完成的书跳过（不重复上传/push）。
  Future<void> _runPushGroup(
    String payload,
    SyncOpProgressCallback progress,
    SyncOpDetailWriter detail,
  ) async {
    final spec = jsonDecode(payload) as Map<String, dynamic>;
    final items = [
      for (final it in (spec['items'] as List? ?? const []))
        PushBookItem.fromJson(it as Map<String, dynamic>),
    ];
    if (items.isEmpty) return;
    final opType = spec['opType'] as String? ?? 'modify';
    final total = items.length;
    final start = detail.resumeFrom.clamp(0, total);
    var pushedAny = false;

    for (var idx = 0; idx < total; idx++) {
      final item = items[idx];
      final done = idx + 1; // 绝对序号（第几本，1-based）
      progress(SyncOpProgress(
        currentBook: done,
        totalBooks: total,
        totalPages: 1,
      ));
      if (idx < start) {
        // 上次已完成的书：仅回填明细为 done，跳过（不重复上传/push）
        if (item.op == 'upsert' && item.name != null) {
          detail.book(item.uuid, item.name!, const []);
          detail.finishBook(item.uuid, ok: true);
        }
        continue;
      }
      if (item.op == 'delete') {
        await _pushTombstone(item.uuid);
        pushedAny = true;
        progress(SyncOpProgress(
          currentBook: done,
          totalBooks: total,
          currentPage: 1,
          totalPages: 1,
        ));
        continue;
      }
      // upsert：运行时取书（文件可能已被改/删 → 以当前为准）
      final book = await _books.getBookByUuid(item.uuid);
      if (book == null) continue; // 已不存在（用户又删了）→ 跳过
      final files = await _fileSync.buildBookFiles(book);
      detail.book(
        book.uuid,
        book.name,
        [for (final f in files) f.relPath],
      );
      progress(SyncOpProgress(
        currentBook: done,
        totalBooks: total,
        totalPages: files.length,
      ));
      await _pushBook(
        book,
        files,
        progress: progress,
        detail: detail,
        currentBook: done,
        totalBooks: total,
      );
      detail.finishBook(book.uuid, ok: true);
      progress(SyncOpProgress(
        currentBook: done,
        totalBooks: total,
        currentPage: files.isEmpty ? 1 : files.length,
        totalPages: files.isEmpty ? 1 : files.length,
      ));
      pushedAny = true;
    }

    // §3：变更完成后自动记录整库快照历史（tag=auto）
    if (pushedAny) {
      final snapshot = await buildSnapshot();
      await _postHistory(opType: opType, tag: 'auto', snapshot: snapshot);
    }
  }

  /// 推送单本 upsert：先按 hash 只传缺失图片（逐文件进度/明细），再 push 元数据。
  /// 网络错误抛出（组任务标 failed 可重试）；服务器版本冲突抛出并提示走刷新同步。
  Future<void> _pushBook(
    BookTableData book,
    List<BookFileItem> files, {
    required SyncOpProgressCallback progress,
    required SyncOpDetailWriter detail,
    required int currentBook,
    required int totalBooks,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    final options = Options(headers: {'Authorization': 'Bearer $token'});

    // 1. 文件上传（内容寻址去重；每文件进度 → 行级页数与明细）
    if (files.isNotEmpty) {
      final missing = await _fileSync.checkMissing(
        files.map((f) => f.hash).toList(),
      );
      var fileDone = 0;
      for (final f in files) {
        if (!missing.contains(f.hash)) {
          fileDone++;
          detail.fileDone(book.uuid, f.relPath);
          progress(SyncOpProgress(
            currentBook: currentBook,
            totalBooks: totalBooks,
            currentPage: fileDone,
            totalPages: files.length,
          ));
          continue; // 已在服务器（跨设备已传）
        }
        if (!File(f.absPath).existsSync()) {
          fileDone++;
          continue; // 本地文件缺失 → 跳过（内容以服务器为准）
        }
        detail.fileSyncing(book.uuid, f.relPath);
        try {
          await _fileSync.uploadFile(
            path: f.absPath,
            hash: f.hash,
            size: f.size,
            onProgress: (p) {
              progress(SyncOpProgress(
                currentBook: currentBook,
                totalBooks: totalBooks,
                currentPage: fileDone + (p >= 1 ? 1 : 0),
                totalPages: files.length,
              ));
              detail.fileSyncing(book.uuid, f.relPath, progress: p);
            },
          );
          fileDone++;
          detail.fileDone(book.uuid, f.relPath);
          progress(SyncOpProgress(
            currentBook: currentBook,
            totalBooks: totalBooks,
            currentPage: fileDone,
            totalPages: files.length,
          ));
        } catch (e) {
          detail.fileFailed(book.uuid, f.relPath, error: '$e');
          throw StateError('上传图片失败 ${f.relPath}：$e（可重试，已传部分自动跳过）');
        }
      }
    }

    // 2. push 元数据（乐观锁 base_revision 来自本地记录）
    final baseRev =
        await _syncState.getRevision('book', book.uuid) ?? 0;
    final res = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/sync/push',
      data: SyncPushRequest(
        source: 'auto',
        changes: [
          BookChange(
            changeId: Uuid.v4(),
            entityType: 'book',
            entityId: book.uuid,
            op: 'upsert',
            baseRevision: baseRev,
            payload: _payloadOf(
              name: book.name,
              currentPage: book.currentPage,
              files: files,
            ),
          ),
        ],
      ).toJson(),
      options: options,
    );
    final response = SyncPushResponse.fromJson(res.data ?? {});
    final r = response.results.isEmpty ? null : response.results.first;
    if (r != null && r.accepted) {
      if (r.revision > 0) {
        await _syncState.upsertRevision('book', book.uuid, r.revision);
      }
      return;
    }
    if (r?.reason == 'conflict') {
      throw StateError(
        '「${book.name}」在服务器已被其它设备修改：请到 设置 → 刷新同步 选择保留哪一版',
      );
    }
    throw StateError('服务器未接受「${book.name}」的变更（${r?.reason ?? '未知原因'}），可重试');
  }

  /// 推送删除墓碑（base_revision 来自本地记录；冲突时提示刷新同步处理）。
  Future<void> _pushTombstone(String uuid) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final baseRev = await _syncState.getRevision('book', uuid) ?? 0;
    final res = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/sync/push',
      data: SyncPushRequest(
        source: 'auto',
        changes: [
          BookChange(
            changeId: Uuid.v4(),
            entityType: 'book',
            entityId: uuid,
            op: 'delete',
            baseRevision: baseRev,
            payload: null,
          ),
        ],
      ).toJson(),
      options: options,
    );
    final response = SyncPushResponse.fromJson(res.data ?? {});
    final r = response.results.isEmpty ? null : response.results.first;
    if (r != null && r.accepted) {
      await _syncState.deleteState('book', uuid);
      return;
    }
    if (r?.reason == 'conflict') {
      throw StateError('删除未同步：服务器版本已被其它设备修改，请刷新同步处理');
    }
    throw StateError('服务器未接受删除（${r?.reason ?? '未知原因'}），可重试');
  }

  // ── 阅读进度：静默单通道（不进组任务/通知/本地记录） ───────

  /// 兼容别名：排空 outbox = 补推静默进度（对外调用点如重试按钮）。
  Future<void> drain() => flushProgress();

  /// 阅读进度：本地立即落库，静默直推。
  ///
  /// §3/§4：进度独立 op='progress'，只带 current_page（不含文件、不参与整库
  /// 版本、不记快照）；高频防抖由翻页侧（800ms）保证。
  /// 推送失败静默保留（下次翻页/内容型推送后补推），不打扰用户。
  Future<void> enqueueBookProgress({required BookTableData book}) async {
    await _books.updateBook(book); // 本地优先，立即生效（未配置也落库）
    if (!await isConfigured()) return;
    await _syncTasks.insertTask(
      _progressTask(book.uuid, book.name, book.currentPage),
    );
    unawaited(flushProgress());
  }

  /// 立即补推所有静默进度任务（串行，成功移除；失败保留，不弹窗）。
  Future<void> flushProgress() async {
    if (!await isConfigured()) return;
    await _queue.enqueue(_flushProgressOnce);
  }

  Future<void> _flushProgressOnce() async {
    // 同一本书只留最新一条（防离线长时间阅读积压）
    final pending = await _syncTasks.listPending();
    final byUuid = <String, SyncTaskTableData>{};
    for (final t in pending) {
      final prev = byUuid[t.entityId];
      if (prev == null || t.id > prev.id) {
        if (prev != null) {
          await _syncTasks.removeTask(prev.id);
        }
        byUuid[t.entityId] = t;
      } else {
        await _syncTasks.removeTask(t.id);
      }
    }
    for (final task in byUuid.values) {
      try {
        await _pushProgress(task);
      } catch (_) {
        // 网络失败：静默保留，下次补推
        return;
      }
    }
  }

  Future<void> _pushProgress(SyncTaskTableData task) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    final payload = BookPayload.fromJson(
      jsonDecode(task.payload!) as Map<String, dynamic>,
    );
    await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/sync/push',
      data: SyncPushRequest(
        source: 'auto',
        changes: [
          BookChange(
            changeId: task.changeId,
            entityType: task.entityType,
            entityId: task.entityId,
            op: task.op,
            baseRevision: 0,
            payload: payload,
          ),
        ],
      ).toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    await _syncTasks.removeTask(task.id);
  }

  // ── 快照历史（§3/§2.4：客户端驱动，整库快照） ────────────

  /// 上传整库快照为一条历史记录（幂等可重放）。
  Future<void> _postHistory({
    required String opType,
    required String tag,
    required List<BookSnapshotItem> snapshot,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/books/history',
      data: RecordHistoryRequest(opType: opType, tag: tag, snapshot: snapshot)
          .toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  /// 构建当前整库快照（所有书，含文件 hash）。
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

  // ── 工具 ───────────────────────────────────────────────────

  SyncTaskTableCompanion _progressTask(String uuid, String name, int page) {
    return SyncTaskTableCompanion.insert(
      changeId: Uuid.v4(),
      entityType: 'book',
      entityId: uuid,
      op: 'progress',
      payload: Value(
        jsonEncode(
          BookPayload(name: name, currentPage: page, coverHash: null, files: const [])
              .toJson(),
        ),
      ),
    );
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

  Future<void> _deleteLocalBook(String uuid) async {
    final row = await _books.getBookByUuid(uuid);
    if (row == null) return;
    await _books.deleteBook(row.id);
  }
}

/// 组任务 payload 里的一本书（uuid + 动作 + 展示名）。
class PushBookItem {
  final String uuid;
  final String op; // upsert / delete
  final String? name;
  const PushBookItem({required this.uuid, required this.op, this.name});

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'op': op,
        if (name != null) 'name': name,
      };
  factory PushBookItem.fromJson(Map<String, dynamic> json) => PushBookItem(
        uuid: json['uuid'] as String? ?? '',
        op: json['op'] as String? ?? 'upsert',
        name: json['name'] as String?,
      );
}
