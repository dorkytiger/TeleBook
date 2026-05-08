import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_form_viewmodel.dart';

class ParseFormView extends StatelessWidget {
  const ParseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseFormViewmodel(),
      child: const _ParseFormContent(),
    );
  }
}

class _ParseFormContent extends StatefulWidget {
  const _ParseFormContent();

  @override
  State<_ParseFormContent> createState() => _ParseFormContentState();
}

class _ParseFormContentState extends State<_ParseFormContent> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParseFormViewmodel>();

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
                  initialSelection: vm.type,
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
                    vm.setType(value);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSubForm(context, vm.type),
            const Spacer(),
            FilledButton(
              onPressed: () {
                vm.onParse(context);
              },
              child: const Text("解析"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubForm(BuildContext context, ParseFormType type) {
    final vm = context.read<ParseFormViewmodel>();
    switch (type) {
      case ParseFormType.web:
        return _buildWebForm(context, vm);
      case ParseFormType.archive:
        return _buildArchiveForm(context, vm);
      case ParseFormType.batchArchive:
        return _buildBatchArchiveForm(context, vm);
      case ParseFormType.imageFolder:
        return _buildImageFolderForm(context, vm);
      case ParseFormType.batchImageFolder:
        return _buildBatchImageFolderForm(context, vm);
      case ParseFormType.pdf:
        return _buildPdfForm(context, vm);
      case ParseFormType.batchPdf:
        return _buildBatchPdfForm(context, vm);
    }
  }

  Widget _buildWebForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.urlController,
      decoration: InputDecoration(
        labelText: "输入文本",
        prefixIcon: const Icon(Icons.web),
        suffixIcon: IconButton(
          onPressed: () => vm.getClipboardUrl(),
          icon: const Icon(Icons.paste),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildArchiveForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.archivePathController,
      decoration: InputDecoration(
        labelText: "请选择压缩包文件",
        prefixIcon: const Icon(Icons.archive),
        suffixIcon: IconButton(
          onPressed: () => vm.pickerArchive(context),
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchArchiveForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.batchArchivePathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS ? "请选择一个或多个 ZIP 文件" : "请选择压缩包文件夹",
        prefixIcon: const Icon(Icons.folder),
        suffixIcon: IconButton(
          onPressed: () => vm.pickerBatchArchive(context),
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImageFolderForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.imageFolderPathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS ? "请选择一个或多个图片文件" : "请选择图片文件夹",
        prefixIcon: const Icon(Icons.photo_library),
        suffixIcon: IconButton(
          onPressed: () => vm.pickerImageFolder(context),
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchImageFolderForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.batchImageFolderPathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS
            ? "请选择多个图片文件（按文件夹分组）"
            : "请选择批量图片文件夹父目录",
        prefixIcon: const Icon(Icons.folder_copy),
        suffixIcon: IconButton(
          onPressed: () => vm.pickerBatchImageFolder(context),
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPdfForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.pdfPathController,
      decoration: InputDecoration(
        labelText: "请选择 PDF 文件",
        prefixIcon: const Icon(Icons.picture_as_pdf),
        suffixIcon: IconButton(
          onPressed: () => vm.pickerPdf(context),
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchPdfForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.batchPdfPathController,
      decoration: InputDecoration(
        labelText: Platform.isIOS ? "请选择一个或多个 PDF 文件" : "请选择包含 PDF 的文件夹",
        prefixIcon: const Icon(Icons.folder_special),
        suffixIcon: IconButton(
          onPressed: () => vm.pickerBatchPdf(context),
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
