import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/core/service/sync_service.dart';
import 'package:tele_book/feature/sync/model/request/history_request.dart';
import 'package:tele_book/feature/sync/model/response/history_response.dart';

/// 一条归档历史记录（展示用）。
class SyncHistoryItem {
  final int id;
  final String opType; // import / modify / delete / manual_sync / restore
  final String tag; // manual / auto
  final int bookCount; // 快照中的书籍数
  final List<BookSnapshotItem> books; // 快照中的书籍（归档详情页用）
  final DateTime createdAt;

  const SyncHistoryItem({
    required this.id,
    required this.opType,
    required this.tag,
    required this.bookCount,
    required this.books,
    required this.createdAt,
  });

  factory SyncHistoryItem.fromBookHistory(BookHistory h) {
    return SyncHistoryItem(
      id: h.id,
      opType: h.opType,
      tag: h.tag,
      bookCount: h.payload?.length ?? 0,
      books: h.payload ?? const [],
      createdAt: h.createdAt.toLocal(),
    );
  }

  String get opLabel => switch (opType) {
        'import' => '导入书籍',
        'modify' => '修改书籍',
        'delete' => '删除书籍',
        'manual_sync' => '手动同步',
        'restore' => '恢复',
        _ => opType,
      };

  String get tagLabel => tag == 'manual' ? '手动' : '自动';
}

final syncHistoryProvider = FutureProvider.autoDispose<List<SyncHistoryItem>>((
  ref,
) async {
  final sync = ref.read(syncServiceProvider.notifier);
  final history = await sync.listHistory();
  return history.map(SyncHistoryItem.fromBookHistory).toList();
});
