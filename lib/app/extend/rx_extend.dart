import 'dart:async';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

extension RxExtend<T> on Rx<DKStateQuery<T>> {
  Widget displaySuccess({
    Widget Function()? initialBuilder,
    Widget Function()? loadingBuilder,
    Widget Function(String message)? errorBuilder,
    Widget Function()? emptyBuilder,
    required Widget Function(T data) successBuilder,
    Function? onRetry,
  }) {
    return display(
      initialBuilder: () {
        return initialBuilder != null
            ? initialBuilder()
            : Center(child: CustomEmpty(message: '暂无数据'));
      },
      loadingBuilder: () {
        return loadingBuilder != null
            ? loadingBuilder()
            : const CustomLoading();
      },
      errorBuilder: (message) {
        ToastService.showError(message);
        return errorBuilder != null
            ? errorBuilder(message)
            : Center(
                child: FilledButton.icon(
                  label: Text('加载失败，点击重试'),
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    ToastService.dismiss();
                    if (onRetry != null) {
                      onRetry();
                    }
                  },
                ),
              );
      },
      emptyBuilder: () {
        return emptyBuilder != null
            ? emptyBuilder()
            : Center(child: CustomEmpty(message: '暂无数据'));
      },
      successBuilder: successBuilder,
    );
  }
}

extension RXDKStateEventExtension<T> on Rx<DKStateEvent<T>> {
  StreamSubscription<DKStateEvent<T>> listenEventToast({
    void Function()? onLoading,
    void Function(T data)? onSuccess,
    void Function(String message, Object? error, StackTrace? stackTrace)?
    onError,
    void Function()? onIdle,
    void Function()? onComplete,
    bool showLoadingToast = true,
    bool showErrorToast = true,
    bool showSuccessToast = true,
  }) {
    return listen((state) {
      DKStateEventHelper.handleState<T>(
        state,
        onLoading: () {
          ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
          if (showLoadingToast) {
            ScaffoldMessenger.of(
              Get.context!,
            ).showSnackBar(const SnackBar(content: Text('加载中...')));
          }
          if (onLoading != null) {
            onLoading();
          }
        },
        onSuccess: (data) {
          ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
          if (showSuccessToast) {
            ScaffoldMessenger.of(
              Get.context!,
            ).showSnackBar(const SnackBar(content: Text('操作成功')));
          }
          if (onSuccess != null) {
            onSuccess(data);
          }
        },
        onError: (message, error, stackTrace) {
          ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
          if (showErrorToast) {
            ScaffoldMessenger.of(
              Get.context!,
            ).showSnackBar(SnackBar(content: Text('操作失败: $message')));
          }
          if (onError != null) {
            onError(message, error, stackTrace);
          }
        },
        onIdle: onIdle,
        onComplete: onComplete,
      );
    });
  }
}
