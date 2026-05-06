import 'package:tele_book/feature/download/enum/download_status.dart';

class DownloadGroupBo {
  final String id;
  final String name;
  final int totalCount;
  final int errorCount;
  final int successCount;
  final String saveParentPath;
  final DownloadStatus status;

  DownloadGroupBo({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.errorCount,
    required this.successCount,
    required this.saveParentPath,
    required this.status,
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
  }) {
    return DownloadGroupBo(
      id: id ?? this.id,
      name: name ?? this.name,
      totalCount: totalCount ?? this.totalCount,
      errorCount: errorCount ?? this.errorCount,
      successCount: successCount ?? this.successCount,
      saveParentPath: saveParentPath ?? this.saveParentPath,
      status: status ?? this.status,
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
