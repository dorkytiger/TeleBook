import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';

part 'book_form_provider.g.dart';

class BookFormState {
  final String title;
  final List<BookFormPath> imagePaths;

  BookFormState({required this.title, required this.imagePaths});

  BookFormState copyWith({String? title, List<BookFormPath>? imagePaths}) {
    return BookFormState(
      title: title ?? this.title,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}

class BookFormPath {
  final String parentPath;
  final String subPath;

  BookFormPath(this.parentPath, this.subPath);

  String get fullPath => '$parentPath/$subPath';
}

@riverpod
class BookForm extends _$BookForm {
  late final TextEditingController titleController;

  @override
  FutureOr<BookFormState> build(int bookId) async {
    ref.onDispose(() => titleController.dispose());
    final book = await ref
        .read(databaseProvider)
        .bookLocalDatasource
        .getById(bookId);
    if (book == null) throw Exception('书籍不存在');

    titleController = TextEditingController(text: book.name);

    titleController.addListener((){
      if(state.hasValue){
        state = AsyncValue.data(state.value!.copyWith(title: titleController.text));
      }
    });
    final imagePaths = book.localSubPaths
        .map((subPath) => BookFormPath(GlobalConfig.booksDir.path, subPath))
        .toList();
    return BookFormState(
      title: book.name,
      imagePaths: imagePaths,
    );
  }

  Future<void> deleteImage(BookFormPath path) async {
    if(!state.hasValue) return;
    final current =state.requireValue;

    final updatePaths = current.imagePaths.where((p) => p.fullPath != path.fullPath).toList();

    state = AsyncValue.data(current.copyWith(imagePaths: updatePaths));
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (!state.hasValue) return;
    final current = state.requireValue;

    if (oldIndex < 0 || oldIndex >= current.imagePaths.length) return;
    if (newIndex < 0 || newIndex > current.imagePaths.length) return;
    if (oldIndex == newIndex) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // 创建一个可变的新副本进行操作
    final updatedPaths = List<BookFormPath>.from(current.imagePaths);
    final item = updatedPaths.removeAt(oldIndex);
    updatedPaths.insert(newIndex, item);

    // 重新赋给 state 触发 UI 刷新
    state = AsyncData(current.copyWith(imagePaths: updatedPaths));
  }

}

@riverpod
class BookFormSubmit extends _$BookFormSubmit {

  @override
  FutureOr<void> build() => null;

  Future<bool> submit({
    required int bookId,
    required String title,
    required List<BookFormPath> imagePaths,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final book = await ref
          .read(databaseProvider)
          .bookLocalDatasource
          .getById(bookId);
      if (book == null) return;
      final newTitle = title;
      final newSubPaths = imagePaths.map((path) => path.subPath).toList();
      final updatedBook = book.copyWith(
        name: newTitle,
        localSubPaths: newSubPaths,
      );
      await ref
          .read(databaseProvider)
          .bookLocalDatasource
          .updateBook(updatedBook);
    });

    return !state.hasError;
  }
}
