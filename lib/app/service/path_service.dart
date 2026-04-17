import 'package:path_provider/path_provider.dart';

/// 路径服务，管理应用的各种路径
class PathService {
  late final String _appDocumentsDirectory;
  late final String _appSupportDirectory;
  late final String _appCacheDirectory;

  String get appDocumentsDirectory => _appDocumentsDirectory;

  String get appSupportDirectory => _appSupportDirectory;

  String get appCacheDirectory => _appCacheDirectory;

  Future<PathService> init() async {
    _appDocumentsDirectory = (await getApplicationDocumentsDirectory()).path;
    _appSupportDirectory = (await getApplicationSupportDirectory()).path;
    _appCacheDirectory = (await getTemporaryDirectory()).path;
    return this;
  }

  /// 获取书籍文件的完整路径
  String getBookFilePath(String relativePath) {
    return '$_appDocumentsDirectory/$relativePath';
  }
}
