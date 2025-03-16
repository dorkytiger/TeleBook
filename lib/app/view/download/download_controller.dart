import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
      var notifyPermission = await Permission.notification.status;
      if (notifyPermission.isDenied) {
       final result= await Permission.notification.request();
       if(result.isPermanentlyDenied){
          Get.defaultDialog(
              title: "提示",
              content: const Text("请前往设置中打开通知权限"),
              confirm: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("确定")));
          return;
       }
      }

      for (var index = 0; index < downloadList.length; index++) {
        final downloadTableData = downloadList[index];
        final bookPath = "${downloadTableData.id}-${downloadTableData.name}";

        List<DownloadTask> downloadTasks = [];
        List<String> bookSubPaths = [];
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
          downloadTasks.add(downloadTask);
          bookSubPaths.add(subPath);
        }
        final task = Task(downloadTableData, 0, 0);
        downloadTaskList.add(task);
        downloadTaskList.refresh();
        final batch = await FileDownloader()
            .configureNotification(
                groupNotificationId: 'batchDownload',
                running: TaskNotification(downloadTableData.name, ""),
                progressBar: true)
            .downloadBatch(downloadTasks,
                batchProgressCallback: (success, failed) async {
          downloadTaskList[index].success = success;
          downloadTaskList[index].fail = failed;
          downloadTaskList.refresh();
        }).whenComplete(() async {
          await (appDatabase.delete(appDatabase.downloadTable)
                ..where((t) => t.id.equals(downloadTableData.id)))
              .go();
          final bookData = await (appDatabase.select(appDatabase.bookTable)
                ..where((t) => t.id.equals(downloadTableData.bookId)))
              .getSingle();
          await appDatabase.update(appDatabase.bookTable).replace(
              bookData.copyWith(localPaths: bookSubPaths, isDownload: true));
          downloadTaskList.removeAt(index);
          downloadTaskList.refresh();
          await getDownloadList();
          final bookController = Get.find<BookController>();
          bookController.getBookList();
        });
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
  int success;
  int fail;

  Task(this.downloadTableData, this.success, this.fail);
}
