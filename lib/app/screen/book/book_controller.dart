import 'dart:io';
import 'dart:async';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/enum/setting/book_layout_setting.dart';
import 'package:tele_book/app/enum/setting/setting_key.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/service/toast_service.dart';
import 'package:tele_book/app/util/pick_file_util.dart';
import 'package:tele_book/app/util/request_state.dart';

class BookController extends GetxController {
  final parseUrl = TextEditingController();
  final bookLayout = Rx<BookLayoutSetting>(BookLayoutSetting.list);
  final getBookState = Rx<RequestState<List<BookTableData>>>(Idle());
  final getCollectionState = Rx<RequestState<List<CollectionTableData>>>(
    Idle(),
  );
  final addBookToCollectionState = Rx<RequestState<void>>(Idle());
  final deleteBookState = Rx<RequestState<void>>(Idle());
  final exportBookState = Rx<RequestState<void>>(Idle());
  final exportMultipleBookState = Rx<RequestState<void>>(Idle());
  final exportAllBookProgress = 0.obs;
  final exportAllBookTotal = 0.obs;
  late final String appDirectory;
  late final SharedPreferences prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    initBookLayout();
    addBookToCollectionState.listenWithSuccess();
    appDirectory = (await getApplicationDocumentsDirectory()).path;
    exportBookState.listenWithSuccess();
    await fetchBooks();
  }

  @override
  void onReady() {
    super.onReady();
    fetchBooks(); // 每次路由激活时自动刷新
  }

  Future<void> initBookLayout() async {
    final layoutValue =
        prefs.getInt(SettingKey.bookLayout) ?? BookLayoutSetting.list.value;
    bookLayout.value = BookLayoutSetting.fromValue(layoutValue);
  }

  Future<void> fetchBooks() async {
    getBookState.value = Loading();
    try {
      debugPrint("Fetching books from database...");
      final appDatabase = Get.find<AppDatabase>();
      final books = await appDatabase.bookTable.select().get();
      if (books.isEmpty) {
        getBookState.value = Empty();
        return;
      }
      getBookState.value = Success(books);
    } catch (e) {
      debugPrint(e.toString());
      getBookState.value = Error(e.toString());
    }
  }

  Future<void> getCollections() async {
    await getCollectionState.runFuture(() async {
      final appDatabase = Get.find<AppDatabase>();
      final query = appDatabase.collectionTable.select()
        ..orderBy([
          (t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc),
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]);
      final collections = await query.get();
      return collections;
    });
  }

  Future<void> addBookToCollection(int bookId, int collectionId) async {
    await addBookToCollectionState.runFuture(() async {
      final appDatabase = Get.find<AppDatabase>();
      final existingEntry =
          await (appDatabase.collectionBookTable.select()..where(
                (tbl) =>
                    tbl.bookId.equals(bookId) &
                    tbl.collectionId.equals(collectionId),
              ))
              .getSingleOrNull();

      if (existingEntry != null) {
        // 已存在，不需要重复添加
        return;
      }

      await appDatabase.collectionBookTable.insertOnConflictUpdate(
        CollectionBookTableCompanion.insert(
          bookId: bookId,
          collectionId: collectionId,
        ),
      );
    });
  }

  Future<void> deleteBook(int id) async {
    deleteBookState.value.handleFunction(
      function: () async {
        final appDatabase = Get.find<AppDatabase>();
        final book =
            await (appDatabase.bookTable.select()
                  ..where((tbl) => tbl.id.equals(id)))
                .getSingle();

        // 删除本地文件
        for (final path in book.localPaths) {
          final file = File("$appDirectory/$path");
          if (await file.exists()) {
            await file.delete();
          }
        }

        await appDatabase.bookTable.deleteWhere((tbl) => tbl.id.equals(id));
        await fetchBooks();
      },
      onStateChanged: (newState) {
        deleteBookState.value = newState;
      },
    );
  }

  Future<void> exportSingleBook(BookTableData data) async {
    if (data.localPaths.isEmpty) return;

    final exportDir = await PickFileUtil.pickDirectory();

    if (exportDir != null) {
      exportBookState.value = Loading();

      // 使用 unawaited 让导出操作在后台执行，不阻塞 UI
      unawaited(
        _exportBook(
          exportDir,
          data,
          onError: (error) {
            exportBookState.value = Error(error);
            ToastService.dismiss();
            ToastService.showError('导出失败: $error');
          },
          onSuccess: (path) {
            exportBookState.value = Success(null);
            ToastService.dismiss();
            ToastService.showSuccess('导出成功');
          },
        ),
      );
    }
  }

  Future<void> exportMultipleBooks() async {
    if (!getBookState.value.isSuccess()) {
      return;
    }
    final books = getBookState.value.getSuccessData();

    if (books.isEmpty) return;

    final exportDir = await PickFileUtil.pickDirectory();

    if (exportDir != null) {
      exportMultipleBookState.value = Loading();
      exportAllBookProgress.value = 0;
      exportAllBookTotal.value = books.length;
      try {
        for (final book in books) {
          await _exportBook(exportDir, book);
          exportAllBookProgress.value += 1;
        }
        exportMultipleBookState.value = Success(null);
        exportAllBookProgress.value = 0;
        exportAllBookTotal.value = 0;
        ToastService.showSuccess('批量导出成功');
      } catch (e) {
        exportMultipleBookState.value = Error(e.toString());
        ToastService.showError('批量导出失败: $e');
      }
    }
  }

  Future<void> _exportBook(
    String exportDir,
    BookTableData data, {
    Function(String)? onError,
    Function(String)? onSuccess,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();

      debugPrint('📦 开始导出书籍: ${data.name} (${data.localPaths.length} 个文件)');

      // 读取所有文件内容
      final List<MapEntry<String, Uint8List>> fileContents = [];
      int index = 1;
      int notFoundCount = 0;

      for (final path in data.localPaths) {
        final fullPath = "${appDir.path}/$path";
        final file = File(fullPath);
        final exists = await file.exists();

        if (exists) {
          final fileName = "${index.toString().padLeft(8, '0')}.jpg";
          final fileBytes = await file.readAsBytes();
          fileContents.add(MapEntry(fileName, fileBytes));
          index++;
        } else {
          notFoundCount++;
          debugPrint('❌ 文件不存在: $fullPath');
        }
      }

      debugPrint('📊 导出统计: 成功 ${fileContents.length} 个，缺失 $notFoundCount 个');

      if (fileContents.isEmpty) {
        onError?.call('没有可导出的文件');
        return;
      }

      // 生成 zip 文件路径
      final timestamp = DateTime.now().toString().replaceAll(
        RegExp(r'[:\s\.]'),
        '_',
      );
      // 清理文件名中的非法字符（双引号、斜杠、反斜杠、冒号、星号、问号、尖括号、竖线等）
      final sanitizedName = data.name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final zipFileName = '${sanitizedName}_$timestamp.zip';
      final zipPath = p.join(exportDir, zipFileName);

      debugPrint('💾 导出文件名: $zipFileName');

      // 在后台线程中执行压缩操作，避免阻塞 UI
      final zipBytes = await compute(_compressFiles, fileContents);

      // 保存 zip 文件
      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipBytes);
      debugPrint('Books exported successfully to: $zipPath');
      onSuccess?.call(zipPath);
    } catch (e) {
      debugPrint('Export failed: $e');
      onError?.call(e.toString());
    }
  }

  // 静态方法，用于在 Isolate 中执行压缩操作
  static Uint8List _compressFiles(List<MapEntry<String, Uint8List>> files) {
    final archive = Archive();

    for (final entry in files) {
      final archiveFile = ArchiveFile(
        entry.key,
        entry.value.length,
        entry.value,
      );
      archive.addFile(archiveFile);
    }

    final zipEncoder = ZipEncoder();
    return Uint8List.fromList(zipEncoder.encode(archive));
  }
}
