import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_form_provider.dart';

class ParseFormView extends ConsumerWidget {
  const ParseFormView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parseFormProvider);
    final notifier = ref.read(parseFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("解析表单")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<ParseFormType>(
                  width: constraints.maxWidth,
                  initialSelection: state.type,
                  decorationBuilder: (context, state) {
                    return const InputDecoration(
                      labelText: "选择解析来源",
                      prefixIcon: Icon(Icons.source),
                      border: OutlineInputBorder(),
                    );
                  },
                  menuStyle: MenuStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: ParseFormType.web,
                      label: "网页",
                      leadingIcon: Icon(Icons.web),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.archive,
                      label: "压缩包",
                      leadingIcon: Icon(Icons.archive),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.batchArchive,
                      label: "批量压缩包",
                      leadingIcon: Icon(Icons.batch_prediction),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.imageFolder,
                      label: "文件夹",
                      leadingIcon: Icon(Icons.photo_library),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.batchImageFolder,
                      label: "批量文件夹",
                      leadingIcon: Icon(Icons.folder_copy),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.pdf,
                      label: "PDF",
                      leadingIcon: Icon(Icons.picture_as_pdf),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.batchPdf,
                      label: "批量 PDF",
                      leadingIcon: Icon(Icons.folder_special),
                    ),
                  ],
                  onSelected: (value) {
                    notifier.setType(value);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSubForm(context, notifier, state.type),
            const Spacer(),
            FilledButton(
              onPressed: () {
                notifier.onParse(context);
              },
              child: const Text("解析"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubForm(
    BuildContext context,
    ParseForm notifier,
    ParseFormType type,
  ) {
    switch (type) {
      case ParseFormType.web:
        return _buildWebForm(context, notifier);
      case ParseFormType.archive:
        return _buildArchiveForm(context, notifier);
      case ParseFormType.batchArchive:
        return _buildBatchArchiveForm(context, notifier);
      case ParseFormType.imageFolder:
        return _buildImageFolderForm(context, notifier);
      case ParseFormType.batchImageFolder:
        return _buildBatchImageFolderForm(context, notifier);
      case ParseFormType.pdf:
        return _buildPdfForm(context, notifier);
      case ParseFormType.batchPdf:
        return _buildBatchPdfForm(context, notifier);
    }
  }

  Widget _buildWebForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.urlController,
      onChanged: notifier.onUrlChanged,
      decoration: InputDecoration(
        labelText: "输入文本",
        prefixIcon: const Icon(Icons.web),
        suffixIcon: IconButton(
          onPressed: notifier.getClipboardUrl,
          icon: const Icon(Icons.paste),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildArchiveForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.archivePathController,
      decoration: InputDecoration(
        labelText: "请选择压缩包文件",
        prefixIcon: const Icon(Icons.archive),
        suffixIcon: IconButton(
          onPressed: notifier.pickerArchive,
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchArchiveForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.batchArchivePathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS ? "请选择一个或多个 ZIP 文件" : "请选择压缩包文件夹",
        prefixIcon: const Icon(Icons.folder),
        suffixIcon: IconButton(
          onPressed: notifier.pickerBatchArchive,
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImageFolderForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.imageFolderPathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS ? "请选择一个或多个图片文件" : "请选择图片文件夹",
        prefixIcon: const Icon(Icons.photo_library),
        suffixIcon: IconButton(
          onPressed: notifier.pickerImageFolder,
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchImageFolderForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.batchImageFolderPathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS
            ? "请选择多个图片文件（按文件夹分组）"
            : "请选择批量图片文件夹父目录",
        prefixIcon: const Icon(Icons.folder_copy),
        suffixIcon: IconButton(
          onPressed: notifier.pickerBatchImageFolder,
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPdfForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.pdfPathController,
      decoration: InputDecoration(
        labelText: "请选择 PDF 文件",
        prefixIcon: const Icon(Icons.picture_as_pdf),
        suffixIcon: IconButton(
          onPressed: notifier.pickerPdf,
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchPdfForm(BuildContext context, ParseForm notifier) {
    return TextField(
      controller: notifier.batchPdfPathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS ? "请选择一个或多个 PDF 文件" : "请选择包含 PDF 的文件夹",
        prefixIcon: const Icon(Icons.folder_special),
        suffixIcon: IconButton(
          onPressed: notifier.pickerBatchPdf,
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
