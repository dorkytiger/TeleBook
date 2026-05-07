import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';

class BookFormViewmodel extends ChangeNotifier {
  final BookTableData book;
  final BookRepository _bookRepository;
  final List<BookFormPath> imagePaths = [];
  final TextEditingController titleController = TextEditingController();

  BookFormViewmodel(this.book, this._bookRepository) {
    titleController.text = book.name;
    for (final subPath in book.localSubPaths) {
      imagePaths.add(BookFormPath(GlobalConfig.booksDir.path, subPath));
    }
  }

  Future<void> deleteImage(BookFormPath path) async {
    imagePaths.remove(path);
    notifyListeners();
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= imagePaths.length) return;
    if (newIndex < 0 || newIndex > imagePaths.length) return;
    if (oldIndex == newIndex) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = imagePaths.removeAt(oldIndex);
    imagePaths.insert(newIndex, item);
    notifyListeners();
  }

  Future<void> updateBook(BuildContext context) async {
    final updatedBook = book.copyWith(
      name: titleController.text,
      localSubPaths: imagePaths.map((p) => p.subPath).toList(),
    );
    await _bookRepository.updateBook(updatedBook);
    context.go(AppRoute.book);
  }
}

class BookFormPath {
  final String parentPath;
  final String subPath;

  BookFormPath(this.parentPath, this.subPath);

  String get fullPath => '$parentPath/$subPath';
}
