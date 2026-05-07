import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/model/parse_batch_archive_vo.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

class ParseBatchImageFolderViewmodel extends ChangeNotifier {
  final String parentDirPath;
  final ParseArchiveService parseArchiveService;
  final BookRepository bookRepository;

  List<ParseBatchArchiveVo> parseBatchFolderList = [];
  int completeCount = 0;
  int totalCount = 0;
  int saveAsBookCount = 0;
  EventState parseBatchFolderState = IdleEventState();
  EventState saveBatchAsBookState = IdleEventState();

  ParseBatchImageFolderViewmodel({
    required this.parentDirPath,
    required this.parseArchiveService,
    required this.bookRepository,
  }) {
    parseBatchFolders();
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

  Future<void> parseBatchFolders() async {
    parseBatchFolderState = LoadingEventState();
    notifyListeners();

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      parseBatchFolderState = ErrorEventState(
        "需要「所有文件访问权限」才能读取外部目录，请在系统设置中授权后重试。",
      );
      notifyListeners();
      return;
    }

    final result = await parseArchiveService.parseBatchImageFolders(
      parentDirPath,
      (total) {
        totalCount = total;
        notifyListeners();
      },
      (count) {
        completeCount = count;
        notifyListeners();
      },
    );

    result.fold(
      onSuccess: (data) {
        if (data.isEmpty) {
          parseBatchFolderState = EmptyEventState();
          notifyListeners();
          return;
        }
        parseBatchFolderList = data;
        parseBatchFolderState = SuccessEventState(data);
        notifyListeners();
      },
      onError: (error) {
        parseBatchFolderState = ErrorEventState(error.message);
        notifyListeners();
      },
    );
  }

  Future<void> saveBatchAsBook(BuildContext context) async {
    saveBatchAsBookState = LoadingEventState();
    notifyListeners();

    final dos = parseBatchFolderList
        .map((e) => SaveAsBookDto(title: e.name, paths: e.tempPaths))
        .toList();

    final result = await bookRepository.saveBatchAsBooks(dos, (count) {
      saveAsBookCount = count;
      notifyListeners();
    });

    result.fold(
      onSuccess: (_) {
        saveBatchAsBookState = SuccessEventState(null);
        saveAsBookCount = 0;
        notifyListeners();
        context.go(AppRoute.book);
      },
      onError: (error) {
        saveBatchAsBookState = ErrorEventState(error.message);
        saveAsBookCount = 0;
        notifyListeners();
      },
    );
  }
}

