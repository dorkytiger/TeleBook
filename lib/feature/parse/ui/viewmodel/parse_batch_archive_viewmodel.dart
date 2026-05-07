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

class ParseBatchArchiveViewmodel extends ChangeNotifier {
  final String archiveDirPath;
  final ParseArchiveService parseArchiveService;
  final BookRepository bookRepository;
  List<ParseBatchArchiveVo> parseBatchArchiveList = [];
  int completeCount = 0;
  int totalCount = 0;
  int saveAsBookCount = 0;
  EventState parseBatchArchiveState = IdleEventState();
  EventState saveBatchAsBookState = IdleEventState();

  ParseBatchArchiveViewmodel({
    required this.archiveDirPath,
    required this.parseArchiveService,
    required this.bookRepository,
  }) {
    parseBatchArchive();
  }

  /// 请求外部存储权限，返回是否已获得
  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Android 11+（API 30+）需要 MANAGE_EXTERNAL_STORAGE 才能读取外部目录
    if (await Permission.manageExternalStorage.isGranted) return true;
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;

    // 降级：尝试普通 storage 权限（Android 10 及以下）
    if (await Permission.storage.isGranted) return true;
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> parseBatchArchive() async {
    parseBatchArchiveState = LoadingEventState();
    notifyListeners();

    // 先请求权限，未授权则直接返回错误状态
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      parseBatchArchiveState = ErrorEventState(
        "需要「所有文件访问权限」才能读取外部目录，请在系统设置中授权后重试。",
      );
      notifyListeners();
      return;
    }

    final result = await parseArchiveService.parseBatchArchives(
      archiveDirPath,
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
          parseBatchArchiveState = EmptyEventState();
          notifyListeners();
          return;
        }

        parseBatchArchiveList = data;
        parseBatchArchiveState = SuccessEventState(data);
        notifyListeners();
      },
      onError: (error) {
        parseBatchArchiveState = ErrorEventState(error.message);
        notifyListeners();
      },
    );
  }

  Future<void> saveBatchAsBook(BuildContext context) async {
    saveBatchAsBookState = LoadingEventState();
    notifyListeners();

    final dos = parseBatchArchiveList
        .map((e) => SaveAsBookDto(title: e.name, paths: e.tempPaths))
        .toList();

    final result = await bookRepository.saveBatchAsBooks(dos, (count) {
      saveAsBookCount = count;
    });

    result.fold(
      onSuccess: (data) {
        saveBatchAsBookState = SuccessEventState(data);
        notifyListeners();
        saveAsBookCount = 0;
        context.go(AppRoute.book);
      },
      onError: (error) {
        saveBatchAsBookState = ErrorEventState(error.message);
        notifyListeners();
        saveAsBookCount = 0;
      },
    );
  }
}
