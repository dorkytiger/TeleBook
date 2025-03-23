import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/book_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class DownloadController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final getDownloadListState =
      Rx<RequestState<List<DownloadTableData>>>(Idle());
  final downloadTaskMap = Rx<Map<int, Task>>({});

  @override
  void onInit() {
    super.onInit();
    getDownloadList();
    ever(downloadTaskMap, (map) {
      if (map.isEmpty) {
        WakelockPlus.disable();
      } else {
        WakelockPlus.enable();
      }
    });
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
      for (var downloadTableData in downloadList) {
        if (downloadTaskMap.value[downloadTableData.id] != null) {
          continue;
        }
        startDownload(downloadTableData);
      }
      getDownloadListState.value = Success(downloadList);
    } catch (e) {
      getDownloadListState.value = Error("获取下载列表失败：${e.toString()}");
    }
  }

  Future<void> startDownload(DownloadTableData downloadTableData) async {
    try {
      final bookPath = "${downloadTableData.id}-${downloadTableData.name}";
      final totalProgress =
          (downloadTableData.downloadCount / downloadTableData.imageUrls.length)
              .toDouble();
      final task =
          Task(downloadTableData, 0, totalProgress, TaskStatus.running, "");
      downloadTaskMap.value[downloadTableData.id] = task;
      downloadTaskMap.refresh();
      final docPath = await getApplicationDocumentsDirectory();
      final dio = Dio();
      for (var i = downloadTableData.downloadCount;
          i < downloadTableData.imageUrls.length;
          i++) {
        final imageUrl = downloadTableData.imageUrls[i];
        final subPath = "$bookPath/$i.jpg";

        final response = await dio
            .download(imageUrl, "${docPath.path}/$subPath",
                onReceiveProgress: (count, total) {
          downloadTaskMap.value[downloadTableData.id]?.currentProgress =
              count / total;
          downloadTaskMap.refresh();
        });

        if (response.statusCode == 200) {
          final currentDownloadTableData =
              await (appDatabase.select(appDatabase.downloadTable)
                    ..where((t) => t.id.equals(downloadTableData.id)))
                  .getSingle();
          final newDownloadTableData = currentDownloadTableData.copyWith(
              downloadCount: i + 1,
              localPaths: [...currentDownloadTableData.localPaths, subPath]);
          await appDatabase
              .update(appDatabase.downloadTable)
              .replace(newDownloadTableData);
          downloadTaskMap.value[downloadTableData.id]?.downloadTableData =
              newDownloadTableData;
          downloadTaskMap.value[downloadTableData.id]?.totalProgress =
              (newDownloadTableData.downloadCount /
                      newDownloadTableData.imageUrls.length)
                  .toDouble();
          downloadTaskMap.value[downloadTableData.id]?.currentProgress = 0;
          downloadTaskMap.refresh();
        } else {
          throw Exception(response.statusMessage);
        }
      }
      final lastDownloadTableData =
          await (appDatabase.select(appDatabase.downloadTable)
                ..where((t) => t.id.equals(downloadTableData.id)))
              .getSingle();
      final bookData = await (appDatabase.select(appDatabase.bookTable)
            ..where((t) => t.id.equals(downloadTableData.bookId)))
          .getSingle();
      final newBookData = bookData.copyWith(
        localPaths: lastDownloadTableData.localPaths,
        isDownload: true,
      );
      await appDatabase.update(appDatabase.bookTable).replace(newBookData);
      await (appDatabase.delete(appDatabase.downloadTable)
            ..where((t) => t.id.equals(downloadTableData.id)))
          .go();
      downloadTaskMap.value.remove(downloadTableData.id);
      downloadTaskMap.refresh();
      getDownloadList();
      Get.find<BookController>().getBookList();
    } catch (e) {
      debugPrint(e.toString());
      downloadTaskMap.value[downloadTableData.id]?.status=
          TaskStatus.failed;
      downloadTaskMap.value[downloadTableData.id]?.errorMessage =
      e.toString();
    }
  }

  Future<void> deleteDownload(DownloadTableData downloadTableData) async {
    try {
      await (appDatabase.delete(appDatabase.downloadTable)
            ..where((t) => t.id.equals(downloadTableData.id)))
          .go();
      downloadTaskMap.value.remove(downloadTableData.id);
      downloadTaskMap.refresh();
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
