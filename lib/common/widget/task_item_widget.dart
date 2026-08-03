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

  const TaskItemWidget({
    super.key,
    required this.title,
    required this.coverUrl,
    required this.status,
    required this.progress,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return FItem(
      onPress: onTap,
      prefix: NetworkImageWidget(imageUrl: coverUrl),
      title: Text(title, maxLines: 2),
      subtitle: Text("$status  ${(progress * 100).toStringAsFixed(1)}%"),
      suffix: trailing,
    );
  }
}
