import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'export_controller.dart';
import 'package:tele_book/app/service/export_service.dart';

class ExportScreen extends GetView<ExportController> {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: '导出记录'),
      body: Obx(() {
        final records = controller.exportService.records;
        if (records.isEmpty) {
          return Center(child: TDEmpty(emptyText: '暂无导出记录'));
        }
        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final r = records[index];
            return TDCell(
              title: r.name,
              bordered: true,
              descriptionWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('状态: ${r.status.value.toString().split('.').last}'),
                  if (r.total > 0) Text('进度: ${r.progress.value}/${r.total}'),
                  if (r.error != null)
                    Text('错误: ${r.error}', style: TextStyle(color: Colors.red)),
                ],
              ),
              rightIconWidget: Obx(() => _buildTrailing(r)),
              onClick: (cell) => controller.openExport(r),
            );
          },
        );
      }),
    );
  }

  Widget _buildTrailing(ExportRecord r) {
    switch (r.status.value) {
      case ExportStatus.pending:
        return Icon(Icons.hourglass_empty);
      case ExportStatus.running:
        return SizedBox(
          width: 48,
          child: Center(
            child: TDProgress(
              type: TDProgressType.circular,
              value: r.total > 0 ? r.progress.value / r.total : null,
            ),
          ),
        );
      case ExportStatus.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TDButton(
              icon: Icons.open_in_new,
              type: TDButtonType.text,
              theme: TDButtonTheme.primary,
              onTap: () {
                controller.openExport(r);
              },
            ),
            TDButton(
              icon: Icons.share,
              type: TDButtonType.text,
              theme: TDButtonTheme.primary,
              onTap: () {
                controller.shareExport(r);
              },
            ),
          ],
        );
      case ExportStatus.failed:
        return TDButton(
          text: "重试",
          icon: Icons.refresh,
          type: TDButtonType.text,
          theme: TDButtonTheme.danger,
          onTap: () {
            controller.exportService.exportBookById(r.bookId!);
          },
        );
    }
  }
}
