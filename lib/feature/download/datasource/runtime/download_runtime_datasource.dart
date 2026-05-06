import 'dart:async';
import 'dart:collection';

import 'package:tele_book/feature/download/model/bo/download_bo.dart';
import 'package:tele_book/feature/download/model/vo/download_vo.dart';

class DownloadRuntimeDatasource {
  final LinkedHashMap<String, DownloadGroupBo> _groupMap = LinkedHashMap();
  final LinkedHashMap<String, DownloadItemBo> _itemMap = LinkedHashMap();

  late final StreamController<List<DownloadTaskVO>> _controller =
      StreamController<List<DownloadTaskVO>>.broadcast(
        onListen: () => _controller.add(_snapshot()),
      );

  Stream<List<DownloadTaskVO>> downloadList() => _controller.stream;

  List<DownloadTaskVO> _snapshot() {
    return _groupMap.values.map((group) {
      final items = _itemMap.values
          .where((item) => item.groupId == group.id)
          .toList();
      return DownloadTaskVO(downloadGroupBo: group, downloadItemBoList: items);
    }).toList();
  }

  DownloadItemBo? getItem(String itemId) => _itemMap[itemId];

  DownloadGroupBo? getGroup(String groupId) => _groupMap[groupId];

  List<DownloadItemBo> getItemsByGroup(String groupId) {
    return _itemMap.values.where((item) => item.groupId == groupId).toList();
  }

  void _emit() => _controller.add(_snapshot());

  void upsertGroup(DownloadGroupBo group) {
    _groupMap[group.id] = group;
    _emit();
  }

  void upsertItem(DownloadItemBo item) {
    _itemMap[item.id] = item;
    _emit();
  }

  void removeGroup(String groupId) {
    _groupMap.remove(groupId);
    _itemMap.removeWhere((_, item) => item.groupId == groupId);
    _emit();
  }

  void removeItem(String itemId) {
    _itemMap.remove(itemId);
    _emit();
  }

  Future<void> dispose() => _controller.close();
}
