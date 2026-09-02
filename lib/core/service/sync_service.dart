import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/dio_provdier.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/core/util/uuid_util.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/setting/repository/setting_repository.dart';
import 'package:tele_book/feature/sync/datasource/sync_state_local_datasource.dart';
import 'package:tele_book/feature/sync/datasource/sync_task_local_datasource.dart';
import 'package:tele_book/feature/sync/service/local_conflict_service.dart';
import 'package:tele_book/feature/sync/model/request/auth_request.dart';
import 'package:tele_book/feature/sync/model/request/refresh_request.dart';
import 'package:tele_book/feature/sync/model/request/conflict_request.dart';
import 'package:tele_book/feature/sync/model/request/history_request.dart';
import 'package:tele_book/feature/sync/model/request/restore_request.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';
import 'package:tele_book/feature/sync/model/response/auth_response.dart';
import 'package:tele_book/feature/sync/model/response/refresh_response.dart';
import 'package:tele_book/feature/sync/model/response/conflict_response.dart';
import 'package:tele_book/feature/sync/model/response/history_response.dart';
import 'package:tele_book/feature/sync/model/response/sync_response.dart';
import 'package:tele_book/feature/sync/service/file_sync_service.dart';

part 'sync_service.g.dart';

/// 同步相关设置 key（存 setting_table）。
abstract final class SyncSettings {
  static const serverUrl = 'sync_server_url';
  static const connectionKey = 'sync_connection_key';
  static const deviceId = 'sync_device_id';
  static const token = 'sync_token'; // access token（短期）
  static const refreshToken = 'sync_refresh_token';
  static const cursor = 'sync_cursor';
}

/// 一次手动同步的结果摘要。
class SyncSummary {
  final int pushed; // 推送成功的变更数
  final int pulled; // 拉取应用的事件数
  final int conflicts; // 冲突数（本次未解决，需后续处理）
  final int failed; // 失败数

  const SyncSummary({
    required this.pushed,
    required this.pulled,
    required this.conflicts,
    required this.failed,
  });
}

/// 客户端同步引擎：连接配置 / 设备注册 / 手动全量同步（书籍元数据 + 图片文件）。
@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  @override
  void build() {}

  Dio get _dio => ref.read(serverDioProvider);
  SettingRepository get _settings => ref.read(settingRepositoryProvider);
  BookRepository get _books => ref.read(bookRepositoryProvider);
  SyncStateLocalDatasource get _syncState => ref.read(syncStateLocalDatasourceProvider);
  FileSyncService get _fileSync => ref.read(fileSyncServiceProvider);

  /// pull 进度事件时，本地 outbox 有更晚待推变更的书（单次 pull 惰性加载缓存）。
  Set<String>? _protectedBookIds;

  /// pull 时的"待解决冲突"书（§7）：本地版本还没被用户选择保留，pull 不得用
  /// 服务器事件覆盖本地内容（否则冲突列表里的"保留本地"选项形同虚设）。
  Set<String>? _conflictUuids;

  Set<String> get _conflictUuidSet => _conflictUuids ??=
      {for (final c in ref.read(localConflictServiceProvider).pending.value) c.uuid};

  /// 测试连接：GET {url}/ping。
  Future<bool> testConnection(String url) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$url/ping');
      return res.statusCode == 200;
    } on DioException {
      return false;
    }
  }

  /// 保存服务器配置并注册设备（连接密钥换 JWT）。
  ///
  /// 已注册过的设备重复配置会重新签发 token（服务器幂等处理）。
  Future<void> configure({required String url, required String connectionKey}) async {
    final urlTrimmed = url.trim().replaceFirst(RegExp(r'/+$'), '');
    var deviceId = await _settings.getString(SyncSettings.deviceId);
    deviceId ??= Uuid.v4();

    final res = await _dio.post<Map<String, dynamic>>(
      '$urlTrimmed/api/v1/auth/register',
      data: RegisterRequest(
        connectionKey: connectionKey,
        deviceId: deviceId,
        deviceName: '${Platform.operatingSystem}-${deviceId.substring(0, 4)}',
        platform: Platform.operatingSystem,
      ).toJson(),
    );
    final response = RegisterResponse.fromJson(res.data ?? {});
    if (response.accessToken.isEmpty) {
      throw StateError('注册失败：未返回 token');
    }

    await _settings.setString(SyncSettings.serverUrl, urlTrimmed);
    await _settings.setString(SyncSettings.connectionKey, connectionKey);
    await _settings.setString(SyncSettings.deviceId, deviceId);
    await _settings.setString(SyncSettings.token, response.accessToken);
    await _settings.setString(SyncSettings.refreshToken, response.refreshToken);
  }

  /// 用 refresh token 换新 access token（服务端同时轮换 refresh token）。
  ///
  /// 成功返回 true；refresh token 也失效（服务器重置/过期）返回 false，需重新连接。
  Future<bool> refreshAccessToken() async {
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

  /// 手动同步：push 本地书籍变更 + pull 服务器事件并应用。
  Future<SyncSummary> syncNow() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});

    final (pushed, conflicts, failed) = await _pushBooks(url, options);
    final pulled = await _pullEvents(url, options);
    return SyncSummary(
      pushed: pushed,
      pulled: pulled,
      conflicts: conflicts,
      failed: failed,
    );
  }

  /// 推送本地全部书籍（全量策略，乐观锁 base_revision 来自本地记录）。
  ///
  /// 附带图片文件同步：算 hash → 比对 → 上传缺失（按 hash 去重）。
  Future<(int, int, int)> _pushBooks(String url, Options options) async {
    final books = await _books.getAllBooks();
    if (books.isEmpty) return (0, 0, 0);

    final changes = <BookChange>[];
    for (final book in books) {
      final rev = await _syncState.getRevision('book', book.uuid) ?? 0;
      final files = await _fileSync.buildBookFiles(book);
      await _fileSync.ensureUploaded(files);
      changes.add(
        BookChange(
          changeId: '${book.uuid}-$rev',
          entityType: 'book',
          entityId: book.uuid,
          op: 'upsert',
          baseRevision: rev,
          payload: BookPayload(
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
        ),
      );
    }

    final res = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/sync/push',
      data: SyncPushRequest(source: 'manual', changes: changes).toJson(),
      options: options,
    );
    final response = SyncPushResponse.fromJson(res.data ?? {});

    var pushed = 0, conflicts = 0, failed = 0;
    for (var i = 0; i < response.results.length && i < changes.length; i++) {
      final r = response.results[i];
      if (r.accepted) {
        if (r.revision > 0) {
          await _syncState.upsertRevision('book', changes[i].entityId, r.revision);
        }
        pushed++;
      } else if (r.reason == 'conflict') {
        conflicts++;
      } else {
        failed++;
      }
    }
    return (pushed, conflicts, failed);
  }

  /// 手动同步：推送单本书（source=manual，图片文件进度经 [onFileProgress] 上报）。
  ///
  /// 返回 1=接受 / 0=冲突或失败（本地不落库，仅计数）。
  Future<int> pushBookManual({
    required BookTableData book,
    void Function(double progress)? onFileProgress,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    final options = Options(headers: {'Authorization': 'Bearer $token'});

    final files = await _fileSync.buildBookFiles(book);
    await _fileSync.ensureUploaded(files, onProgress: onFileProgress);
    final rev = await _syncState.getRevision('book', book.uuid) ?? 0;

    final res = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/sync/push',
      data: SyncPushRequest(
        source: 'manual',
        changes: [
          BookChange(
            changeId: '${book.uuid}-manual-$rev',
            entityType: 'book',
            entityId: book.uuid,
            op: 'upsert',
            baseRevision: rev,
            payload: BookPayload(
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
          ),
        ],
      ).toJson(),
      options: options,
    );
    final response = SyncPushResponse.fromJson(res.data ?? {});
    if (response.results.isEmpty) return 0;
    final r = response.results.first;
    if (r.accepted) {
      if (r.revision > 0) {
        await _syncState.upsertRevision('book', book.uuid, r.revision);
      }
      return 1;
    }
    return 0;
  }

  /// 仅拉取：应用服务器增量事件（手动同步页收尾用）。
  ///
  /// [onBookFiles]：每本书开始下载前的文件清单（uuid, 书名, 文件列表；失败重试用）。
  /// [onBookDownload]：每本书图片下载进度（uuid, 书名, 已完成文件数, 总文件数）。
  /// [onBookFileError]：单个图片下载失败（uuid, 相对路径, 错误对象）。
  Future<int> pullOnly({
    void Function(String uuid, String name, List<BookFileMeta> files)? onBookFiles,
    void Function(String uuid, String name, int done, int total)? onBookDownload,
    void Function(String uuid, String relPath, Object error)? onBookFileError,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    return _pullEvents(
      url,
      Options(headers: {'Authorization': 'Bearer $token'}),
      onBookFiles: onBookFiles,
      onBookDownload: onBookDownload,
      onBookFileError: onBookFileError,
    );
  }

  /// 重试单本书的图片下载（同步下载页失败项"重试"用）。
  ///
  /// [files] 为拉取事件里上报的文件清单（onBookFiles 回调拿到），
  /// 已存在且大小一致的文件自动跳过；全部成功返回 true。
  ///
  /// 首次拉取全失败时该书未落库（避免脏数据），重试成功后会补插元数据。
  Future<bool> retryBookFiles({
    required String uuid,
    required String name,
    required List<BookFileMeta> files,
    void Function(int done, int total)? onProgress,
    void Function(String relPath, Object error)? onFileError,
  }) async {
    var ok = true;
    final (downloaded, failedCount) = await _downloadBookFiles(
      uuid,
      files,
      onProgress: onProgress,
      onFileError: (relPath, err) {
        ok = false;
        onFileError?.call(relPath, err);
      },
    );
    if (downloaded.isEmpty || failedCount > 0) return ok;

    // 书不存在（首次全失败未落库）→ 先补插元数据
    if (await _books.getBookByUuid(uuid) == null) {
      await _books.upsertSyncedBook(uuid: uuid, name: name);
    }

    final localSubPaths = <String>[];
    String? coverSubPath;
    for (final item in downloaded) {
      if (item.relPath == 'cover.jpg') {
        coverSubPath = '${uuid}/${item.relPath}';
      } else {
        localSubPaths.add('${uuid}/${item.relPath}');
      }
    }
    await _books.updateSyncedBookFiles(
      uuid: uuid,
      localSubPaths: localSubPaths,
      coverSubPath: coverSubPath,
    );
    return ok;
  }

  /// 服务端当前库状态（§2.1 分支检测：远程书数 + 整库版本）。
  Future<LibraryStatus> libraryStatus() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final res = await _dio.get<Map<String, dynamic>>(
      '$url/api/v1/sync/library',
      options: options,
    );
    return LibraryStatus.fromJson(res.data ?? {});
  }

  /// 服务端全量书清单（含每本书完整文件清单），初始化同步下载分支用（§2.1.2）。
  Future<List<RemoteLibraryBook>> libraryBooks() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final res = await _dio.get<dynamic>(
      '$url/api/v1/sync/books',
      options: options,
    );
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => RemoteLibraryBook.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 归档历史列表（时间倒序）。
  Future<List<BookHistory>> listHistory({String? bookId}) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final res = await _dio.get<Map<String, dynamic>>(
      '$url/api/v1/books/history',
      queryParameters: bookId != null ? {'book_id': bookId} : null,
      options: options,
    );
    return HistoryListResponse.fromJson(res.data ?? {}).history;
  }

  /// 整库恢复：服务器用快照整体替换 current_book，随后调用方应 pullOnly() 应用本地。
  Future<BookRestoreResponse> restoreBook({required int historyId}) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final res = await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/books/restore',
      data: BookRestoreRequest(historyId: historyId).toJson(),
      options: options,
    );
    return BookRestoreResponse.fromJson(res.data ?? {});
  }

  /// 客户端驱动：把操作前捕获的整库快照同步为一条历史记录。
  Future<void> recordHistory({
    required String opType,
    required String tag,
    required List<BookSnapshotItem> snapshot,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/books/history',
      data: RecordHistoryRequest(opType: opType, tag: tag, snapshot: snapshot).toJson(),
      options: options,
    );
  }

  /// 未解决冲突列表（跨设备）。
  Future<List<SyncConflict>> listConflicts() async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      return const [];
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final res = await _dio.get<Map<String, dynamic>>(
      '$url/api/v1/conflicts',
      options: options,
    );
    return ConflictListResponse.fromJson(res.data ?? {}).conflicts;
  }

  /// 解决冲突：keep_local / keep_server / manual（manual 需传 payload）。
  /// 解决后应 pullOnly() 让本地收敛到胜方状态。
  Future<void> resolveConflict({
    required int conflictId,
    required String strategy,
    Map<String, dynamic>? payload,
  }) async {
    final url = await _settings.getString(SyncSettings.serverUrl);
    final token = await _settings.getString(SyncSettings.token);
    if (url == null || token == null) {
      throw StateError('尚未配置同步服务器');
    }
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    await _dio.post<Map<String, dynamic>>(
      '$url/api/v1/conflicts/$conflictId/resolve',
      data: ConflictResolveRequest(strategy: strategy, payload: payload).toJson(),
      options: options,
    );
  }

  /// 拉取服务器增量事件并应用到本地书库，推进游标。
  ///
  /// 任一图片下载失败时**不推进游标**：下次拉取会重新遇到同一批事件，
  /// 已成功下载的文件按 hash+size 命中跳过，失败文件自动重试。
  Future<int> _pullEvents(
    String url,
    Options options, {
    void Function(String uuid, String name, List<BookFileMeta> files)? onBookFiles,
    void Function(String uuid, String name, int done, int total)? onBookDownload,
    void Function(String uuid, String relPath, Object error)? onBookFileError,
  }) async {
    var cursor = int.tryParse(await _settings.getString(SyncSettings.cursor) ?? '') ?? 0;
    var applied = 0;
    var hasFailed = false;

    while (true) {
      final res = await _dio.get<Map<String, dynamic>>(
        '$url/api/v1/sync/pull',
        queryParameters: {'cursor': cursor, 'limit': 500},
        options: options,
      );
      final data = SyncPullResponse.fromJson(res.data ?? {});

      for (final e in data.events) {
        if (e.entityType == 'book') {
          // §7 冲突保护：待解决冲突的书，pull 不得覆盖本地内容/响应墓碑，
          // 只回填 revision（冲突解决动作负责收敛内容）
          final conflicted = _conflictUuidSet.contains(e.entityId);
          if (conflicted && e.op == 'upsert') {
            if (e.revision > 0) {
              await _syncState.upsertRevision('book', e.entityId, e.revision);
            }
            applied++;
            continue;
          }
          if (conflicted && (e.op == 'delete' || e.op == 'progress')) {
            applied++;
            continue;
          }
          if (e.op == 'upsert') {
            final payload = e.payload ?? const BookPayload(name: '未知书名');
            // 1. 先上报文件清单（失败重试用）
            onBookFiles?.call(e.entityId, payload.name, payload.files);
            // 2. 下载缺失图片（按 hash，已有且大小一致则跳过）
            final (downloaded, failedCount) = await _downloadBookFiles(
              e.entityId,
              payload.files,
              onProgress: onBookDownload == null
                  ? null
                  : (done, total) =>
                        onBookDownload(e.entityId, payload.name, done, total),
              onFileError: (relPath, err) {
                // 无论外部是否监听，失败都要记下：游标不推进 → 下次自动补下
                hasFailed = true;
                onBookFileError?.call(e.entityId, relPath, err);
              },
            );
            // 3. 只有**全部图片都下载成功**才落库（元数据 + 回填路径）：
            //    只要有任意一张失败，这本书就完全不落库 → 本地不留脏数据；
            //    游标未推进，下次拉取自动重试，全部成功后再落库。
            //    （已存在的书也仅在本次全部成功时更新，避免覆盖为脏状态）
            if (downloaded.isNotEmpty && failedCount == 0) {
              await _books.upsertSyncedBook(
                uuid: e.entityId,
                name: payload.name,
                currentPage: payload.currentPage,
              );
              if (e.revision > 0) {
                await _syncState.upsertRevision('book', e.entityId, e.revision);
              }
              final localSubPaths = <String>[];
              String? coverSubPath;
              for (final item in downloaded) {
                if (item.relPath == 'cover.jpg') {
                  coverSubPath = '${e.entityId}/${item.relPath}';
                } else {
                  localSubPaths.add('${e.entityId}/${item.relPath}');
                }
              }
              await _books.updateSyncedBookFiles(
                uuid: e.entityId,
                localSubPaths: localSubPaths,
                coverSubPath: coverSubPath,
              );
            }
          } else if (e.op == 'delete') {
            // 删除：优先走完整清理（DB + 本地图片文件）
            final row = await _books.getBookByUuid(e.entityId);
            if (row != null) {
              await _books.deleteBook(row.id);
            } else {
              await _books.deleteBookByUuid(e.entityId);
            }
            await _syncState.deleteState('book', e.entityId);
          } else if (e.op == 'progress') {
            // 阅读进度（§3）：只更新本地 book.current_page，不建书、不记快照。
            // 若本地 outbox 仍有该书待推的进度/编辑（本地更新更晚），跳过，
            // 避免用旧事件覆盖自己刚推进的进度（§4 多设备收敛）。
            if (_protectedBookIds == null) {
              final pending =
                  await ref.read(syncTaskLocalDatasourceProvider).listPending();
              _protectedBookIds = pending
                  .where(
                    (t) =>
                        t.entityType == 'book' &&
                        (t.op == 'progress' || t.op == 'upsert'),
                  )
                  .map((t) => t.entityId)
                  .toSet();
            }
            if (_protectedBookIds!.contains(e.entityId)) {
              continue;
            }
            final payload = e.payload ?? const BookPayload(name: '');
            final local = await _books.getBookByUuid(e.entityId);
            if (local != null && payload.currentPage != local.currentPage) {
              await _books.updateBook(
                local.copyWith(currentPage: payload.currentPage),
              );
            }
          }
        }
        applied++;
      }

      cursor = data.cursor;
      if (!data.hasMore) break;
    }

    // 有图片下载失败：游标保持原值，下次拉取重新处理并补下失败文件
    if (!hasFailed) {
      await _settings.setString(SyncSettings.cursor, '$cursor');
    }
    return applied;
  }

  /// 按 hash 下载事件里引用的图片；返回实际下载/已存在的文件项 + 失败数。
  ///
  /// [onProgress]：已完成文件数 / 总文件数（含已存在跳过的）。
  /// [onFileError]：单个文件下载失败回调（相对路径, 错误对象），不中断整本书。
  Future<(List<BookFileItem>, int)> _downloadBookFiles(
    String uuid,
    List<BookFileMeta> files, {
    void Function(int done, int total)? onProgress,
    void Function(String relPath, Object error)? onFileError,
  }) async {
    final result = <BookFileItem>[];
    var done = 0;
    var failed = 0;
    for (final f in files) {
      if (f.relPath.isEmpty || f.hash.isEmpty) {
        done++;
        onProgress?.call(done, files.length);
        continue;
      }

      final dest = GlobalConfig.resolveBookPath('$uuid/${f.relPath}');
      // 已存在且大小一致 → 视为已有，跳过下载
      final existing = File(dest);
      if (await existing.exists() && existing.lengthSync() == f.size) {
        result.add(
          BookFileItem(relPath: f.relPath, absPath: dest, hash: f.hash, size: f.size),
        );
        done++;
        onProgress?.call(done, files.length);
        continue;
      }
      try {
        await _fileSync.downloadFile(hash: f.hash, destPath: dest);
        result.add(
          BookFileItem(relPath: f.relPath, absPath: dest, hash: f.hash, size: f.size),
        );
      } catch (e) {
        failed++;
        AppLog.e('下载图片失败 ${f.hash}: $e');
        // 清理下载中断留下的半截文件，避免下次误判为"已存在"
        if (await existing.exists()) {
          try {
            await existing.delete();
          } catch (_) {}
        }
        onFileError?.call(f.relPath, e);
      }
      done++;
      onProgress?.call(done, files.length);
    }
    return (result, failed);
  }
}

/// 服务端库状态（§2.1 分支检测）。
class LibraryStatus {
  final int bookCount;
  final String bookVersion;

  const LibraryStatus({required this.bookCount, required this.bookVersion});

  factory LibraryStatus.fromJson(Map<String, dynamic> json) => LibraryStatus(
        bookCount: (json['book_count'] as num?)?.toInt() ?? 0,
        bookVersion: json['book_version'] as String? ?? '',
      );
}

/// 服务端远程书籍（含完整文件清单 + revision），初始化同步下载分支用。
/// revision = 服务器 current_book 的版本号，客户端下载/比对后回填本地
/// sync_state（§2.1.5 乐观锁基准），否则之后编辑推送会因 base=0 被拒绝。
class RemoteLibraryBook {
  final String uuid;
  final String name;
  final int currentPage;
  final String? coverHash;
  final List<BookFileMeta> files;
  final int revision;

  const RemoteLibraryBook({
    required this.uuid,
    required this.name,
    this.currentPage = 0,
    this.coverHash,
    this.files = const [],
    this.revision = 0,
  });

  factory RemoteLibraryBook.fromJson(Map<String, dynamic> json) =>
      RemoteLibraryBook(
        uuid: json['uuid'] as String? ?? '',
        name: json['name'] as String? ?? '',
        currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
        coverHash: json['cover_hash'] as String?,
        files: ((json['files'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(BookFileMeta.fromJson)
            .toList(),
        revision: (json['revision'] as num?)?.toInt() ?? 0,
      );
}
