import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

/// 路径服务，管理应用的各种路径
class PathService extends GetxService {
  late final String appDocumentsDirectory;
  late final String appSupportDirectory;
  late final String appCacheDirectory;

  Future<PathService> init() async {
    appDocumentsDirectory = (await getApplicationDocumentsDirectory()).path;
    appSupportDirectory = (await getApplicationSupportDirectory()).path;
    appCacheDirectory = (await getTemporaryDirectory()).path;
    return this;
  }

  /// 获取书籍文件的完整路径
  String getBookFilePath(String relativePath) {
    return '$appDocumentsDirectory/$relativePath';
  }
}

