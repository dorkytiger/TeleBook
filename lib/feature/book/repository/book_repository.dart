import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/core/util/failure_util.dart';
import 'package:tele_book/core/util/result_util.dart';
import 'package:tele_book/feature/book/datasource/local/book_local_datasource.dart';
import 'package:tele_book/feature/book/enum/book_sort.dart';
import 'package:tele_book/feature/book/model/dto/save_as_book_dto.dart';
import 'package:uuid/uuid.dart';

import '../../../common/config/global_config.dart';

// ── 顶层函数（供 compute() 在 Isolate 中调用）─────────────

class _CopyBookArgs {
  final String bookId;
  final String destDirPath;
  final List<String> srcPaths;
  _CopyBookArgs({required this.bookId, required this.destDirPath, required this.srcPaths});
}

/// 在后台 Isolate 中复制文件，返回存储用的相对路径列表
Future<List<String>> _copyBookFiles(_CopyBookArgs args) async {
  final dir = Directory(args.destDirPath);
  await dir.create(recursive: true);
  final relPaths = <String>[];
  for (var i = 0; i < args.srcPaths.length; i++) {
    final src = File(args.srcPaths[i]);
    if (!await src.exists()) {
      throw FileSystemException('source file not found', args.srcPaths[i]);
    }
    final fileName = i.toString().padLeft(7, '0');
    await src.copy('${args.destDirPath}/$fileName');
    relPaths.add('${args.bookId}/$fileName');
  }
  return relPaths;
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

class BookRepository {
  final AppDatabase _db;
  late final BookLocalDatasource _bookLocalDatasource = _db.bookLocalDatasource;

  BookRepository(this._db);

  Stream<List<BookTableData>> watchBooks({
    int? page,
    int? pageSize,
    DateTime? lastCreatedAt,
    String? name,
    BookSort? sort,
  }) {
    return _bookLocalDatasource.watchBooks(
      page: page,
      pageSize: pageSize,
      lastCreatedAt: lastCreatedAt,
      name: name,
      sort: sort,
    );
  }

  Future<List<BookTableData>> fetchBooks({
    int? page,
    int? pageSize,
    DateTime? lastCreatedAt,
    String? name,
    BookSort? sort,
  }) async {
    return _bookLocalDatasource.getBooks(
      page: page,
      lastCreatedAt: lastCreatedAt,
      limit: pageSize ?? 20,
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

  Future<Result<void>> deleteBook(int id) async {
    final book = await _bookLocalDatasource.getById(id);
    if (book == null) return Result.failure(BusinessFailure(message: '书籍不存在'));

    // 先删 DB 记录
    await _db.transaction(() async {
      await _bookLocalDatasource.deleteById(id);
    });

    // 计算要删的目录（把文件清理放到后台 Isolate）
    final bookDirs = <String>{};
    for (final subPath in book.localSubPaths) {
      if (p.isAbsolute(subPath)) {
        bookDirs.add(p.dirname(subPath));
      } else {
        final normalized = subPath.replaceAll('\\', '/');
        final segments = normalized.split('/').where((e) => e.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          bookDirs.add(p.join(GlobalConfig.booksDir.path, segments.first));
        }
      }
    }

    // 后台 Isolate 删除目录，不阻塞主线程
    if (bookDirs.isNotEmpty) {
      await compute(_deleteBookDirs, bookDirs.toList());
    }

    return Result.success(null);
  }

  /// 保存单本书：文件复制在后台 Isolate，DB 写入在主线程
  Future<Result<void>> saveAsBook(SaveAsBookDto dto) async {
    final bookId = const Uuid().v4();
    final destDirPath = '${GlobalConfig.booksDir.path}/$bookId';

    try {
      // ① 文件复制放后台 Isolate
      final relPaths = await compute(
        _copyBookFiles,
        _CopyBookArgs(bookId: bookId, destDirPath: destDirPath, srcPaths: dto.paths),
      );

      // ② DB 写入（快，主线程即可）
      await _bookLocalDatasource.insertBook(
        BookTableCompanion.insert(name: dto.title, localSubPaths: relPaths),
      );

      return Result.success(null);
    } catch (e, st) {
      // 清理已创建的目录（后台 Isolate）
      await compute(_deleteBookDirs, [destDirPath]);
      return Result.failure(BusinessFailure(message: '保存书籍失败', details: e, stackTrace: st));
    }
  }

  /// 批量保存：
  ///   ① 按书逐一复制文件（后台 Isolate，循环间让出 UI 线程）
  ///   ② 全部复制成功后，批量 DB 写入（单事务）
  ///   ③ 任意环节失败，清理已复制的目录
  Future<Result<void>> saveBatchAsBooks(
    List<SaveAsBookDto> dos,
    Function(int count) onProgress,
  ) async {
    // 记录已创建目录，用于失败回滚
    final createdDirs = <String>[];
    // 记录每本书的（相对路径列表, 标题）
    final bookData = <({String title, List<String> relPaths})>[];

    try {
      // ── 阶段一：文件复制（在后台 Isolate，不在 DB 事务内）──
      for (var i = 0; i < dos.length; i++) {
        final dto = dos[i];
        final bookId = const Uuid().v4();
        final destDirPath = '${GlobalConfig.booksDir.path}/$bookId';

        // 每本书让出一次事件循环，保持 UI 刷新
        await Future.delayed(Duration.zero);

        final relPaths = await compute(
          _copyBookFiles,
          _CopyBookArgs(bookId: bookId, destDirPath: destDirPath, srcPaths: dto.paths),
        );

        createdDirs.add(destDirPath);
        bookData.add((title: dto.title, relPaths: relPaths));
        onProgress(i + 1);
      }

      // ── 阶段二：批量 DB 写入（单事务，仅 DB 操作，耗时极短）──
      await _db.transaction(() async {
        for (final book in bookData) {
          await _bookLocalDatasource.insertBook(
            BookTableCompanion.insert(name: book.title, localSubPaths: book.relPaths),
          );
        }
      });

      return Result.success(null);
    } catch (e, st) {
      // DB 若已写入则由 Drift 事务回滚，清理已复制的文件目录
      if (createdDirs.isNotEmpty) {
        await compute(_deleteBookDirs, createdDirs);
      }
      return Result.failure(
        BusinessFailure(message: '批量保存书籍失败', details: e, stackTrace: st),
      );
    }
  }
}
