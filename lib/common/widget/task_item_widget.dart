import 'package:flutter/material.dart';
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
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: NetworkImageWidget(imageUrl: coverUrl),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "状态: $status",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(width: 8),
              Text(
                "进度: ${(progress * 100).toStringAsFixed(1)}%",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      trailing: trailing,
    );
  }
}
