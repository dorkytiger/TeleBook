import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:tele_book/common/widget/network_image_widget.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final String coverUrl;
  final String status;
  final double progress;
  final Function()? onTap;
  final Widget? trailing;

  /// 自定义副标题；为空时默认显示「$status  xx.x%」。
  final String? subtitle;

  const TaskItemWidget({
    super.key,
    required this.title,
    required this.coverUrl,
    required this.status,
    required this.progress,
    this.onTap,
    this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FItem(
      onPress: onTap,
      prefix: NetworkImageWidget(imageUrl: coverUrl),
      title: Text(title, maxLines: 2),
      subtitle: Text(
        subtitle ?? "$status  ${(progress * 100).toStringAsFixed(1)}%",
      ),
      suffix: trailing,
    );
  }
}
