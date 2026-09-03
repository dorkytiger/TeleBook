import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/util/app_log.dart';
import 'package:tele_book/feature/book/repository/book_repository.dart';
import 'package:tele_book/feature/sync/service/sync_mutation_service.dart';

part 'book_form_provider.freezed.dart';

part 'book_form_provider.g.dart';

@freezed
abstract class BookFormState with _$BookFormState {
  const factory BookFormState({
    required String title,
    required List<BookFormPath> imagePaths,
  }) = _BookFormState;
}

@freezed
abstract class BookFormPath with _$BookFormPath {
  const factory BookFormPath({
    required String parentPath,
    required String subPath,
  }) = _BookFormPath;

  const BookFormPath._();

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

    titleController.addListener(() {
      if (state.hasValue) {
        state = AsyncValue.data(
          state.value!.copyWith(title: titleController.text),
        );
      }
    });
    final imagePaths = book.localSubPaths
        .map(
          (subPath) => BookFormPath(
            parentPath: GlobalConfig.booksDir.path,
            subPath: subPath,
          ),
        )
        .toList();
    return BookFormState(title: book.name, imagePaths: imagePaths);
  }

  Future<void> deleteImage(BookFormPath path) async {
    if (!state.hasValue) return;
    final current = state.requireValue;

    final updatePaths = current.imagePaths.where((p) => p != path).toList();
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

  /// 保存编辑：改名 / 删图 / 调序。
  ///
  /// 设计（秒存不卡 UI）：
  /// - 本地优先落库（name + 新 localSubPaths + 清空 previewSubPaths）→ 立即返回；
  /// - push 入队（同步只依赖 original 原图与顺序，不受 preview 影响）；
  /// - preview/封面在后台异步重建（编码在 isolate），完成后回填 previewSubPaths；
  ///   重建期间阅读器自动回退原图（顺序由 localSubPaths 保证，正确只是无缩略图）。
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
      // 纯改名（页序与图片集合完全没变）→ 不碰任何图片，秒存
      final imagesChanged = !_listEquals(book.localSubPaths, newSubPaths);
      final updatedBook = book.copyWith(
        name: newTitle,
        localSubPaths: newSubPaths,
        // 页序/集合变了：先清空 preview 引用（阅读回退原图，顺序正确），
        // 由后台重建完成后回填；纯改名则保持原 preview 不动。
        previewSubPaths: Value(
          imagesChanged ? const <String>[] : book.previewSubPaths,
        ),
      );

      // 本地立即生效（改名的元数据 / 新页序）→ 返回成功
      await ref.read(bookRepositoryProvider).updateBook(updatedBook);

      // 图片有变 → 后台重建 preview/封面（编码在 isolate，UI 不卡），
      // 完成后把 previewSubPaths 回填 DB；期间阅读走原图，不影响正确性。
      if (imagesChanged) {
        unawaited(_rebuildImagesInBackground(bookId, updatedBook));
      }

      // 入队同步（files 顺序 = 新 localSubPaths → 服务器/其它设备页序一致）
      await ref
          .read(syncMutationServiceProvider)
          .enqueueBookUpsert(book: updatedBook);
    });

    return !state.hasError;
  }

  /// 后台重建：封面 + 整本预览缩略图（encode 已 isolate 化，不卡 UI）。
  /// 重建成功后把新的 previewSubPaths 写回（基于最新行，避免覆盖并发编辑）。
  Future<void> _rebuildImagesInBackground(
    int bookId,
    BookTableData snapshot,
  ) async {
    try {
      await ref.read(bookRepositoryProvider).regenerateImages(snapshot);
    } catch (e) {
      // 重建失败不阻塞主流程：preview 缺失时阅读自动回退原图，
      // 下次编辑会再次触发重建。记录日志便于排查。
      AppLog.w('后台重建预览失败 book=$bookId: $e', tag: 'IMAGE');
    }
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
