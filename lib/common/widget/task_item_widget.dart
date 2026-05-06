import 'package:flutter/material.dart';

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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              coverUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              cacheWidth: 100,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.broken_image,
                size: 32,
                color: Theme.of(context).disabledColor,
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  child: Text(
                    "${((loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)) * 100).toStringAsFixed(0)}%",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
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
                  LinearProgressIndicator(value: progress),
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
