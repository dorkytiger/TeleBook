import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/core/util/state_util.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/parse/service/parse_pdf_service.dart';

class ParsePdfViewmodel extends ChangeNotifier {
  final String pdfPath;
  final ParsePdfService parsePdfService;
  final BookRepository bookRepository;

  EventState parseState = const IdleEventState();
  EventState saveToBookState = const IdleEventState();

  List<String> tempPaths = [];
  String pdfName = '';
  int currentPage = 0;
  int totalPages = 0;

  ParsePdfViewmodel({
    required this.pdfPath,
    required this.parsePdfService,
    required this.bookRepository,
  }) {
    pdfName = pdfPath.split(RegExp(r'[\\/]')).last.replaceAll('.pdf', '');
    _parsePdf();
  }

  Future<void> _parsePdf() async {
    parseState = const LoadingEventState();
    notifyListeners();

    final result = await parsePdfService.parsePdf(
      pdfPath,
      onProgress: (current, total) {
        currentPage = current;
        totalPages = total;
        notifyListeners();
      },
    );

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
    saveToBookState = const LoadingEventState();
    notifyListeners();

    try {
      final result = await bookRepository.saveAsBook(
        SaveAsBookDto(title: pdfName, paths: tempPaths),
      );
      result.fold(
        onSuccess: (_) {
          saveToBookState = const SuccessEventState(null);
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存成功')),
          );
          context.go(AppRoute.book);
        },
        onError: (error) {
          saveToBookState = ErrorEventState(error.message);
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('保存失败: ${error.message}')),
          );
        },
      );
    } catch (e) {
      saveToBookState = ErrorEventState(e.toString());
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
    }
  }
}

