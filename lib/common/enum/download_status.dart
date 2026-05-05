enum DownloadStatus {
  notStarted(0),
  inProgress(1),
  completed(2),
  failed(3);

  final int value;
  const DownloadStatus(this.value);
}