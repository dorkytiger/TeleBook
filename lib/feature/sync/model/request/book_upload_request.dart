import 'package:json_annotation/json_annotation.dart';
import 'package:tele_book/feature/sync/model/request/sync_request.dart';

part 'book_upload_request.g.dart';

/// init 上传：客户端上报一组书（§2.1.3）。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookUploadInitRequest {
  final List<BookUploadInitBook> books;

  const BookUploadInitRequest({required this.books});

  factory BookUploadInitRequest.fromJson(Map<String, dynamic> json) =>
      _$BookUploadInitRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BookUploadInitRequestToJson(this);
}

/// init 的单本书。
@JsonSerializable(fieldRename: FieldRename.snake)
class BookUploadInitBook {
  /// 客户端本地 uuid（§6 方案1：上传保留）；空则服务器分配。
  final String uuid;
  final String clientId;
  final String name;
  final String? dataVersion;
  final List<BookFileMeta> files;

  const BookUploadInitBook({
    this.uuid = '',
    required this.clientId,
    required this.name,
    this.dataVersion,
    this.files = const [],
  });

  factory BookUploadInitBook.fromJson(Map<String, dynamic> json) =>
      _$BookUploadInitBookFromJson(json);
  Map<String, dynamic> toJson() => _$BookUploadInitBookToJson(this);
}

/// init 响应。
class BookUploadInitResponse {
  final List<BookUploadInitResult> books;

  const BookUploadInitResponse({required this.books});

  factory BookUploadInitResponse.fromJson(Map<String, dynamic> json) =>
      BookUploadInitResponse(
        books: ((json['books'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(BookUploadInitResult.fromJson)
            .toList(),
      );
}

/// init 单本结果。
class BookUploadInitResult {
  final String clientId;
  final String uuid;
  final int totalFiles;
  final List<BookFileMeta> pendingFiles;

  const BookUploadInitResult({
    required this.clientId,
    required this.uuid,
    required this.totalFiles,
    this.pendingFiles = const [],
  });

  factory BookUploadInitResult.fromJson(Map<String, dynamic> json) =>
      BookUploadInitResult(
        clientId: json['client_id'] as String? ?? '',
        uuid: json['uuid'] as String? ?? '',
        totalFiles: (json['total_files'] as num?)?.toInt() ?? 0,
        pendingFiles: ((json['pending_files'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(BookFileMeta.fromJson)
            .toList(),
      );
}

/// 上传完成请求。
class BookUploadCompleteRequest {
  final String uuid;

  const BookUploadCompleteRequest({required this.uuid});
}

/// 上传完成响应。
class BookUploadCompleteResponse {
  final String uuid;
  final bool done;
  final String? reason;

  /// 整本落库后服务器 current_book 的版本号（客户端回填 sync_state 作乐观锁基准）。
  final int revision;

  const BookUploadCompleteResponse({
    required this.uuid,
    required this.done,
    this.reason,
    this.revision = 0,
  });

  factory BookUploadCompleteResponse.fromJson(Map<String, dynamic> json) =>
      BookUploadCompleteResponse(
        uuid: json['uuid'] as String? ?? '',
        done: json['done'] == true,
        reason: json['reason'] as String?,
        revision: (json['revision'] as num?)?.toInt() ?? 0,
      );
}
