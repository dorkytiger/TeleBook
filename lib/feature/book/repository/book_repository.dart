import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:tele_book/feature/book/service/book_image_service.dart';
import 'package:tele_book/core/util/uuid_util.dart';

/// 保存步骤枚举，用于 UI 分步展示进度
enum SaveStep {
  generateCover,
  generatePreview,
  saveOriginal,
  saveDatabase;

  String get label => switch (this) {
    SaveStep.generateCover => '生成封面图',
    SaveStep.generatePreview => '生成预览图',
    SaveStep.saveOriginal => '保存原图',
    SaveStep.saveDatabase => '保存数据',
  };
}

/// 已生成本地图片、待插入 DB 的书籍数据（同步导入的中间产物）。
class PreparedBook {
  final String uuid;
  final String name;
  final List<String> localSubPaths;
  final String coverSubPath;
  final List<String> previewSubPaths;

  const PreparedBook({
    required this.uuid,
    required this.name,
    required this.localSubPaths,
    required this.coverSubPath,
    required this.previewSubPaths,
  });
}

/// 在后台 Isolate 中递归删除目录列表
Future<void> _deleteBookDirs(List<String> dirPaths) async {
  for (final path in dirPaths) {
    try {
      final dir = Directory(path);
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
  }
}

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return BookRepository(database);
});

class BookRepository {
  final AppDatabase _db;
  late final BookLocalDatasource _bookLocalDatasource =
      _db.bookLocalDatasource;

  BookRepository(this._db);

  Stream<List<BookTableData>> watchAllBooks() {
    return _bookLocalDatasource.watchAllBooks();
  }

  /// 按本地 id 读取书籍（同步编排解析 uuid 用）。
  Future<BookTableData?> getBookById(int id) {
    return _bookLocalDatasource.getById(id);
  }

  Future<List<BookTableData>> getPagedBooks({
    int? page,
    int pageSize = 20,
    DateTime? lastCreatedAt,
    String? name,
    BookSort? sort,
  }) {
    return _bookLocalDatasource.getPagingBooks(
      page: page,
      lastCreatedAt: lastCreatedAt,
      limit: pageSize,
      name: name,
      sort: sort,
    );
  }

  Future<void> insertBook(BookTableCompanion book) {
    return _bookLocalDatasource.insertBook(book);
  }

  Future<void> updateBook(BookTableData book) {
    return _bookLocalDatasource.updateBook(book);
  }

  // ── 同步相关 ─────────────────────────────────

  /// 全量书籍（同步用）。
  Future<List<BookTableData>> getAllBooks() {
    return _bookLocalDatasource.getAllBooks();
  }

  /// 按同步 uuid 查询书籍。
  Future<BookTableData?> getBookByUuid(String uuid) {
    return _bookLocalDatasource.getByUuid(uuid);
  }

  /// 从服务器事件插入/更新一本书（仅逻辑字段，图片由文件同步补齐）。
  Future<void> upsertSyncedBook({
    required String uuid,
    required String name,
    int currentPage = 0,
  }) async {
    final existing = await _bookLocalDatasource.getByUuid(uuid);
    if (existing != null) {
      await _bookLocalDatasource.updateBook(
        existing.copyWith(name: name, currentPage: currentPage),
      );
      return;
    }
    await _bookLocalDatasource.insertBook(
      BookTableCompanion.insert(
        uuid: uuid,
        name: name,
        localSubPaths: const [],
      ),
    );
  }

  /// 同步拉取图片下载完成后，回填本地路径（原图 + 封面）。
  Future<void> updateSyncedBookFiles({
    required String uuid,
    required List<String> localSubPaths,
    String? coverSubPath,
  }) async {
    final existing = await _bookLocalDatasource.getByUuid(uuid);
    if (existing == null) return;
    await _bookLocalDatasource.updateBook(
      existing.copyWith(
        localSubPaths: localSubPaths,
        coverSubPath: Value(coverSubPath),
      ),
    );
  }

  /// 按同步 uuid 删除书籍（同步的 delete 事件）。
  Future<void> deleteBookByUuid(String uuid) async {
    await _bookLocalDatasource.deleteByUuid(uuid);
  }

  Future<Result<void>> deleteBook(int id) async {
    final book = await _bookLocalDatasource.getById(id);
    if (book == null) return Result.failure(BusinessFailure(message: '书籍不存在'));

    await _db.transaction(() async {
      await _bookLocalDatasource.deleteById(id);
    });

    // 通过 localSubPaths 推算 bookId 目录
    final bookDirs = <String>{};
    for (final subPath in book.localSubPaths) {
      final normalized = subPath.replaceAll('\\', '/');
      final segments = normalized.split('/').where((e) => e.isNotEmpty).toList();
      if (segments.isNotEmpty) {
        bookDirs.add(p.join(GlobalConfig.booksDir.path, segments.first));
      }
    }

    if (bookDirs.isNotEmpty) {
      await compute(_deleteBookDirs, bookDirs.toList());
    }

    return Result.success(null);
  }

  /// 保存单本书：封面 → 预览图 → 原图 → DB（本地原子路径；同步导入走 SyncMutationService）
  Future<Result<void>> saveAsBook(
    SaveAsBookDto dto, {
    void Function(SaveStep step, int current, int total)? onStepProgress,
  }) async {
    try {
      final prepared = await prepareBookImages(dto, onStepProgress: onStepProgress);
      await insertPreparedBook(prepared);
      return Result.success(null);
    } catch (e, st) {
      return Result.failure(
        BusinessFailure(message: '保存书籍失败', details: e, stackTrace: st),
      );
    }
  }

  /// 步骤一：生成本地图片（封面/预览/原图），返回待插入数据（不写 DB）。
  ///
  /// 供同步导入编排使用：先推送服务器，成功后再 [insertPreparedBook]。
  Future<PreparedBook> prepareBookImages(
    SaveAsBookDto dto, {
    void Function(SaveStep step, int current, int total)? onStepProgress,
  }) async {
    final bookId = Uuid.v4();
    final bookDir = '${GlobalConfig.booksDir.path}/$bookId';
    final originalDir = '$bookDir/original';
    final previewDir = '$bookDir/preview';
    final coverPath = '$bookDir/cover.jpg';

    try {
      // ① 生成封面图
      onStepProgress?.call(SaveStep.generateCover, 0, 1);
      await BookImageService.generateCover(dto.paths.first, coverPath);
      onStepProgress?.call(SaveStep.generateCover, 1, 1);

      // ② 生成预览图
      onStepProgress?.call(SaveStep.generatePreview, 0, dto.paths.length);
      await BookImageService.generatePreviewBatch(
        srcPaths: dto.paths,
        destDir: previewDir,
        onProgress: (current, total) {
          onStepProgress?.call(SaveStep.generatePreview, current, total);
        },
      );

      // ③ 复制原图（Isolate）
      onStepProgress?.call(SaveStep.saveOriginal, 0, dto.paths.length);
      final relPaths = await BookImageService.copyOriginals(
        dto.paths,
        originalDir,
        bookId,
      );
      onStepProgress?.call(SaveStep.saveOriginal, dto.paths.length, dto.paths.length);

      return PreparedBook(
        uuid: bookId,
        name: dto.title,
        localSubPaths: relPaths,
        coverSubPath: '$bookId/cover.jpg',
        previewSubPaths: List.generate(
          dto.paths.length,
          (i) => '$bookId/preview/${i.toString().padLeft(7, '0')}.jpg',
        ),
      );
    } catch (e) {
      await compute(_deleteBookDirs, [bookDir]);
      rethrow;
    }
  }

  /// 步骤二：把已准备的书籍数据写入 DB。
  Future<void> insertPreparedBook(PreparedBook book) async {
    await _bookLocalDatasource.insertBook(
      BookTableCompanion.insert(
        uuid: book.uuid,
        name: book.name,
        localSubPaths: book.localSubPaths,
        coverSubPath: Value(book.coverSubPath),
        previewSubPaths: Value(book.previewSubPaths),
      ),
    );
  }

  /// 清理已准备但未插入的书籍目录（同步推送失败时回滚用）。
  Future<void> discardPreparedBook(String uuid) async {
    final dir = Directory('${GlobalConfig.booksDir.path}/$uuid');
    if (await dir.exists()) {
      await compute(_deleteBookDirs, [dir.path]);
    }
  }

  /// 批量保存：逐本执行 封面→预览→原图，最后批量 DB 写入
  Future<Result<void>> saveBatchAsBooks(
    List<SaveAsBookDto> dos,
    Function(int count) onProgress,
  ) async {
    final createdDirs = <String>[];
    final bookData = <({
      String uuid,
      String title,
      List<String> relPaths,
      String coverSubPath,
      List<String> previewSubPaths,
    })>[];

    try {
      for (var i = 0; i < dos.length; i++) {
        final dto = dos[i];
        final bookId = Uuid.v4();
        final bookDir = '${GlobalConfig.booksDir.path}/$bookId';
        final originalDir = '$bookDir/original';
        final previewDir = '$bookDir/preview';
        final coverPath = '$bookDir/cover.jpg';

        await Future.delayed(Duration.zero);

        // ① 封面
        await BookImageService.generateCover(dto.paths.first, coverPath);

        // ② 预览图
        await BookImageService.generatePreviewBatch(
          srcPaths: dto.paths,
          destDir: previewDir,
        );

        // ③ 原图
        final relPaths = await BookImageService.copyOriginals(
          dto.paths,
          originalDir,
          bookId,
        );

        createdDirs.add(bookDir);

        final coverSubPath = '$bookId/cover.jpg';
        final previewSubPaths = List.generate(
          dto.paths.length,
          (j) => '$bookId/preview/${j.toString().padLeft(7, '0')}.jpg',
        );
        bookData.add((
          uuid: bookId,
          title: dto.title,
          relPaths: relPaths,
          coverSubPath: coverSubPath,
          previewSubPaths: previewSubPaths,
        ));

        onProgress(i + 1);
      }

      // ④ 批量 DB 写入
      await _db.transaction(() async {
        for (final book in bookData) {
          await _bookLocalDatasource.insertBook(
            BookTableCompanion.insert(
              uuid: book.uuid,
              name: book.title,
              localSubPaths: book.relPaths,
              coverSubPath: Value(book.coverSubPath),
              previewSubPaths: Value(book.previewSubPaths),
            ),
          );
        }
      });

      return Result.success(null);
    } catch (e, st) {
      if (createdDirs.isNotEmpty) {
        await compute(_deleteBookDirs, createdDirs);
      }
      return Result.failure(
        BusinessFailure(message: '批量保存书籍失败', details: e, stackTrace: st),
      );
    }
  }

  /// 为已存在的书籍重新生成封面和预览图（编辑场景）
  Future<void> regenerateImages(BookTableData book) async {
    final bookId = book.localSubPaths.first.split('/').first;
    final bookDir = '${GlobalConfig.booksDir.path}/$bookId';
    final previewDir = '$bookDir/preview';
    final coverPath = '$bookDir/cover.jpg';

    // 解析原图绝对路径
    final originalPaths = book.localSubPaths
        .map((sub) => GlobalConfig.resolveBookPath(sub))
        .toList();
    if (originalPaths.isEmpty) return;

    // 生成封面
    await BookImageService.generateCover(originalPaths.first, coverPath);

    // 生成预览图
    // 先清空旧的预览图目录
    final previewDirectory = Directory(previewDir);
    if (await previewDirectory.exists()) {
      await previewDirectory.delete(recursive: true);
    }
    await BookImageService.generatePreviewBatch(
      srcPaths: originalPaths,
      destDir: previewDir,
    );

    // 更新数据库
    final previewSubPaths = List.generate(
      originalPaths.length,
      (i) => '$bookId/preview/${i.toString().padLeft(7, '0')}.jpg',
    );
    final updatedBook = book.copyWith(
      coverSubPath: Value('$bookId/cover.jpg'),
      previewSubPaths: Value(previewSubPaths),
    );
    await _bookLocalDatasource.updateBook(updatedBook);
  }
}
