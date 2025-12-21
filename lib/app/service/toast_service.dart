import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/service/navigator_service.dart';

enum ToastType {
  text,
  loading,
  success,
  error,
}

class ToastService {
  ToastService._();

  static final ToastService instance = ToastService._();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  /// 显示文本提示
  static void showText(String message, {Duration? duration}) {
    instance._show(
      type: ToastType.text,
      message: message,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 显示加载中
  static void showLoading([String message = '加载中...', Duration? duration]) {
    instance._show(
      type: ToastType.loading,
      message: message,
      duration: duration, // 默认不自动关闭，除非指定了 duration
    );
  }

  /// 显示成功提示
  static void showSuccess(String message, {Duration? duration}) {
    instance._show(
      type: ToastType.success,
      message: message,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 显示失败提示
  static void showError(String message, {Duration? duration}) {
    instance._show(
      type: ToastType.error,
      message: message,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 手动关闭 Toast
  static void dismiss() {
    instance._dismiss();
  }

  void _dismiss() {
    debugPrint('Toast: _dismiss called, _isShowing: $_isShowing, _overlayEntry: $_overlayEntry');
    if (_isShowing && _overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isShowing = false;
      debugPrint('Toast: Dismissed successfully');
    }
  }

  /// 内部显示方法
  void _show({
    required ToastType type,
    required String message,
    Duration? duration,
  }) {
    debugPrint('Toast: _show called - type: $type, message: $message, _isShowing: $_isShowing');

    // 如果已经有 Toast 在显示，先关闭
    if (_isShowing) {
      _dismiss();
    }

    _retryCount = 0;

    // 使用 Future.microtask 确保在下一个微任务中执行
    // 这样可以避免在 Widget 构建期间显示 Toast
    Future.microtask(() {
      _showInternal(type: type, message: message, duration: duration);
    });
  }

  void _showInternal({
    required ToastType type,
    required String message,
    Duration? duration,
  }) {
    debugPrint('Toast: _showInternal called - type: $type, message: $message');

    try {
      BuildContext? context;
      OverlayState? overlay;

      // 方法1: 尝试从 GetX 获取 overlayContext
      if (Get.overlayContext != null) {
        context = Get.overlayContext!;
        debugPrint('Toast: Get.overlayContext = $context');

        // 使用 Navigator.of(context).overlay 而不是 Overlay.maybeOf(context)
        // 因为 Get.overlayContext 可能返回的是 Overlay 内部的 _Theater context
        try {
          final navigator = Navigator.maybeOf(context);
          if (navigator != null) {
            overlay = navigator.overlay;
            debugPrint('Toast: Overlay from Navigator.overlay = $overlay');
          }
        } catch (e) {
          debugPrint('Toast: Error getting Navigator.overlay: $e');
        }

        // 备选方案：直接查找 Overlay
        if (overlay == null) {
          overlay = Overlay.maybeOf(context);
          debugPrint('Toast: Overlay from Overlay.maybeOf = $overlay');
        }
      }

      // 方法2: 使用 NavigatorService
      if (overlay == null) {
        try {
          context = NavigatorService.currentContext();
          debugPrint('Toast: NavigatorService.currentContext = $context');

          final navigator = Navigator.maybeOf(context);
          if (navigator != null) {
            overlay = navigator.overlay;
            debugPrint('Toast: Overlay from NavigatorService Navigator = $overlay');
          }
        } catch (e) {
          debugPrint('Toast: NavigatorService.currentContext() error: $e');
        }
      }

      // 方法3: 使用 navigatorKey 直接获取
      if (overlay == null) {
        try {
          final navigatorState = NavigatorService.navigatorKey.currentState;
          if (navigatorState != null) {
            overlay = navigatorState.overlay;
            debugPrint('Toast: Overlay from navigatorKey = $overlay');
          }
        } catch (e) {
          debugPrint('Toast: navigatorKey error: $e');
        }
      }

      // 如果 Overlay 还没有准备好，延迟到下一帧再试
      if (overlay == null) {
        if (_retryCount < _maxRetries) {
          _retryCount++;
          debugPrint('Toast: Overlay not ready, retry $_retryCount/$_maxRetries');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showInternal(type: type, message: message, duration: duration);
          });
        } else {
          debugPrint('Toast: Failed to show after $_maxRetries retries');
          _retryCount = 0;
        }
        return;
      }

      _isShowing = true;
      _retryCount = 0;

      // 创建 OverlayEntry
      _overlayEntry = OverlayEntry(
        builder: (context) => _ToastWidget(
          type: type,
          message: message,
          onDismiss: type != ToastType.loading ? _dismiss : null,
        ),
      );

      // 插入到 Overlay 中
      overlay.insert(_overlayEntry!);
      debugPrint('Toast: Successfully inserted into Overlay - $type - $message');

      // 如果设置了持续时间，自动关闭
      if (duration != null) {
        Future.delayed(duration, () {
          if (_isShowing) {
            debugPrint('Toast: Auto dismissing after ${duration.inSeconds}s');
            _dismiss();
          }
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Toast: Error showing toast: $e');
      debugPrint('Stack trace: $stackTrace');
      _isShowing = false;
      _retryCount = 0;
    }
  }
}

/// Toast 显示组件
class _ToastWidget extends StatefulWidget {
  final ToastType type;
  final String message;
  final VoidCallback? onDismiss;

  const _ToastWidget({
    required this.type,
    required this.message,
    this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 120,
                  maxWidth: 280,
                  minHeight: 120,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(),
                    if (widget.message.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (widget.type) {
      case ToastType.loading:
        return const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case ToastType.success:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 36,
          ),
        );
      case ToastType.error:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 36,
          ),
        );
      case ToastType.text:
        return const SizedBox.shrink();
    }
  }
}

