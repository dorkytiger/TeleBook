import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/model/response/book_list_response_entity.dart';
import 'package:tele_book/app/service/tb_service.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/book_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingDownloadController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final tbService = Get.find<TBService>();
  final getDownloadBookState = Rx<RequestState<BookListResponseEntity>>(Idle());
  final downloadBookMap = Rx<Map<String, DownloadBook>>({});
  final selectedDownloadIds = Rx<List<String>>([]);
  final downloadBookState = Rx<RequestState<void>>(Idle());

  @override
  void onInit() {
    super.onInit();
    getDownloadBook();
  }

  Future<void> getDownloadBook() async {
    try {
      getDownloadBookState.value = Loading();
      final response = await tbService.getRequest("/book/all");
      final serverBookList = BookListResponseEntity.fromJson(response.data);

      if (serverBookList.books.isEmpty) {
        getDownloadBookState.value = Empty();
        return;
      }
      final localBookList = (await (appDatabase.select(appDatabase.bookTable)
                ..where((t) => t.isDownload.equals(true)))
              .get())
          .map((e) => e.name);

      for (var book in serverBookList.books) {
        final isDownload = localBookList.contains(book.name);
        downloadBookMap.value[book.id.toString()] = DownloadBook(
            book,
            isDownload,
            DownloadBookStatus.idle,
            0,
            book.localImageUrls.length,
            "");
      }
      getDownloadBookState.value = Success(serverBookList);
    } catch (e) {
      debugPrint(e.toString());
      getDownloadBookState.value = Error(e.toString());
    }
  }

  Future<void> downloadBook() async {
    try {
      WakelockPlus.enable();
      downloadBookState.value = Loading();
      final localDoc = await getApplicationDocumentsDirectory();
      for (var id in selectedDownloadIds.value) {
        final book = downloadBookMap.value[id]!.data;
        downloadBookMap.value[id]!.status = DownloadBookStatus.downloading;
        downloadBookMap.refresh();
        List<String> localPaths = [];
        for (var i = 0; i < book.localImageUrls.length; i++) {
          final filePath = "${book.name}/$i";
          final response = await tbService.downloadFile(
              book.localImageUrls[i], "${localDoc.path}/$filePath",
              onReceiveProgress: (current, total) {});
          if (response.statusCode == 200) {
            localPaths.add(filePath);
            downloadBookMap.value[id]!.progress = localPaths.length;
            downloadBookMap.refresh();
          } else {
            downloadBookState.value = const Error("下载失败");
            return;
          }
        }
        final localBook = (await (appDatabase.select(appDatabase.bookTable)
              ..where((t) => t.name.equals(book.name)))
            .getSingleOrNull());
        if (localBook != null) {
          await appDatabase.update(appDatabase.bookTable).replace(
              localBook.copyWith(localPaths: localPaths, isDownload: true));
        } else {
          await appDatabase.into(appDatabase.bookTable).insert(
              BookTableCompanion.insert(
                  name: book.name,
                  baseUrl: book.baseUrl,
                  localPaths: localPaths,
                  imageUrls: book.imageUrls,
                  createTime: DateTime.now().toIso8601String()));
        }
        Get.find<BookController>().getBookList();
        downloadBookMap.value[id]!.status = DownloadBookStatus.success;
        downloadBookMap.refresh();
      }

      downloadBookState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      downloadBookState.value = Error(e.toString());
    }
    WakelockPlus.disable();
  }

  void setSelectedDownloadIds(List<String> ids) {
    selectedDownloadIds.value = ids;
  }
}

class DownloadBook {
  BookListResponseBooks data;
  bool isDownload;
  DownloadBookStatus status;
  int progress;
  int total;
  String errorMessage;

  DownloadBook(this.data, this.isDownload, this.status, this.progress,
      this.total, this.errorMessage);
}

enum DownloadBookStatus {
  idle,
  downloading,
  success,
  error,
}
