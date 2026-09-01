import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

Dio createApiDio({
  required BaseOptions baseOptions,
  List<Interceptor> interceptors = const [],
}) {
  final dio = Dio(
    baseOptions.copyWith(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: false));

  dio.interceptors.addAll(interceptors);

  return dio;
}

final githubDioProvider = Provider<Dio>((ref) {
  return createApiDio(
    baseOptions: BaseOptions(
      baseUrl: 'https://api.github.com',
      headers: {'User-Agent': 'Telebook/3.1.7'},
    ),
  );
});

/// 自有服务器请求用：不设 baseUrl（服务器地址是用户配置的），
/// 请求时拼完整 URL；token 由调用方在 headers 里带。
final serverDioProvider = Provider<Dio>((ref) {
  return createApiDio(baseOptions: BaseOptions());
});
