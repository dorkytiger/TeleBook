import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/service/parse_pdf_service.dart';

class ParseBatchPdfViewmodel extends ChangeNotifier {
  final String? pdfDirPath;
  final List<String>? pdfPaths;
  final ParsePdfService parsePdfService;
  final BookRepository bookRepository;

  List<ParseBatchArchiveVo> parseBatchList = [];
  int completeCount = 0;
  int totalCount = 0;
  String currentFileName = '';
  int currentFileProgress = 0;
  int currentFileTotal = 0;
  int saveAsBookCount = 0;

  EventState parseBatchState = const IdleEventState();
  EventState saveBatchAsBookState = const IdleEventState();

  String get currentFileProgressText {
    if (currentFileName.isEmpty) return '';
    if (currentFileTotal <= 0) return '当前文件进度：准备中';
    return '当前文件进度：$currentFileProgress / $currentFileTotal';
  }

  ParseBatchPdfViewmodel({
    this.pdfDirPath,
    this.pdfPaths,
    required this.parsePdfService,
    required this.bookRepository,
  }) {
    _parseBatch();
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    if (await Permission.manageExternalStorage.isGranted) return true;
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;
    if (await Permission.storage.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> _parseBatch() async {
    parseBatchState = const LoadingEventState();
    notifyListeners();

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      parseBatchState = const ErrorEventState(
        '需要「所有文件访问权限」才能读取外部目录，请在系统设置中授权后重试。',
      );
      notifyListeners();
      return;
    }

    final result = pdfPaths != null && pdfPaths!.isNotEmpty
        ? await parsePdfService.parseBatchPdfsFromPaths(
            pdfPaths!,
            (total) {
              totalCount = total;
              notifyListeners();
            },
            (count) {
              completeCount = count;
              notifyListeners();
            },
            onCurrentFileChanged: (fileName) {
              currentFileName = fileName;
              currentFileProgress = 0;
              currentFileTotal = 0;
              notifyListeners();
            },
            onCurrentFileProgress: (current, total) {
              currentFileProgress = current;
              currentFileTotal = total;
              notifyListeners();
            },
          )
        : await parsePdfService.parseBatchPdfs(
            pdfDirPath ?? '',
            (total) {
              totalCount = total;
              notifyListeners();
            },
            (count) {
              completeCount = count;
              notifyListeners();
            },
            onCurrentFileChanged: (fileName) {
              currentFileName = fileName;
              currentFileProgress = 0;
              currentFileTotal = 0;
              notifyListeners();
            },
            onCurrentFileProgress: (current, total) {
              currentFileProgress = current;
              currentFileTotal = total;
              notifyListeners();
            },
          );

    result.fold(
      onSuccess: (data) {
        if (data.isEmpty) {
          parseBatchState = const EmptyEventState();
          notifyListeners();
          return;
        }
        parseBatchList = data;
        parseBatchState = SuccessEventState(data);
        notifyListeners();
      },
      onError: (error) {
        parseBatchState = ErrorEventState(error.message);
        notifyListeners();
      },
    );
  }

  Future<void> saveBatchAsBook(BuildContext context) async {
    saveBatchAsBookState = const LoadingEventState();
    notifyListeners();

    final dos = parseBatchList
        .map((e) => SaveAsBookDto(title: e.name, paths: e.tempPaths))
        .toList();

    final result = await bookRepository.saveBatchAsBooks(dos, (count) {
      saveAsBookCount = count;
    });

    result.fold(
      onSuccess: (_) {
        saveBatchAsBookState = const SuccessEventState(null);
        saveAsBookCount = 0;
        notifyListeners();
        context.go(AppRoute.main);
      },
      onError: (error) {
        saveBatchAsBookState = ErrorEventState(error.message);
        saveAsBookCount = 0;
        notifyListeners();
      },
    );
  }
}

