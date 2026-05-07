import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/ui/viewmodel/export_single_viewmodel.dart';

class ExportSingleFormView extends StatelessWidget {
  final BookTableData book;

  const ExportSingleFormView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExportSingleViewmodel(book: book),
      child: const _ExportSingleFormContent(),
    );
  }
}

class _ExportSingleFormContent extends StatelessWidget {
  const _ExportSingleFormContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExportSingleViewmodel>();

    // 成功后弹提示并返回
    if (vm.isDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('导出成功！'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('导出书籍')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 书籍名提示
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.book),
              title: Text(vm.book.name),
              subtitle: Text('共 ${vm.book.localSubPaths.length} 页'),
            ),
            const Divider(),
            const SizedBox(height: 8),

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
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // 导出文件名
            TextField(
              controller: vm.fileNameController,
              enabled: !vm.isExporting,
              decoration: const InputDecoration(
                labelText: '导出文件名',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // 错误提示
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  vm.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),

            const Spacer(),

            // 导出按钮
            FilledButton.icon(
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
              label: Text(vm.isExporting ? '导出中...' : '开始导出'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

