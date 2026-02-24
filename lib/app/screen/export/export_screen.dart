import 'dart:io';

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
          itemCount: records.length,
          itemBuilder: (context, index) {
            final r = records[index];
            return Obx(
              () => ListTile(
                title: Text(r.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('状态: ${r.status.value.displayName}'),
                    if (r.total > 0) Text('进度: ${r.progress.value}/${r.total}'),
                    if (r.error != null)
                      Text(
                        '错误: ${r.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                trailing: _buildTrailing(r),
                onTap: () => controller.openExport(r),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildTrailing(ExportRecord r) {
    return Obx(() => _buildTrailingContent(r));
  }

  Widget _buildTrailingContent(ExportRecord r) {
    switch (r.status.value) {
      case ExportStatus.pending:
        return Icon(Icons.hourglass_empty);
      case ExportStatus.running:
        return SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: CircularProgressIndicator(
              value: r.total > 0 ? r.progress.value / r.total : null,
            ),
          ),
        );
      case ExportStatus.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () {
                controller.openExport(r);
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                controller.shareExport(r);
              },
            ),
          ],
        );
      case ExportStatus.failed:
        return IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            controller.exportService.exportBookById(r.bookId!);
          },
        );
    }
  }
}
