import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/service/sync_native_service.dart';
import 'package:tele_book/core/util/file_log.dart';
import 'package:tele_book/feature/sync/datasource/sync_op_local_datasource.dart';

/// 任务类型（组 = 一次用户操作）。
class SyncOpType {
  static const init = 'init'; // 初始化同步
  static const refresh = 'refresh'; // 刷新同步
  static const uploadSnapshot = 'upload_snapshot'; // 上传快照
  static const manual = 'manual'; // 手动同步
  static const conflict = 'conflict'; // 冲突解决（保留服务器 / 保留本地）
  static const resume = 'resume'; // 恢复上次未完成的同步（断点续传，§8.0/§8.1）
  static const push = 'push'; // 本地变更推送（添加/编辑/删除/导入 → 服务器，§8.5）

  static String titleOf(String type) => switch (type) {
        init => '初始化同步',
        refresh => '刷新同步',
        uploadSnapshot => '上传快照',
        manual => '手动同步',
        conflict => '冲突处理',
        resume => '恢复上次同步',
        push => '同步本地变更',
        _ => type,
      };
}

/// 任务状态。
class SyncOpStatus {
  static const running = 'running'; // 进行中
  static const waiting = 'waiting'; // 等待中
  static const done = 'done'; // 成功
  static const failed = 'failed'; // 失败
  static const interrupted = 'interrupted'; // 中断

  static String labelOf(String status) => switch (status) {
        running => '进行中',
        waiting => '等待中',
        done => '完成',
        failed => '失败',
        interrupted => '已中断',
        _ => status,
      };
}

/// 组任务进度回调：更新当前任务的书数/页数进度。
class SyncOpProgress {
  final int currentBook; // 当前第几本（1-based）
  final int totalBooks;
  final int currentPage; // 当前书第几页
  final int totalPages;

  const SyncOpProgress({
    this.currentBook = 0,
    this.totalBooks = 0,
    this.currentPage = 0,
    this.totalPages = 0,
  });
}

/// 组内单个文件的运行态（§0 明细面板：展开书本后每页一行）。
class SyncOpFileDetail {
  final String relPath;
  final String status; // pending / syncing / done / failed
  final double progress; // 0.0–1.0
  final String? error;

  const SyncOpFileDetail({
    required this.relPath,
    required this.status,
    this.progress = 0,
    this.error,
  });
}

/// 组内一本书的运行态（§0 明细面板：任务 → 书列表 → 每页）。
/// [direction]：该书当前/预定的同步方向（upload=上传 / download=下载）；
/// [status]=pending 表示还没轮到（等待中）。
class SyncOpBookDetail {
  final String uuid;
  final String name;
  final String status; // pending(等待中) / syncing / done / failed
  final String? direction; // upload / download
  final List<SyncOpFileDetail> files;

  const SyncOpBookDetail({
    required this.uuid,
    required this.name,
    required this.status,
    this.direction,
    this.files = const [],
  });

  int get doneFiles => files.where((f) => f.status == 'done').length;
  int get failedFiles => files.where((f) => f.status == 'failed').length;
}

/// 同步操作任务系统：队列按「组（一次操作）」串行 + 状态落库 + 中断恢复。
///
/// - 每个用户操作 = 一组任务（含多书×多图），入队后串行执行，不并发。
/// - 任务状态（running/waiting/done/failed/interrupted）持久化到 sync_op_table，
///   App 启动时收割遗留 running 为 interrupted（§8.0）。
/// - [opState] 通过 ValueNotifier 对外暴露当前运行状态，供全局通知/明细面板/本地记录订阅。
/// - 组内书/页运行态（[SyncOpDetailWriter]，仅运行期、内存态）供 §0 明细面板展示
///   逐书逐页进度；任务到达终态即清理（历史归档在 sync_op_table 行级）。
class SyncOpService {
  final SyncOpLocalDatasource _ops;

  /// 队列中/运行中任务的可观察状态（全局通知 + 明细面板 + 本地记录订阅）。
  final ValueNotifier<SyncOpView> opState = ValueNotifier(const SyncOpView());

  /// 队列是否正在排空（驱动底部"同步中"）。
  final ValueNotifier<bool> draining = ValueNotifier(false);

  /// 组内书/页运行态（taskId → 书列表）。每次变更自增 [opDetailRevision]，
  /// 明细面板据此重建（仅面板打开时有监听者，成本可忽略）。
  final Map<int, List<SyncOpBookDetail>> _detail = {};
  final ValueNotifier<int> opDetailRevision = ValueNotifier(0);

  bool _running = false;
  final List<_PendingOp> _pending = [];

  /// 已入队任务的执行器（taskId → op）。成功完成即移除；失败/中断保留，
  /// 供会话内「重试」直接重跑同一执行器（§0：组/页错误重试）。
  /// App 重启后该表为空 → 重试需重新发起（P2：持久化任务规格后重启可续）。
  final Map<int, _PendingOp> _work = {};

  SyncOpService(this._ops);

  /// 入队一个组任务。executor 收到 [SyncOpProgressCallback]（行级进度）与
  /// [SyncOpDetailWriter]（组内书/页明细，可选上报）。
  /// [title] 缺省用类型默认名；[payload] 为组任务规格 JSON（落库，
  /// 重启后可据它重建执行，§8.0）。
  /// 返回任务 id。
  Future<int> enqueue({
    required String type,
    required SyncOpExecutor executor,
    String? title,
    String? payload,
  }) async {
    final id = await _ops.insertTask(
      type: type,
      title: title ?? SyncOpType.titleOf(type),
      payload: payload,
    );
    final op = _PendingOp(id, executor);
    _pending.add(op);
    _work[id] = op;
    _refreshView(); // 队列新增，立即刷新本地记录
    // 触发一次排空（若已在运行，则本次入队由正在跑的循环接管）
    unawaited(_drain());
    return id;
  }

  /// 遗留可恢复的内容型任务（type=push、带 payload、状态 failed/interrupted）——
  /// 重启后 UI「继续推送」时按 payload 重建执行器恢复（§8.0）。
  Future<List<SyncOpTableData>> recoverablePushOps() async {
    final all = await _ops.listAll();
    return all
        .where((t) =>
            t.type == SyncOpType.push &&
            (t.status == SyncOpStatus.failed ||
                t.status == SyncOpStatus.interrupted) &&
            t.payload != null)
        .toList();
  }

  /// 用重建的执行器**恢复指定行**（§8.0 重启恢复）：把 failed/interrupted 的
  /// 原任务行置回 waiting 并重跑（与 [retryTask] 复用同一行语义一致——成功后
  /// 该行变 done，不会在队列里残留"已中断"旧行导致全局通知不消失）。
  /// 返回是否已调度（行不存在/状态不允许 → false）。
  Future<bool> retryWithExecutor(int id, SyncOpExecutor executor) async {
    final rows = await _ops.listAll();
    final row = rows.where((r) => r.id == id).firstOrNull;
    if (row == null ||
        (row.status != SyncOpStatus.failed &&
            row.status != SyncOpStatus.interrupted)) {
      return false;
    }
    if (_pending.any((o) => o.id == id)) return false; // 已在队中
    await _ops.updateTask(id, status: SyncOpStatus.waiting, error: null);
    final op = _PendingOp(id, executor);
    _pending.insert(0, op); // 队首优先
    _work[id] = op;
    _refreshView();
    unawaited(_drain());
    return true;
  }

  /// 组内书/页明细（运行中的任务）。任务结束后清空。
  List<SyncOpBookDetail> detailOf(int taskId) =>
      List.unmodifiable(_detail[taskId] ?? const []);

  /// 为某运行中任务打开一个明细写入器（供外部动作——如页级重试——继续上报状态）。
  SyncOpDetailWriter openDetailWriter(int taskId) =>
      SyncOpDetailWriter(taskId, _detail, opDetailRevision);

  /// 排空队列：串行执行 pending 中的任务（按入队顺序，一组一组来）。
  ///
  /// 有任务执行时启动 Android 前台保活服务（熄屏不断网），排空后停止。
  Future<void> _drain() async {
    if (_running) return;
    _running = true;
    draining.value = true;
    final hasWork = _pending.isNotEmpty;
    FileLog.log('OPQ', 'drain start pending=$hasWork queue=${_pending.length}');
    if (hasWork) {
      await SyncNativeForeground.start('TeleBook 正在同步');
    }
    try {
      while (_pending.isNotEmpty) {
        final op = _pending.removeAt(0);
        final taskId = op.id;
        FileLog.log('OPQ', 'op start id=$taskId');
        _detail[taskId] = [];
        // 断点续传：执行前读该行已落库的进度（重跑/恢复时 doneBooks>0），
        // 注入 writer.resumeFrom，执行器据此从上次完成处继续（§8.1/§8.2）
        final row = (await _ops.listAll())
            .where((r) => r.id == taskId)
            .firstOrNull;
        final writer = SyncOpDetailWriter(
          taskId,
          _detail,
          opDetailRevision,
          resumeFrom: row?.doneBooks ?? 0,
        );
        // 前台通知文案随任务更新（低频）
        await SyncNativeForeground.update('${row?.title ?? '同步任务'}…');
        await _ops.updateTask(taskId, status: SyncOpStatus.running);
        _refreshView();
        try {
          await op.executor(
            (p) {
              _ops.updateTask(
                taskId,
                doneBooks: p.currentBook,
                totalBooks: p.totalBooks,
                currentPage: p.currentPage,
                totalPages: p.totalPages,
              );
              _refreshView();
            },
            writer,
          );
          await _ops.updateTask(taskId, status: SyncOpStatus.done);
          FileLog.log('OPQ', 'op done id=$taskId');
          _work.remove(taskId); // 成功：执行器不再需要（重试只针对失败/中断）
          _detail.remove(taskId); // 成功：清理运行态明细
        } catch (e) {
          FileLog.log('OPQ', 'op FAIL id=$taskId err=$e');
          await _ops.updateTask(taskId, status: SyncOpStatus.failed, error: '$e');
          // 失败：保留执行器供重试，也**保留明细**——弹层/详情页还能看到
          // 每本书/每张图片的失败状态与错误，并可就地重试（§0）
        } finally {
          opDetailRevision.value++;
        }
        _refreshView();
      }
    } finally {
      _running = false;
      draining.value = false;
      await SyncNativeForeground.stop();
      FileLog.log('OPQ', 'drain end');
      _refreshView();
    }
  }

  /// App 启动：收割遗留 running 为 interrupted。
  Future<void> recoverInterrupted() async {
    await _ops.markAllRunningInterrupted();
    _refreshView();
  }

  /// 遗留中断任务数（§8.0 启动提示：上次未完成是否继续）。
  Future<int> countInterrupted() async {
    final all = await _ops.listAll();
    return all.where((t) => t.status == SyncOpStatus.interrupted).length;
  }

  /// 会话内是否可重试（执行器仍在内存 + 任务处于失败/中断状态）。
  Future<bool> canRetry(int id) async {
    if (!_work.containsKey(id)) return false;
    final rows = await _ops.listAll();
    final row = rows.where((r) => r.id == id).firstOrNull;
    return row != null &&
        (row.status == SyncOpStatus.failed ||
            row.status == SyncOpStatus.interrupted);
  }

  /// 重试失败/中断任务（§0：重试全部/重试错误项）：直接重跑原执行器。
  ///
  /// 仅支持会话内（执行器在内存）的任务；App 重启后的遗留任务需重新发起
  /// （P2：任务规格落库后可跨重启恢复）。
  Future<void> retryTask(int id) async {
    if (!await canRetry(id)) return;
    if (_pending.any((o) => o.id == id)) return; // 已在队中，避免重复入队
    final op = _work[id]!;
    await _ops.updateTask(id, status: SyncOpStatus.waiting, error: null);
    _pending.insert(0, op); // 队首重试：失败任务优先于更早排队的其它任务
    _refreshView();
    unawaited(_drain());
  }

  /// 等待某任务到达终态（done / failed）。返回终态；超时返回 null。
  ///
  /// 供"执行完再给结果"的动作（如冲突解决：成功才移除冲突）在入队后等待
  /// 队列实际跑完该组任务，避免 UI 在任务完成前就结束 loading。
  Future<String?> waitUntilSettled(
    int id, {
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final completer = Completer<String?>();
    String? result;
    void check() {
      for (final r in opState.value.all) {
        if (r.id == id &&
            (r.status == SyncOpStatus.done || r.status == SyncOpStatus.failed)) {
          result = r.status;
          completer.complete(result);
          return;
        }
      }
    }

    opState.addListener(check);
    check();
    try {
      await completer.future.timeout(timeout);
    } on TimeoutException {
      result = null;
    } finally {
      opState.removeListener(check);
    }
    return result;
  }

  /// 队列里是否已有同类型的运行/等待任务（防连点重复入队，如上传快照/刷新）。
  Future<bool> hasActiveOfType(String type) async {
    final all = await _ops.listAll();
    return all.any((t) =>
        t.type == type &&
        (t.status == SyncOpStatus.running ||
            t.status == SyncOpStatus.waiting));
  }

  /// 取消一个**等待中**的任务（未开始执行）：从队列与内存移除并删除记录。
  /// 进行中（running）的任务不可取消（避免半途状态），返回 false。
  Future<bool> cancelTask(int id) async {
    final rows = await _ops.listAll();
    final row = rows.where((r) => r.id == id).firstOrNull;
    if (row == null || row.status != SyncOpStatus.waiting) return false;
    _pending.removeWhere((o) => o.id == id);
    _work.remove(id);
    await _ops.deleteTask(id);
    _detail.remove(id);
    opDetailRevision.value++;
    _refreshView();
    return true;
  }

  /// 丢弃某类型下所有 failed/interrupted 的历史行（如冲突已成功解决后，
  /// 清理针对同一冲突的失败尝试，避免底栏"失败/中断"入口残留提示）。
  Future<void> discardFailedOfType(String type) async {
    final rows = await _ops.listAll();
    var changed = false;
    for (final row in rows) {
      if (row.type == type &&
          (row.status == SyncOpStatus.failed ||
              row.status == SyncOpStatus.interrupted)) {
        _pending.removeWhere((o) => o.id == row.id);
        _work.remove(row.id);
        _detail.remove(row.id);
        await _ops.deleteTask(row.id);
        changed = true;
      }
    }
    if (changed) {
      opDetailRevision.value++;
      _refreshView();
    }
  }

  /// 当前运行任务 + 队列，供显示。
  void _refreshView() {
    unawaited(_loadView());
  }

  Future<void> _loadView() async {
    final all = await _ops.listAll();
    final pending = await _ops.listPending();
    opState.value = SyncOpView(
      all: all,
      current: pending.isNotEmpty ? pending.first : null,
      queueCount: pending.length,
    );
  }
}

/// 队列中的一项：任务 id + 执行器（绑定在一起，避免与数据库任务错配）。
class _PendingOp {
  final int id;
  final SyncOpExecutor executor;
  _PendingOp(this.id, this.executor);
}

/// 组任务执行器：progress 上报行级进度（书数/页数），detail 上报组内书/页明细。
typedef SyncOpExecutor =
    Future<void> Function(SyncOpProgressCallback progress, SyncOpDetailWriter detail);

/// 进度上报回调（组任务执行器用）。
typedef SyncOpProgressCallback = void Function(SyncOpProgress p);

/// 组内书/页明细写入器（§0）：绑定一个运行中的任务，幂等地按 uuid/relPath 更新。
///
/// 写操作 copy-on-write 后自增 [revision]（引用同一 notifier 的所有 writer
/// 共享计数，明细面板 watch 它重建）。
/// [resumeFrom]：本次执行开始前该任务已完成的**书级进度**（来自任务行落库的
/// doneBooks，重跑/恢复时用于断点续传，§8.1/§8.2）。
class SyncOpDetailWriter {
  final int taskId;
  final int resumeFrom;
  final Map<int, List<SyncOpBookDetail>> store;
  final ValueNotifier<int> revision;

  SyncOpDetailWriter(
    this.taskId,
    this.store,
    this.revision, {
    this.resumeFrom = 0,
  });

  /// 注册一本书（文件列表置 pending，书状态=等待中）。
  /// [direction]：upload/download；同 uuid 已注册则原地更新（保持列表顺序、
  /// 不重置书状态），供"预注册整批书再逐本处理"的场景。
  void book(
    String uuid,
    String name,
    List<String> relPaths, {
    String? direction,
  }) {
    final books = List<SyncOpBookDetail>.of(store[taskId] ?? const []);
    final idx = books.indexWhere((b) => b.uuid == uuid);
    if (idx >= 0) {
      final prev = books[idx];
      // 状态不变则仅更新方向/文件占位（等待中的书保持 pending 直到开始处理）
      final files = [
        for (final rel in relPaths)
          prev.files.firstWhere(
            (f) => f.relPath == rel,
            orElse: () => SyncOpFileDetail(relPath: rel, status: 'pending'),
          ),
      ];
      books[idx] = SyncOpBookDetail(
        uuid: uuid,
        name: name,
        status: prev.status,
        direction: direction ?? prev.direction,
        files: files,
      );
      store[taskId] = books;
      revision.value++;
      return;
    }
    books.add(SyncOpBookDetail(
      uuid: uuid,
      name: name,
      status: 'pending',
      direction: direction,
      files: [
        for (final rel in relPaths)
          SyncOpFileDetail(relPath: rel, status: 'pending'),
      ],
    ));
    store[taskId] = books;
    revision.value++;
  }

  /// 某本书开始处理（等待中 → 同步中）。
  void bookSyncing(String uuid) {
    final books = store[taskId];
    if (books == null) return;
    final idx = books.indexWhere((b) => b.uuid == uuid);
    if (idx < 0) return;
    final book = books[idx];
    if (book.status == 'syncing' || book.status == 'failed' || book.status == 'done') {
      return;
    }
    final updated = List<SyncOpBookDetail>.of(books);
    updated[idx] = SyncOpBookDetail(
      uuid: book.uuid,
      name: book.name,
      status: 'syncing',
      direction: book.direction,
      files: book.files,
    );
    store[taskId] = updated;
    revision.value++;
  }

  void fileSyncing(String uuid, String relPath, {double progress = 0}) =>
      _updateFile(uuid, relPath,
          status: 'syncing', progress: progress, error: null);

  void fileDone(String uuid, String relPath) => _updateFile(uuid, relPath,
      status: 'done', progress: 1, error: null);

  void fileFailed(String uuid, String relPath, {String? error}) =>
      _updateFile(uuid, relPath,
          status: 'failed', progress: 0, error: error ?? '失败');

  /// 整本收尾：ok → 未完成页全标 done、书 done；否则未完成页全标 failed、书 failed。
  void finishBook(String uuid, {required bool ok}) {
    final books = store[taskId];
    if (books == null) return;
    final idx = books.indexWhere((b) => b.uuid == uuid);
    if (idx < 0) return;
    final book = books[idx];
    final files = [
      for (final f in book.files)
        if (f.status == 'pending' || f.status == 'syncing')
          SyncOpFileDetail(
            relPath: f.relPath,
            status: ok ? 'done' : 'failed',
            progress: ok ? 1 : f.progress,
            error: ok ? null : (f.error ?? '同步失败'),
          )
        else
          f,
    ];
    final updated = List<SyncOpBookDetail>.of(books);
    updated[idx] = SyncOpBookDetail(
      uuid: book.uuid,
      name: book.name,
      status: ok ? 'done' : 'failed',
      direction: book.direction,
      files: files,
    );
    store[taskId] = updated;
    revision.value++;
  }

  void _updateFile(
    String uuid,
    String relPath, {
    required String status,
    required double progress,
    required String? error,
  }) {
    final books = store[taskId];
    if (books == null) return;
    final bIdx = books.indexWhere((b) => b.uuid == uuid);
    if (bIdx < 0) return;
    final book = books[bIdx];
    final fIdx = book.files.indexWhere((f) => f.relPath == relPath);
    if (fIdx < 0) return;
    final old = book.files[fIdx];
    if (old.status == status && old.progress == progress && old.error == error) {
      return; // 无变化不重建
    }
    final files = List<SyncOpFileDetail>.of(book.files);
    files[fIdx] = SyncOpFileDetail(
      relPath: relPath,
      status: status,
      progress: progress,
      error: error,
    );
    final updated = List<SyncOpBookDetail>.of(books);
    final hasFailed = files.any((f) => f.status == 'failed');
    final allDone = files.every((f) => f.status == 'done');
    updated[bIdx] = SyncOpBookDetail(
      uuid: book.uuid,
      name: book.name,
      status: hasFailed ? 'failed' : (allDone ? 'done' : 'syncing'),
      direction: book.direction,
      files: files,
    );
    store[taskId] = updated;
    revision.value++;
  }
}

/// 可观察视图：全部任务 + 当前任务 + 队列长度。
class SyncOpView {
  final List<SyncOpTableData> all;
  final SyncOpTableData? current;
  final int queueCount;

  const SyncOpView({
    this.all = const [],
    this.current,
    this.queueCount = 0,
  });
}

final syncOpServiceProvider = Provider<SyncOpService>((ref) {
  final service = SyncOpService(ref.watch(syncOpLocalDatasourceProvider));
  // 启动时收割中断（幂等）
  Future.microtask(service.recoverInterrupted);
  return service;
});

/// 当前队列任务（可 watch）：running 优先，否则队列头 waiting。
/// 全局通知/明细面板实时监听。
final syncOpQueueProvider = StreamProvider.autoDispose<List<SyncOpTableData>>((
  ref,
) {
  return ref.watch(syncOpLocalDatasourceProvider).watchAll();
});
