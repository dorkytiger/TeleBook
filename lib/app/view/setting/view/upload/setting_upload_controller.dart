import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/model/response/book_list_response_entity.dart';
import 'package:tele_book/app/service/tb_service.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingUploadController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final tbService = Get.find<TBService>();
  final getDownloadBookState = Rx<RequestState<List<BookTableData>>>(Idle());
  final uploadBookMap = Rx<Map<String, UploadBook>>({});
  final selectedUploadIds = Rx<List<String>>([]);
  final uploadBookState = Rx<RequestState<void>>(Idle());

  @override
  void onInit() {
    super.onInit();
    getDownloadBook();
  }

  Future<void> getDownloadBook() async {
    try {
      getDownloadBookState.value = Loading();
      final downloadBookList = await (appDatabase.select(appDatabase.bookTable)
            ..where((t) => t.isDownload.equals(true)))
          .get();
      if (downloadBookList.isEmpty) {
        getDownloadBookState.value = Empty();
        return;
      }
      final response = await tbService.getRequest("/book/all");
      final serverBookList = BookListResponseEntity.fromJson(response.data);
      final bookNameList = serverBookList.books.map((e) => e.name).toList();

      for (var book in downloadBookList) {
        final isUpload = bookNameList.contains(book.name);
        uploadBookMap.value[book.id.toString()] = UploadBook(book, isUpload,
            UploadBookStatus.idle, 0, book.localPaths.length, "");
      }
      getDownloadBookState.value = Success(downloadBookList);
    } catch (e) {
      debugPrint(e.toString());
      getDownloadBookState.value = Error(e.toString());
    }
  }

  Future<void> uploadBook() async {
    try {
      WakelockPlus.enable();
      uploadBookState.value = Loading();
      final localDoc = await getApplicationDocumentsDirectory();
      for (var id in selectedUploadIds.value) {
        final book = uploadBookMap.value[id]!.data;
        uploadBookMap.value[id]!.status = UploadBookStatus.uploading;
        uploadBookMap.refresh();
        List<String> serverImgUrls = [];
        for (var localPath in book.localPaths) {
          final filePath = "${localDoc.path}/$localPath";
          final response = await tbService.uploadFile("/upload/file", filePath,
              data: {"bookName": book.name},
              onSendProgress: (current, total) {});
          debugPrint("response:$response");
          if (response.statusCode == 200) {
            serverImgUrls.add(response.data["file_name"]);
            uploadBookMap.value[id]!.progress = serverImgUrls.length;
            uploadBookMap.refresh();
          } else {
            uploadBookState.value = Error(response.statusMessage ?? "上传失败");
            return;
          }
        }

        final response = await tbService.postRequest("/book/upsert", data: {
          "name": book.name,
          "base_url": book.baseUrl,
          "image_urls": book.imageUrls,
          "local_image_urls": serverImgUrls,
        });
        if (response.statusCode != 200) {
          uploadBookState.value = Error(response.statusMessage ?? "上传失败");
          uploadBookMap.refresh();
          return;
        }
        uploadBookMap.value[id]!.status = UploadBookStatus.success;
        uploadBookMap.refresh();
      }

      uploadBookState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      uploadBookState.value = Error(e.toString());
    }
    WakelockPlus.disable();
  }

  void setSelectedUploadIds(List<String> ids) {
    selectedUploadIds.value = ids;
  }
}

class UploadBook {
  BookTableData data;
  bool isUpload;
  UploadBookStatus status;
  int progress;
  int total;
  String errorMessage;

  UploadBook(this.data, this.isUpload, this.status, this.progress, this.total,
      this.errorMessage);
}

enum UploadBookStatus {
  idle,
  uploading,
  success,
  error,
}
