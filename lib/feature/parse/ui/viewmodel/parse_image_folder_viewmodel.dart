import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

class ParseImageFolderViewmodel extends ChangeNotifier {
  final String folderPath;
  final ParseArchiveService parseArchiveService;
  final BookRepository bookRepository;

  EventState parseState = IdleEventState();
  EventState saveToBookState = IdleEventState();
  List<String> imagePaths = [];
  String folderName = "";

  ParseImageFolderViewmodel({
    required this.folderPath,
    required this.parseArchiveService,
    required this.bookRepository,
  }) {
    folderName = folderPath.split(RegExp(r'[\\/]')).last;
    parseImageFolder();
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

  Future<void> parseImageFolder() async {
    parseState = LoadingEventState();
    notifyListeners();

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      parseState = ErrorEventState("需要存储权限才能读取图片文件夹");
      notifyListeners();
      return;
    }

    final result = await parseArchiveService.parseImageFolder(folderPath);
    result.fold(
      onSuccess: (data) {
        imagePaths = data;
        parseState = data.isEmpty ? EmptyEventState() : SuccessEventState(data);
        notifyListeners();
      },
      onError: (error) {
        parseState = ErrorEventState(error.message);
        notifyListeners();
      },
    );
  }

  Future<void> saveToBook(BuildContext context) async {
    if (imagePaths.isEmpty || saveToBookState.isLoading) return;
    saveToBookState = LoadingEventState();
    notifyListeners();

    final result = await bookRepository.saveAsBook(
      SaveAsBookDto(title: folderName, paths: imagePaths),
    );
    result.fold(
      onSuccess: (_) {
        saveToBookState = SuccessEventState(null);
        notifyListeners();
        context.go(AppRoute.book);
      },
      onError: (error) {
        saveToBookState = ErrorEventState(error.message);
        notifyListeners();
      },
    );
  }
}

