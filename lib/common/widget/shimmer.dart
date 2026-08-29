import 'package:flutter/material.dart';

/// 原生 Shimmer 加载占位效果，替代 shimmer 包。
///
/// 通过 [ShaderMask] + 循环 [AnimationController] 实现高光条来回扫过
/// [child] 的视觉效果，用法与 shimmer 包的 [Shimmer.fromColors] 对齐。
class Shimmer extends StatefulWidget {
  final Color baseColor;
  final Color highlightColor;
  final Widget child;
  final Duration duration;

  const Shimmer({
    super.key,
    required this.baseColor,
    required this.highlightColor,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        // -1 -> 1 往复，让高光条从左侧扫到右侧
        final slide = _controller.value * 2 - 1;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
            stops: const [0.0, 0.4, 1.0],
            transform: _SlidingGradientTransform(slide),
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}

/// 沿水平方向平移渐变，使高光条随动画移动。
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  /// 平移量（占宽度比例），取值 [-1, 1]。
  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
}
