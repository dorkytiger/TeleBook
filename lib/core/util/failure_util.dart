sealed class Failure {
  final String message;
  final Object? details; // 可选的额外错误信息
  final StackTrace? stackTrace; // 可选的堆栈信息

  const Failure(this.message, this.details, this.stackTrace);
}

/// 代表网络请求失败的错误
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = "网络请求失败",
    Object? details,
    StackTrace? stackTrace,
  }) : super(message, details, stackTrace);
}

/// 代表数据解析失败的错误
class ParsingFailure extends Failure {
  const ParsingFailure({
    String message = "数据解析失败",
    Object? details,
    StackTrace? stackTrace,
  }) : super(message, details, stackTrace);
}

/// 代表业务逻辑错误的错误
class BusinessFailure extends Failure {
  const BusinessFailure({
    String message = "业务错误",
    Object? details,
    StackTrace? stackTrace,
  }) : super(message, details, stackTrace);
}
