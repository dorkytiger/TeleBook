import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/book_controller.dart';

class DownloadController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final getDownloadListState =
      Rx<RequestState<List<DownloadTableData>>>(Idle());
  final downloadTaskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDownloadList();
  }

  Future<void> getDownloadList() async {
    try {
      getDownloadListState.value = Loading();
      final downloadList =
          await appDatabase.select(appDatabase.downloadTable).get();
      if (downloadList.isEmpty) {
        getDownloadListState.value = Empty();
        return;
      }
      startDownload(downloadList);
      getDownloadListState.value = Success(downloadList);
    } catch (e) {
      getDownloadListState.value = Error("获取下载列表失败：${e.toString()}");
    }
  }

  Future<void> startDownload(List<DownloadTableData> downloadList) async {
    try {
      for (var index = 0; index < downloadList.length; index++) {
        final downloadTableData = downloadList[index];
        final bookPath = "${downloadTableData.id}-${downloadTableData.name}";
        final totalProgress = (downloadTableData.downloadCount /
                downloadTableData.imageUrls.length)
            .toDouble();
        final task =
            Task(downloadTableData, 0, totalProgress, TaskStatus.running, "");
        downloadTaskList.add(task);
        downloadTaskList.refresh();
        for (var i = downloadTableData.downloadCount;
            i < downloadTableData.imageUrls.length;
            i++) {
          final imageUrl = downloadTableData.imageUrls[i];
          final subPath = "$bookPath/$i.jpg";
          final downloadTask = DownloadTask(
              url: Uri.parse(imageUrl).toString(),
              directory: bookPath,
              filename: "$i.jpg",
              retries: 5,
              baseDirectory: BaseDirectory.applicationDocuments);
          final result = await FileDownloader().download(downloadTask,
              onProgress: (progress) {
            downloadTaskList[index].currentProgress = progress;
            downloadTaskList.refresh();
          });
          if (result.status != TaskStatus.complete) {
            downloadTaskList[index].status = TaskStatus.waitingToRetry;
            downloadTaskList[index].errorMessage =
                result.exception?.description ?? "未知错误";
            downloadTaskList.refresh();
            return;
          }
          downloadTableData.localPaths.add(subPath);
          await appDatabase
              .update(appDatabase.downloadTable)
              .replace(downloadTableData);
        }
        final bookData = await (appDatabase.select(appDatabase.bookTable)
              ..where((t) => t.id.equals(downloadTableData.bookId)))
            .getSingle();
        final newBookData = bookData.copyWith(
          localPaths: downloadTableData.localPaths,
          isDownload: true,
        );
        await appDatabase.update(appDatabase.bookTable).replace(newBookData);
        Get.find<BookController>().getBookList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteDownload(DownloadTableData downloadTableData) async {
    try {
      await (appDatabase.delete(appDatabase.downloadTable)
            ..where((t) => t.id.equals(downloadTableData.id)))
          .go();
      downloadTaskList.removeWhere(
          (element) => element.downloadTableData.id == downloadTableData.id);
      downloadTaskList.refresh();
      await getDownloadList();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class Task {
  DownloadTableData downloadTableData;
  double currentProgress;
  double totalProgress;
  TaskStatus status;
  String errorMessage = "";

  Task(this.downloadTableData, this.currentProgress, this.totalProgress,
      this.status, this.errorMessage);
}
