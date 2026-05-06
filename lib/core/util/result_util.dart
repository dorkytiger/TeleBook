import 'package:flutter/cupertino.dart';
import 'package:tele_book/core/util/failure_util.dart';

class Result<T> {
  final T? data;
  final Failure? error;

  Result({this.data, this.error});

  bool get isSuccess => error == null;

  bool get isError => error != null;

  static Result<T> success<T>(T data) => Result(data: data);

  static Result<T> failure<T>(Failure error) => Result(error: error);

  void fold({
    required void Function(T data) onSuccess,
    required void Function(Failure error) onError,
  }) {
    if (isSuccess) {
      onSuccess(data as T);
    } else if (isError && error != null) {
      onError(error!);
      if (error!.details != null) {
        debugPrint("Error details: ${error!.details}");
      }
      if (error!.stackTrace != null) {
        debugPrint("Stack trace: ${error!.stackTrace}");
      }
    }
  }
}
