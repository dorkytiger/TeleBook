import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_lib;
import 'package:tele_book/app/db/app_database.dart';

class TBService {
  late final Dio dio;

  Future<TBService> init() async {
    final appDatabase = get_lib.Get.find<AppDatabase>();

    final settingTable =
        await appDatabase.select(appDatabase.settingTable).getSingle();
    dio = Dio(BaseOptions(
      baseUrl: "${settingTable.serverHost}:${settingTable.serverPort}", // 替换为你的基础URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    return this;
  }

  // GET 请求方法
  Future<Response> getRequest(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(url, queryParameters: queryParameters);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  // POST 请求方法
  Future<Response> postRequest(String url, {Map<String, dynamic>? data}) async {
    try {
      Response response = await dio.post(url, data: data);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  // 上传文件并且携带参数
  Future<Response> uploadFile(String url, String filePath,
      {Map<String, dynamic>? data, ProgressCallback? onSendProgress}) async {
    try {
      FormData formData = FormData.fromMap({
        ...?data,
        'file': await MultipartFile.fromFile(filePath),
      });
      Response response =
          await dio.post(url, data: formData, onSendProgress: onSendProgress);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  // 下载文件
  Future<Response> downloadFile(String url, String savePath,
      {ProgressCallback? onReceiveProgress}) async {
    try {
      Response response = await dio.download(url, savePath,
          onReceiveProgress: onReceiveProgress);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
