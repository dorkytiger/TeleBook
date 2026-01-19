import 'package:get/get.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/request_state.dart';

extension RxExtend<T> on Rx<RequestState<T>> {
  void listen({
    Function()? onLoading,
    Function()? onSuccess,
    Function()? onError,
    Function()? onIdle,
    Function()? onEmpty,
  }) {
    ever<RequestState>(this, (state) {
      switch (state) {
        case Loading():
          if (onLoading != null) {
            onLoading();
          }
          break;
        case Success():
          if (onSuccess != null) {
            onSuccess();
          }
          break;
        case Error():
          if (onError != null) {
            onError();
          }
          break;
        case Idle():
          if (onIdle != null) {
            onIdle();
          }
          break;
        case Empty<dynamic>():
          if (onEmpty != null) {
            onEmpty();
          }
          break;
      }
    });
  }

  void listenWithSuccess({
    bool showLoadingToast = true,
    bool showSuccessToast = true,
    String successMsg = '操作成功',
    Function()? onSuccess,
  }) {
    ever<RequestState>(this, (state) {
      switch (state) {
        case Loading():
          if (showLoadingToast) {
            ToastService.showLoading("正在加载...");
          }
          break;
        case Success():
          ToastService.dismiss();
          if (showSuccessToast) {
            ToastService.showSuccess(successMsg);
          }
          if (onSuccess != null) {
            onSuccess();
          }
          break;
        case Error(message: var message):
          ToastService.dismiss();
          ToastService.showError(message);
          break;
        case Idle():
          break;
        case Empty<dynamic>():
          break;
      }
    });
  }

  Future<void> runFuture(
    Future<T> Function() futureFunc, {
    bool Function(T result)? isEmpty,
  }) async {
    try {
      value = Loading();
      final result = await futureFunc();
      if (isEmpty != null && isEmpty(result)) {
        value = Empty();
        return;
      }
      value = Success(result);
    } catch (e) {
      value = Error(e.toString());
      rethrow;
    }
  }
}
