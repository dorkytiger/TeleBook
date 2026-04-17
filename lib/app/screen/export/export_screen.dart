import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/service/export_service.dart';
import 'package:tele_book/app/store/export_store.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'export_controller.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExportController(exportStore: context.read()),
      child: const _ExportContent(),
    );
  }
}

class _ExportContent extends StatelessWidget {
  const _ExportContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExportController>(
      builder: (context, controller, _) {
        final records = controller.records;
        if (records.isEmpty) {
          return const Scaffold(
            body: Center(child: CustomEmpty(message: '暂无导出记录')),
          );
        }
        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final r = records[index];
              return ValueListenableBuilder(
                valueListenable: r.status,
                builder: (context, status, _) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: status == ExportStatus.success
                        ? () => controller.openExport(r)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // 状态图标
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _statusColor(context, status)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: _buildStatusIcon(r, status)),
                          ),
                          const SizedBox(width: 12),
                          // 信息区域
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: _statusColor(context, status)
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        status.displayName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: _statusColor(
                                                  context, status),
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    if (r.total > 0) ...[
                                      const SizedBox(width: 8),
                                      ValueListenableBuilder(
                                        valueListenable: r.progress,
                                        builder: (_, progress, __) => Text(
                                          '$progress/${r.total}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color
                                                    ?.withValues(alpha: 0.7),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (r.error != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '错误: ${r.error}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (status == ExportStatus.running &&
                                    r.total > 0) ...[
                                  const SizedBox(height: 6),
                                  ValueListenableBuilder(
                                    valueListenable: r.progress,
                                    builder: (_, progress, __) =>
                                        ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: progress / r.total,
                                        minHeight: 6,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildActionButtons(context, controller, r, status),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(ExportRecord r, ExportStatus status) {
    switch (status) {
      case ExportStatus.pending:
        return Icon(Icons.hourglass_empty,
            color: _statusColor(null, status));
      case ExportStatus.running:
        return ValueListenableBuilder(
          valueListenable: r.progress,
          builder: (_, progress, __) => SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: r.total > 0 ? progress / r.total : null,
              strokeWidth: 3,
            ),
          ),
        );
      case ExportStatus.success:
        return Icon(Icons.check_circle, color: _statusColor(null, status));
      case ExportStatus.failed:
        return Icon(Icons.error, color: _statusColor(null, status));
    }
  }

  Color _statusColor(BuildContext? context, ExportStatus status) {
    final cs = context != null ? Theme.of(context).colorScheme : null;
    switch (status) {
      case ExportStatus.pending:
        return cs?.secondary ?? Colors.orange;
      case ExportStatus.running:
        return cs?.primary ?? Colors.blue;
      case ExportStatus.success:
        return cs?.tertiary ?? Colors.green;
      case ExportStatus.failed:
        return cs?.error ?? Colors.red;
    }
  }

  Widget _buildActionButtons(
    BuildContext context,
    ExportController controller,
    ExportRecord r,
    ExportStatus status,
  ) {
    switch (status) {
      case ExportStatus.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => controller.openExport(r),
              tooltip: '打开',
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => controller.shareExport(r),
              tooltip: '分享',
            ),
          ],
        );
      case ExportStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => controller.retryExport(r),
          tooltip: '重试',
        );
      default:
        return const SizedBox(width: 48);
    }
  }
}
