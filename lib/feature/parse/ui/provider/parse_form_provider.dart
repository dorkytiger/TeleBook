import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/url_util.dart';

part 'parse_form_provider.freezed.dart';

part 'parse_form_provider.g.dart';

@freezed
abstract class ParseFormState with _$ParseFormState {
  const factory ParseFormState({
    @Default(ParseFormType.web) ParseFormType type,
    @Default('') String url,
    @Default('') String archivePath,
    @Default('') String batchArchivePath,
    @Default(<String>[]) List<String> batchArchivePaths,
    @Default('') String imageFolderPath,
    @Default(<String>[]) List<String> imagePaths,
    @Default('') String batchImageFolderPath,
    @Default(<String>[]) List<String> batchImagePaths,
    @Default('') String pdfPath,
    @Default('') String batchPdfPath,
    @Default(<String>[]) List<String> batchPdfPaths,
  }) = _ParseFormState;
}

@riverpod
class ParseForm extends _$ParseForm {
  late final TextEditingController urlController;
  late final TextEditingController archivePathController;
  late final TextEditingController batchArchivePathController;
  late final TextEditingController imageFolderPathController;
  late final TextEditingController batchImageFolderPathController;
  late final TextEditingController pdfPathController;
  late final TextEditingController batchPdfPathController;

  @override
  ParseFormState build() {
    urlController = TextEditingController();
    archivePathController = TextEditingController();
    batchArchivePathController = TextEditingController();
    imageFolderPathController = TextEditingController();
    batchImageFolderPathController = TextEditingController();
    pdfPathController = TextEditingController();
    batchPdfPathController = TextEditingController();

    ref.onDispose(() {
      urlController.dispose();
      archivePathController.dispose();
      batchArchivePathController.dispose();
      imageFolderPathController.dispose();
      batchImageFolderPathController.dispose();
      pdfPathController.dispose();
      batchPdfPathController.dispose();
    });

    return const ParseFormState();
  }

  void setType(ParseFormType? type) {
    if (type == null) return;
    state = state.copyWith(type: type);
  }

  void onParse(BuildContext context) {
    switch (state.type) {
      case ParseFormType.web:
        final uri = normalizeWebUrl(urlController.text);
        if (uri == null) {
          showFToast(context: context, title: Text('网址无效，请检查格式'));
          return;
        }
        context.push(AppRoute.parseWeb, extra: uri.toString());
        break;
      case ParseFormType.archive:
        context.push(AppRoute.parseArchiveSingle, extra: state.archivePath);
        break;
      case ParseFormType.batchArchive:
        context.push(
          AppRoute.parseArchiveBatch,
          extra: state.batchArchivePaths.isNotEmpty
              ? state.batchArchivePaths
              : state.batchArchivePath,
        );
        break;
      case ParseFormType.imageFolder:
        context.push(
          AppRoute.parseImageFolder,
          extra: state.imagePaths.isNotEmpty
              ? state.imagePaths
              : state.imageFolderPath,
        );
        break;
      case ParseFormType.batchImageFolder:
        context.push(
          AppRoute.parseBatchImageFolder,
          extra: state.batchImagePaths.isNotEmpty
              ? state.batchImagePaths
              : state.batchImageFolderPath,
        );
        break;
      case ParseFormType.pdf:
        context.push(AppRoute.parsePdf, extra: state.pdfPath);
        break;
      case ParseFormType.batchPdf:
        context.push(
          AppRoute.parseBatchPdf,
          extra: state.batchPdfPaths.isNotEmpty
              ? state.batchPdfPaths
              : state.batchPdfPath,
        );
        break;
    }
  }

  Future<void> getClipboardUrl() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final text = clipboardData?.text ?? '';
    if (Uri.tryParse(text)?.hasAbsolutePath == true) {
      urlController.text = text;
    }
  }

  Future<void> pickerArchive() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: '选择 tele_book 导出的书籍归档文件',
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      archivePathController.text = path;
      state = state.copyWith(archivePath: path);
    }
  }

  Future<void> pickerBatchArchive() async {
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: '选择一个或多个 ZIP 压缩包',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        final text = paths.isEmpty ? '' : '已选择 ${paths.length} 个 ZIP 文件';
        batchArchivePathController.text = text;
        state = state.copyWith(
          batchArchivePaths: paths,
          batchArchivePath: text,
        );
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '选择 tele_book 导出��书籍归档文件夹',
    );
    if (result != null) {
      batchArchivePathController.text = result;
      state = state.copyWith(
        batchArchivePaths: const [],
        batchArchivePath: result,
      );
    }
  }

  Future<void> pickerImageFolder() async {
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: '选择图片文件',
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        final text = paths.isEmpty ? '' : '已选择 ${paths.length} 张图片';
        imageFolderPathController.text = text;
        state = state.copyWith(imagePaths: paths, imageFolderPath: text);
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '选择包含图片的文件夹',
    );
    if (result != null) {
      imageFolderPathController.text = result;
      state = state.copyWith(imagePaths: const [], imageFolderPath: result);
    }
  }

  Future<void> pickerBatchImageFolder() async {
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: '选择批量图片文件',
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        final text = paths.isEmpty ? '' : '已选择 ${paths.length} 张图片（按所在文件夹分组）';
        batchImageFolderPathController.text = text;
        state = state.copyWith(
          batchImagePaths: paths,
          batchImageFolderPath: text,
        );
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '选择批量图片文件夹的父目录',
    );
    if (result != null) {
      batchImageFolderPathController.text = result;
      state = state.copyWith(
        batchImagePaths: const [],
        batchImageFolderPath: result,
      );
    }
  }

  Future<void> pickerPdf() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: '选择 PDF 文件',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      pdfPathController.text = path;
      state = state.copyWith(pdfPath: path);
    }
  }

  Future<void> pickerBatchPdf() async {
    if (Platform.isIOS) {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: '选择一个或多个 PDF 文件',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );
      if (result != null) {
        final paths = result.paths.whereType<String>().toList();
        final text = paths.isEmpty ? '' : '已选择 ${paths.length} 个 PDF 文件';
        batchPdfPathController.text = text;
        state = state.copyWith(batchPdfPaths: paths, batchPdfPath: text);
      }
      return;
    }

    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: '选择包含 PDF 的文件夹',
    );
    if (result != null) {
      batchPdfPathController.text = result;
      state = state.copyWith(batchPdfPaths: const [], batchPdfPath: result);
    }
  }
}

enum ParseFormType {
  web("网页"),
  archive("压缩包"),
  batchArchive("批量压缩包"),
  imageFolder("图片文件夹"),
  batchImageFolder("批量图片文件夹"),
  pdf("PDF"),
  batchPdf("批量PDF");

  final String description;

  const ParseFormType(this.description);
}
