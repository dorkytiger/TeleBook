import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/service/import_service.dart';
import 'package:tele_book/app/store/import_store.dart';

/// ImportController - 使用 ChangeNotifier 进行状态管理
class ImportController extends ChangeNotifier {
  final ImportStore importStore;

  String? _appDocPath;
  String? get appDocPath => _appDocPath;

  ImportController({
    required this.importStore,
  }) {
    _init();
  }

  Future<void> _init() async {
    _appDocPath = await getApplicationDocumentsDirectory().then(
      (dir) => dir.path,
    );
    notifyListeners();
  }

  /// 重新导入
  Future<void> restartImport(String groupId) async {
    final group = importStore.getGroupById(groupId);
    if (group != null) {
      // 重置任务状态
      for (var task in group.tasks.value) {
        task.status.value = ImportStatus.pending;
        task.error = null;
        task.distSubPath.value = '';
      }
      group.status.value = ImportStatus.pending;

      // 重新开始导入
      await importStore.startImport(group);
    }
  }
}
