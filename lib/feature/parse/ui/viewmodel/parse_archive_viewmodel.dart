import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/service/parse_archive_service.dart';

class ParseArchiveViewmodel extends ChangeNotifier {
  final String archivePath;
  final ParseArchiveService parseArchiveService;
  final BookRepository bookRepository;
  EventState parseState = IdleEventState();
  EventState saveToBookState = IdleEventState();
  List<String> tempPaths = [];
  String archiveName = "";

  ParseArchiveViewmodel({
    required this.archivePath,
    required this.parseArchiveService,
    required this.bookRepository,
  }) {
    archiveName = archivePath.split(RegExp(r'[\\/]')).last;
    paseArchive();
  }

  Future<void> paseArchive() async {
    parseState = LoadingEventState();
    notifyListeners();

    final result = await parseArchiveService.parseArchive(archivePath);

    result.fold(
      onSuccess: (data) {
        tempPaths = data;
        parseState = SuccessEventState(data);
        notifyListeners();
      },
      onError: (error) {
        parseState = ErrorEventState(error.message);
        notifyListeners();
      },
    );
  }

  Future<void> saveToBook(BuildContext context) async {
    if (tempPaths.isEmpty || saveToBookState.isLoading) return;
    saveToBookState = LoadingEventState();
    notifyListeners();
    try {
      final result = await bookRepository.saveAsBook(
        SaveAsBookDto(title: archiveName, paths: tempPaths),
      );
      result.fold(
        onSuccess: (data) {
          saveToBookState = SuccessEventState(data);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("保存成功")));
          notifyListeners();
          context.go(AppRoute.book);
        },
        onError: (error) {
          saveToBookState = ErrorEventState(error.message);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("保存失败: ${error.message}")));
          notifyListeners();
        },
      );
    } catch (e) {
      saveToBookState = ErrorEventState(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("保存失败: $e")));
      notifyListeners();
    }
  }
}
