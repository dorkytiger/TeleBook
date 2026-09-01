import 'dart:convert';

/// 本地同步会话（一条同步记录的运行态，含每本/每文件状态）。
///
/// detail JSON 结构：{"books":[{"uuid","name","status","files":[{"rel","status"}]}]}
/// 会话级 status: running / completed / failed；book/file 级: pending / syncing / done / failed。
class SyncLogSession {
  final int id;
  final DateTime startedAt;
  final Map<String, SyncLogSessionBook> _books = {};
  String status = 'running';

  SyncLogSession({required this.id, required this.startedAt});

  List<SyncLogSessionBook> get books => _books.values.toList();

  /// 按 uuid 取书（无则 null）。
  SyncLogSessionBook? bookByUuid(String uuid) => _books[uuid];

  int get totalBooks => _books.length;
  int get syncedBooks => _books.values.where((b) => b.status == 'done').length;
  int get failedBooks => _books.values.where((b) => b.status == 'failed').length;

  SyncLogSessionBook book(String uuid, String name) {
    return _books.putIfAbsent(
      uuid,
      () => SyncLogSessionBook(uuid: uuid, name: name),
    );
  }

  /// 序列化为 detail JSON（落库）。
  String toDetailJson() {
    return jsonEncode({
      'books': [
        for (final b in _books.values)
          {
            'uuid': b.uuid,
            'name': b.name,
            'status': b.status,
            'files': [
              for (final e in b.files.entries)
                {'rel': e.key, 'status': e.value},
            ],
          },
      ],
    });
  }
}

class SyncLogSessionBook {
  final String uuid;
  final String name;
  String status = 'pending'; // pending / syncing / done / failed
  final Map<String, String> files = {}; // relPath -> status

  SyncLogSessionBook({required this.uuid, required this.name});

  int get filesTotal => files.length;
  int get filesDone =>
      files.values.where((s) => s == 'done').length;
  int get filesFailed =>
      files.values.where((s) => s == 'failed').length;

  double get ratio => filesTotal == 0
      ? (status == 'done' ? 1.0 : 0.0)
      : filesDone / filesTotal;
}
