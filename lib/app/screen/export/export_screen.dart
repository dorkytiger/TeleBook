import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'export_controller.dart';

class ExportScreen extends GetView<ExportController> {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final records = controller.exportService.records;
        if (records.isEmpty) {
          return Center(child: CustomEmpty(message: "暂无导出记录"));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final r = records[index];
            return Obx(
              () => Card(
                margin: EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: r.status.value == ExportStatus.success
                      ? () => controller.openExport(r)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // 状态图标
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStatusColor(context, r.status.value).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: _buildStatusIcon(r),
                          ),
                        ),
                        SizedBox(width: 12),
                        // 信息区域
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(context, r.status.value).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      r.status.value.displayName,
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: _getStatusColor(context, r.status.value),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (r.total > 0) ...[
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.insert_drive_file,
                                      size: 14,
                                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${r.progress.value}/${r.total}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (r.error != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  '错误: ${r.error}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              if (r.status.value == ExportStatus.running && r.total > 0) ...[
                                SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: r.progress.value / r.total,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        // 操作按钮
                        _buildActionButtons(r),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusIcon(ExportRecord r) {
    switch (r.status.value) {
      case ExportStatus.pending:
        return Icon(
          Icons.hourglass_empty,
          color: _getStatusColor(null, r.status.value),
        );
      case ExportStatus.running:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: r.total > 0 ? r.progress.value / r.total : null,
            strokeWidth: 3,
          ),
        );
      case ExportStatus.success:
        return Icon(
          Icons.check_circle,
          color: _getStatusColor(null, r.status.value),
        );
      case ExportStatus.failed:
        return Icon(
          Icons.error,
          color: _getStatusColor(null, r.status.value),
        );
    }
  }

  Color _getStatusColor(BuildContext? context, ExportStatus status) {
    final colorScheme = context != null ? Theme.of(context).colorScheme : null;
    switch (status) {
      case ExportStatus.pending:
        return colorScheme?.secondary ?? Colors.orange;
      case ExportStatus.running:
        return colorScheme?.primary ?? Colors.blue;
      case ExportStatus.success:
        return colorScheme?.tertiary ?? Colors.green;
      case ExportStatus.failed:
        return colorScheme?.error ?? Colors.red;
    }
  }

  Widget _buildActionButtons(ExportRecord r) {
    switch (r.status.value) {
      case ExportStatus.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () {
                controller.openExport(r);
              },
              tooltip: '打开',
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                controller.shareExport(r);
              },
              tooltip: '分享',
            ),
          ],
        );
      case ExportStatus.failed:
        return IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            controller.exportService.exportBookById(r.bookId!);
          },
          tooltip: '重试',
        );
      default:
        return SizedBox(width: 48);
    }
  }
}
