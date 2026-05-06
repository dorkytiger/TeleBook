import 'package:flutter/material.dart';

sealed class EventState {
  const EventState();
}

class LoadingEventState extends EventState {
  const LoadingEventState();
}

class SuccessEventState<T> extends EventState {
  final T data;

  const SuccessEventState(this.data);
}

class ErrorEventState extends EventState {
  final String message;

  const ErrorEventState(this.message);
}

class IdleEventState extends EventState {
  const IdleEventState();
}

extension EventStateExtension on EventState {
  bool get isLoading => this is LoadingEventState;
  bool get isSuccess => this is SuccessEventState;
  bool get isError => this is ErrorEventState;
  bool get isIdle => this is IdleEventState;


  Widget when<T>({
    Widget Function()? loading,
    Widget Function(String message)? error,
    Widget Function()? idle,
    required Widget Function(T data) success,
  }) {
    if (this is LoadingEventState) {
      return loading != null
          ? loading()
          : Center(child: CircularProgressIndicator());
    } else if (this is ErrorEventState) {
      return error != null
          ? error((this as ErrorEventState).message)
          : Center(child: Text("发生错误: ${(this as ErrorEventState).message}"));
    } else if (this is IdleEventState) {
      return idle != null
          ? idle()
          : Center(child: Text("等待操作"));
    } else if (this is SuccessEventState) {
      return success((this as SuccessEventState<T>).data);
    } else {
      throw Exception("Unknown EventState");
    }
  }
}
