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
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          NetworkImageWidget(imageUrl: coverUrl),
          Expanded(
            child: ListTile(
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "状态: $status",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: progress,borderRadius: BorderRadius.circular(4),),
                ],
              ),
              trailing: trailing,
            ),
          ),
        ],
      ),
    );
  }
}
