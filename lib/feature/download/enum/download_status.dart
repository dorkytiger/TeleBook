enum DownloadStatus {
  pending('处理中'),
  downloading('下载中'),
  paused('已暂停'),
  completed('已完成'),
  failed('下载失败');

  final String description;

  const DownloadStatus(this.description);
}
