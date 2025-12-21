import 'package:get/get.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/request_state.dart';

extension RxExtend on Rx<RequestState> {
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
    Function()? onSuccess,
  }) {
    ever<RequestState>(this, (state) {
      // 不需要在这里使用 addPostFrameCallback
      // ToastService 内部已经有完善的处理机制
      switch (state) {
        case Loading():
          ToastService.showLoading();
          break;
        case Success():
          ToastService.dismiss();
          ToastService.showSuccess("操作成功");
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
}
