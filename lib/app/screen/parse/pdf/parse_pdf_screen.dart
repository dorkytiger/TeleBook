import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/route/app_route.dart';

import 'parse_pdf_controller.dart';

class ParsePdfScreen extends StatelessWidget {
  final String pdfPath;

  const ParsePdfScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParsePdfController(
        path: pdfPath,
        importStore: context.read(),
      ),
      child: const _ParsePdfContent(),
    );
  }
}

class _ParsePdfContent extends StatelessWidget {
  const _ParsePdfContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParsePdfController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.bookName),
            leading: const BackButton(),
          ),
          body: DKStateQueryDisplay(
            state: controller.processState,
            loadingBuilder: () => _buildLoading(controller),
            successBuilder: (files) => _buildSuccess(context, controller, files),
          ),
        );
      },
    );
  }

  Widget _buildLoading(ParsePdfController controller) {
    final total = controller.totalPages;
    final done = controller.processedCount;
    final progress = total > 0 ? done / total : null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf, size: 56, color: Colors.grey),
            const SizedBox(height: 24),
            const Text('处理 PDF 中…', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            if (total > 0)
              Text('$done / $total 页', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(
    BuildContext context,
    ParsePdfController controller,
    List<File> files,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            '共 ${files.length} 页，确认后点击导入',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: SizedBox(
                  width: 56,
                  height: 72,
                  child: Image.file(file, fit: BoxFit.cover),
                ),
                title: Text('第 ${index + 1} 页'),
                subtitle: Text(
                  '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await controller.importPDF();
                if (context.mounted) {
                  context.go('${AppRoute.home}?tab=1&taskTab=1');
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('导入 PDF'),
            ),
          ),
        ),
      ],
    );
  }

}
