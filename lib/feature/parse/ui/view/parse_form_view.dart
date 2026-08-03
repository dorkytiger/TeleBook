import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/feature/parse/ui/provider/parse_form_provider.dart';

class ParseFormView extends ConsumerWidget {
  const ParseFormView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parseFormProvider);
    final notifier = ref.read(parseFormProvider.notifier);

    return FScaffold(
      header: FHeader.nested(
        title: const Text("解析表单"),
        prefixes: [
          FHeaderAction.back(
            onPress: () {
              context.pop();
            },
          ),
        ],
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Text(
            "导入书籍",
            style: context.theme.typography.display.xl2.copyWith(
              fontWeight: .w600,
              color: context.theme.colors.foreground,
              height: 1.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "请选择导入方式，然后输入导入网站/文件路径/文件夹路径",
            style: context.theme.typography.body.sm.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          SizedBox(height: 16),
          FSelect<ParseFormType>.rich(
            control: FSelectControl.managed(
              initial: ParseFormType.web,
              onChange: (value) {
                notifier.setType(value);
              },
            ),
            hint: "请选择导入方式",
            label: Text("导入方式"),
            format: (s) => s.description,
            children: [
              .item(
                value: ParseFormType.web,
                title: Text("网页"),
                prefix: Icon(Icons.web),
              ),
              .item(
                value: ParseFormType.archive,
                title: Text("压缩包"),
                prefix: Icon(Icons.archive),
              ),
              .item(
                value: ParseFormType.batchArchive,
                title: Text("批量压缩包"),
                prefix: Icon(Icons.batch_prediction),
              ),
              .item(
                value: ParseFormType.imageFolder,
                title: Text("文件夹"),
                prefix: Icon(Icons.photo_library),
              ),
              .item(
                value: ParseFormType.batchImageFolder,
                title: Text("批量文件夹"),
                prefix: Icon(Icons.folder_copy),
              ),
              .item(
                value: ParseFormType.pdf,
                title: Text("PDF"),
                prefix: Icon(Icons.picture_as_pdf),
              ),
              .item(
                value: ParseFormType.batchPdf,
                title: Text("批量 PDF"),
                prefix: Icon(Icons.folder_special),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSubForm(context, notifier, state.type),
          const SizedBox(height: 16),
          Spacer(),
          Padding(
            padding: .symmetric(vertical: 16),
            child: FButton(
              onPress: () {
                notifier.onParse(context);
              },
              child: const Text("解析"),
            ),
          ),
        ],
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
    return FTextFormField(
      label: const Text('URL'),
      hint: '请输入URL',
      control: FTextFieldControl.managed(controller: notifier.urlController),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.getClipboardUrl,
        child: const Icon(FLucideIcons.clipboardPaste),
      ),
    );
  }

  Widget _buildArchiveForm(BuildContext context, ParseForm notifier) {
    return FTextFormField(
      label: const Text('压缩包文件'),
      hint: '请选择压缩包文件',
      control: FTextFieldControl.managed(
        controller: notifier.archivePathController,
      ),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.pickerArchive,
        child: const Icon(FLucideIcons.folderOpen),
      ),
    );
  }

  Widget _buildBatchArchiveForm(BuildContext context, ParseForm notifier) {
    return FTextFormField(
      label: const Text('批量压缩包'),
      hint: Platform.isIOS ? '请选择一个或多个 ZIP 文件' : '请选择压缩包文件夹',
      control: FTextFieldControl.managed(
        controller: notifier.batchArchivePathController,
      ),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.pickerBatchArchive,
        child: const Icon(FLucideIcons.folderOpen),
      ),
    );
  }

  Widget _buildImageFolderForm(BuildContext context, ParseForm notifier) {
    return FTextFormField(
      label: const Text('图片路径'),
      hint: Platform.isIOS ? '请选择一个或多个图片文件' : '请选择图片文件夹',
      control: FTextFieldControl.managed(
        controller: notifier.imageFolderPathController,
      ),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.pickerImageFolder,
        child: const Icon(FLucideIcons.folderOpen),
      ),
    );
  }

  Widget _buildBatchImageFolderForm(BuildContext context, ParseForm notifier) {
    return FTextFormField(
      label: const Text('批量图片路径'),
      hint: Platform.isIOS ? '请选择多个图片文件（按文件夹分组）' : '请选择批量图片文件夹父目录',
      control: FTextFieldControl.managed(
        controller: notifier.batchImageFolderPathController,
      ),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.pickerBatchImageFolder,
        child: const Icon(FLucideIcons.folderOpen),
      ),
    );
  }

  Widget _buildPdfForm(BuildContext context, ParseForm notifier) {
    return FTextFormField(
      label: const Text('PDF 文件'),
      hint: '请选择 PDF 文件',
      control: FTextFieldControl.managed(
        controller: notifier.pdfPathController,
      ),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.pickerPdf,
        child: const Icon(FLucideIcons.folderOpen),
      ),
    );
  }

  Widget _buildBatchPdfForm(BuildContext context, ParseForm notifier) {
    return FTextFormField(
      label: const Text('批量 PDF'),
      hint: Platform.isIOS ? '请选择一个或多个 PDF 文件' : '请选择包含 PDF 的文件夹',
      control: FTextFieldControl.managed(
        controller: notifier.batchPdfPathController,
      ),
      suffixBuilder: (context, style, variants) => FButton.icon(
        style: style.obscureButtonStyle,
        onPress: notifier.pickerBatchPdf,
        child: const Icon(FLucideIcons.folderOpen),
      ),
    );
  }
}
