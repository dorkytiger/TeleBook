import 'package:tele_book/feature/download/datasource/runtime/download_runtime_datasource.dart';
import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/model/vo/download_vo.dart';

class DownloadRepository {
  final DownloadRuntimeDatasource _downloadRuntimeDatasource;

  DownloadRepository(this._downloadRuntimeDatasource);

  Stream<List<DownloadTaskVO>> watchDownloadList() {
    return _downloadRuntimeDatasource.downloadList();
  }

  DownloadItemBo? getDownloadTask(String itemId) {
    return _downloadRuntimeDatasource.getItem(itemId);
  }

  DownloadGroupBo ? getDownloadGroup(String groupId) {
    return _downloadRuntimeDatasource.getGroup(groupId);
  }

  List<DownloadItemBo> getDownloadItemsByGroup(String groupId) {
    return _downloadRuntimeDatasource.getItemsByGroup(groupId);
  }


  void upsertGroup(DownloadGroupBo group) {
    _downloadRuntimeDatasource.upsertGroup(group);
  }

  void upsertItem(DownloadItemBo task) {
    _downloadRuntimeDatasource.upsertItem(task);
  }

  void deleteGroup(String groupId) {
    _downloadRuntimeDatasource.removeGroup(groupId);
  }

  void deleteItem(String itemId) {
    _downloadRuntimeDatasource.removeItem(itemId);
  }
}
