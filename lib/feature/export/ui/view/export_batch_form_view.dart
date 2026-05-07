import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/ui/viewmodel/export_batch_viewmodel.dart';

class ExportBatchFormView extends StatelessWidget {
  final List<BookTableData> books;

  const ExportBatchFormView({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExportBatchViewmodel(books: books),
      child: const _ExportBatchFormContent(),
    );
  }
}

class _ExportBatchFormContent extends StatelessWidget {
  const _ExportBatchFormContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExportBatchViewmodel>();

    if (vm.isDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('全部导出成功！'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('批量导出（${vm.items.length} 本）'),
      ),
      body: Column(
        children: [
          // 顶部设置区
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 导出格式
                LayoutBuilder(
                  builder: (context, constraints) => DropdownMenu<ExportFormat>(
                    width: constraints.maxWidth,
                    initialSelection: vm.format,
                    label: const Text('导出格式'),
                    leadingIcon: const Icon(Icons.file_present),
                    onSelected: (v) {
                      if (v != null) vm.setFormat(v);
                    },
                    dropdownMenuEntries: ExportFormat.values
                        .map((f) => DropdownMenuEntry(value: f, label: f.label))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // 导出路径
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: vm.outputPath ?? ''),
                  decoration: InputDecoration(
                    labelText: '导出路径',
                    hintText: '请选择导出目录',
                    prefixIcon: const Icon(Icons.folder_open),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.drive_folder_upload),
                      onPressed: vm.isExporting ? null : vm.pickOutputDir,
                    ),
                  ),
                ),

                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      vm.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),

                // 进度条
                if (vm.isExporting) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: vm.items.isNotEmpty
                        ? vm.progress / vm.items.length
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '正在导出 ${vm.progress} / ${vm.items.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // 导出项列表
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: vm.items.length,
              itemBuilder: (context, index) {
                final item = vm.items[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.book_outlined, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.book.name,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: item.nameController,
                              enabled: !vm.isExporting,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                labelText: '导出文件名',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.book.localSubPaths.length} 页',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 底部导出按钮
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: vm.isExporting ? null : () => vm.export(),
                icon: vm.isExporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.upload),
                label: Text(vm.isExporting ? '导出中...' : '开始批量导出'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

