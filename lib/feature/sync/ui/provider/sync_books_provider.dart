import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';

/// 单本书的同步进度状态。
enum SyncBookStatus { pending, syncing, done, failed }

class BookSyncProgress {
  final String uuid;
  final String name;
  final SyncBookStatus status;
  final double progress; // 0.0–1.0

  const BookSyncProgress({
    required this.uuid,
    required this.name,
    required this.status,
    required this.progress,
  });

  BookSyncProgress copyWith({SyncBookStatus? status, double? progress}) {
    return BookSyncProgress(
      uuid: uuid,
      name: name,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}

class SyncBooksState {
  final bool running;
  final List<BookSyncProgress> books;
  final int doneCount;
  final int failedCount;

  const SyncBooksState({
    this.running = false,
    this.books = const [],
    this.doneCount = 0,
    this.failedCount = 0,
  });

  double get overallProgress {
    if (books.isEmpty) return 0;
    final sum = books.fold<double>(0, (acc, b) => acc + b.progress);
    return sum / books.length;
  }

  SyncBooksState copyWith({
    bool? running,
    List<BookSyncProgress>? books,
    int? doneCount,
    int? failedCount,
  }) {
    return SyncBooksState(
      running: running ?? this.running,
      books: books ?? this.books,
      doneCount: doneCount ?? this.doneCount,
      failedCount: failedCount ?? this.failedCount,
    );
  }
}

/// 手动同步页状态：全部书籍 + 每本进度条。
class SyncBooksNotifier extends Notifier<SyncBooksState> {
  @override
  SyncBooksState build() => const SyncBooksState();

  /// 开始同步所有书籍：先 drain outbox（推送待同步变更），
  /// 再逐本全量推送（source=manual，含图片文件进度），完成后 pull 一次。
  Future<void> start() async {
    if (state.running) return;
    final syncService = ref.read(syncServiceProvider.notifier);
    final books = await ref.read(bookRepositoryProvider).getAllBooks();
    if (books.isEmpty) {
      state = state.copyWith(running: false);
      return;
    }

    state = SyncBooksState(
      running: true,
      books: [
        for (final b in books)
          BookSyncProgress(
            uuid: b.uuid,
            name: b.name,
            status: SyncBookStatus.pending,
            progress: 0,
          ),
      ],
    );

    final mutation = ref.read(syncMutationServiceProvider);
    var ok = true;
    await mutation.beginSyncSession(); // 本地同步记录：会话开始
    // 先把本地待同步变更推出去（保持顺序）
    try {
      await mutation.drain();
    } catch (_) {
      ok = false;
    }

    for (final book in books) {
      try {
        final ok = await syncService.pushBookManual(
          book: book,
          onFileProgress: (p) => _update(book.uuid, progress: p),
        );
        _update(
          book.uuid,
          status: ok > 0 ? SyncBookStatus.done : SyncBookStatus.failed,
          progress: 1,
        );
      } catch (e) {
        _update(book.uuid, status: SyncBookStatus.failed);
      }
    }

    // 收尾：拉取一次，应用其它设备的变更
    try {
      var failedFiles = 0;
      await syncService.pullOnly(
        onBookFileError: (uuid, relPath, error) {
          failedFiles++;
        },
      );
      if (failedFiles > 0) {
        mutation.reportError('有 $failedFiles 张图片下载失败，将在下次自动同步时重试');
      }
    } catch (_) {}

    // 记录本次手动同步（快照 = 同步完成后的书库状态）
    try {
      final postSnapshot = await mutation.buildSnapshot();
      await mutation.recordManualSync(snapshot: postSnapshot);
    } catch (_) {
      ok = false;
    }

    await mutation.endSyncSession(ok: ok);
    state = state.copyWith(running: false);
  }

  void _update(String uuid, {double? progress, SyncBookStatus? status}) {
    final books = state.books
        .map(
          (b) => b.uuid == uuid
              ? b.copyWith(
                  progress: progress ?? b.progress,
                  status: status ?? b.status,
                )
              : b,
        )
        .toList();
    final done = books.where((b) => b.status == SyncBookStatus.done).length;
    final failed = books.where((b) => b.status == SyncBookStatus.failed).length;
    state = SyncBooksState(
      running: state.running,
      books: books,
      doneCount: done,
      failedCount: failed,
    );
  }
}

final syncBooksProvider =
    NotifierProvider<SyncBooksNotifier, SyncBooksState>(SyncBooksNotifier.new);
