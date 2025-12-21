import 'package:flutter/material.dart';
import 'package:get/get.dart';

sealed class RequestState<T> {
  const RequestState();
}

class Idle<T> extends RequestState<T> {}

class Loading<T> extends RequestState<T> {}

class Success<T> extends RequestState<T> {
  final T data;

  const Success(this.data);
}

class Empty<T> extends RequestState<T> {}

class Error<T> extends RequestState<T> {
  final String message;

  const Error(this.message);
}

extension RequestStateExtension<T> on RequestState<T> {
  bool isIdle() => this is Idle<T>;

  bool isLoading() => this is Loading<T>;

  bool isError() => this is Error<T>;

  bool isEmpty() => this is Empty<T>;

  bool isSuccess() => this is Success<T>;

  T getSuccessData() => (this as Success<T>).data;

  String getErrorMessage() => (this as Error<T>).message;

  Future<RequestState<T>> handleFunction({
    required Future<T> Function() function,
    required void Function(RequestState<T>) onStateChanged,
    bool Function()? checkEmpty
  }) async {
    try {
      final loading = Loading<T>();
      onStateChanged.call(loading);
      final result = await function();
      if(checkEmpty != null && checkEmpty()){
        final empty = Empty<T>();
        onStateChanged.call(empty);
        return empty;
      }
      final success = Success<T>(result);
      onStateChanged.call(success);
      return success;
    } catch (e) {
      debugPrint(e.toString());
      final err = Error<T>(e.toString());
      onStateChanged.call(err);
      return err;
    }
  }
}

class DisplayResult<T> extends StatelessWidget {
  final RequestState<T> state;
  final Widget Function()? onIdle;
  final Widget Function()? onLoading;
  final Widget Function(String)? onError;
  final Widget Function(T) onSuccess;
  final Widget Function()? onEmpty;
  final Color? backgroundColor;

  const DisplayResult({
    Key? key,
    required this.state,
    this.onIdle,
    this.onLoading,
    this.onError,
    required this.onSuccess,
    this.onEmpty,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: backgroundColor,
      duration: const Duration(milliseconds: 300),
      child: Builder(
        builder: (context) {
          if (state is Idle<T>) {
            return onIdle?.call() ?? Container();
          } else if (state is Loading<T>) {
            return onLoading?.call() ?? Container();
          } else if (state is Error<T>) {
            return onError?.call((state as Error<T>).getErrorMessage()) ??
                Container();
          } else if (state is Success<T>) {
            return onSuccess((state as Success<T>).getSuccessData());
          } else if (state is Empty<T>) {
            return onEmpty?.call() ?? Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
