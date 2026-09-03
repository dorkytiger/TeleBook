import 'package:tele_book/feature/download/enum/download_status.dart';

class DownloadGroupBo {
  final String id;
  final String name;
  final int totalCount;
  final int errorCount;
  final int successCount;
  final String saveParentPath;
  final DownloadStatus status;

  /// 是否已全部下载成功并自动保存为书籍。
  final bool savedToBook;

  /// 下载全部完成后，是否正处于自动保存为书籍的处理阶段
  /// （生成封面/预览图并写库，可能耗时较长）。
  final bool processing;

  DownloadGroupBo({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.errorCount,
    required this.successCount,
    required this.saveParentPath,
    required this.status,
    this.savedToBook = false,
    this.processing = false,
  });

  int completeCount() => errorCount + successCount;

  DownloadGroupBo copyWith({
    String? id,
    String? name,
    int? totalCount,
    int? errorCount,
    int? successCount,
    String? saveParentPath,
    DownloadStatus? status,
    bool? savedToBook,
    bool? processing,
  }) {
    return DownloadGroupBo(
      id: id ?? this.id,
      name: name ?? this.name,
      totalCount: totalCount ?? this.totalCount,
      errorCount: errorCount ?? this.errorCount,
      successCount: successCount ?? this.successCount,
      saveParentPath: saveParentPath ?? this.saveParentPath,
      status: status ?? this.status,
      savedToBook: savedToBook ?? this.savedToBook,
      processing: processing ?? this.processing,
    );
  }
}

class DownloadItemBo {
  final String id;
  final String groupId;
  final String url;
  final double progress;
  final String saveSubPath;
  final DownloadStatus status;
  final int order;

  DownloadItemBo({
    required this.id,
    required this.groupId,
    required this.url,
    required this.progress,
    required this.saveSubPath,
    required this.status,
    required this.order,
  });

  DownloadItemBo copyWith({
    String? id,
    String? groupId,
    String? url,
    double? progress,
    String? saveSubPath,
    DownloadStatus? status,
    int? order,
  }) {
    return DownloadItemBo(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      saveSubPath: saveSubPath ?? this.saveSubPath,
      status: status ?? this.status,
      order: order ?? this.order,
    );
  }
}
