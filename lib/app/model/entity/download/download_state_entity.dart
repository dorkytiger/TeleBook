class DownloadState {
  String link;
  double progress;
  double proImg;
  String preview;
  int pageSize;
  int page;
  int state;

  DownloadState({
    required this.link,
    required this.progress,
    required this.proImg,
    required this.preview,
    required this.pageSize,
    required this.page,
    required this.state,
  });
}