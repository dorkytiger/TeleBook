import 'package:tele_book/feature/download/model/bo/download_bo.dart';

class DownloadTaskVO {
  final DownloadGroupBo downloadGroupBo;
  final List<DownloadItemBo> downloadItemBoList;

  DownloadTaskVO({
    required this.downloadGroupBo,
    required this.downloadItemBoList,
  });
}
