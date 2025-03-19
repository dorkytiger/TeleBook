import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/nav/nav_controller.dart';
import 'package:tele_book/app/util/html_util.dart';
import 'package:tele_book/app/view/download/download_controller.dart';

import '../../util/request_state.dart';

class BookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final downloadController = Get.find<DownloadController>();
  final getBookListState = Rx<RequestState<List<BookTableData>>>(Idle());
  final addBookState = Rx<RequestState<void>>(Idle());
  final deleteBookState = Rx<RequestState<void>>(Idle());
  final deleteDownloadState = Rx<RequestState<void>>(Idle());
  final urlTextController = TextEditingController();
  PageController pageController = PageController();

  @override
  void onInit() async {
    getBookList();
    super.onInit();
    ever(addBookState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "添加成功",
          message: "添加书籍成功",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
            title: "添加失败",
            duration: const Duration(seconds: 3),
            message: state.getErrorMessage()));
        return;
      }
    });

    ever(deleteBookState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "删除成功",
          message: "删除书籍成功",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
            title: "删除失败",
            duration: Duration(seconds: 3),
            message: state.getErrorMessage()));
        return;
      }
    });

    ever(deleteDownloadState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "删除成功",
          message: "删除下载成功",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
            title: "删除失败",
            duration: const Duration(seconds: 3),
            message: state.getErrorMessage()));
        return;
      }
    });
  }

  Future<void> getBookList() async {
    try {
      getBookListState.value = Loading();
      final bookList = await appDatabase.select(appDatabase.bookTable).get();
      if (bookList.isEmpty) {
        getBookListState.value = Empty();
        return;
      }
      final document = await getApplicationDocumentsDirectory();
      final newBookList = bookList.map((e) {
        List<String> localPaths = e.localPaths;
        if (e.isDownload) {
          localPaths = e.localPaths.map((e) => "${document.path}/$e").toList();
        }
        final newData = e.copyWith(localPaths: localPaths);
        return newData;
      }).toList();
      getBookListState.value = Success(newBookList);
    } catch (e) {
      getBookListState.value = Error(e.toString());
    }
  }

  Future<void> addBook(Function closeDialog) async {
    try {
      addBookState.value = Loading();
      final baseUrl = urlTextController.text;
      final response = await GetConnect().get(baseUrl);
      if (response.hasError) {
        throw Exception(response.statusText);
      }
      final body = response.bodyString ?? "";
      final title = HtmlUtil.getTitle(body);
      final imgUrls = HtmlUtil.getImgUrls(baseUrl, body);

      await appDatabase.into(appDatabase.bookTable).insert(
          BookTableCompanion.insert(
              name: title,
              baseUrl: baseUrl,
              localPaths: [],
              imageUrls: imgUrls,
              createTime: DateTime.timestamp().toIso8601String()));
      addBookState.value = const Success(null);
      closeDialog();
      getBookList();
    } catch (e) {
      debugPrint(e.toString());
      addBookState.value = Error(e.toString());
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      deleteBookState.value = Loading();
      final tableData = await (appDatabase.select(appDatabase.bookTable)
        ..where((t) => t.id.equals(id)))
          .getSingle();
      final doc = await getApplicationDocumentsDirectory();
      for (var path in tableData.localPaths) {
        final localPath = "${doc.path}/$path";
        if (await File(localPath).exists()) {
          await File(localPath).delete();
        }
      }
      await (appDatabase.delete(appDatabase.bookTable)
        ..where((t) => t.id.equals(id)))
          .go();
      await getBookList();
      deleteBookState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      deleteBookState.value = Error(e.toString());
    }
  }

  Future<void> downLoadBook(BookTableData bookTableData) async {
    await appDatabase.into(appDatabase.downloadTable).insert(
        DownloadTableCompanion.insert(
            bookId: bookTableData.id,
            name: bookTableData.name,
            localPaths: [],
            imageUrls: bookTableData.imageUrls));
    downloadController.getDownloadList();
    Get.find<NavController>().setIndex(1);
  }

  Future<void> deleteDownload(BookTableData bookTableData) async {
    try {
      deleteDownloadState.value = Loading();
      final document = await getApplicationDocumentsDirectory();
      for (var i = 0; i < bookTableData.localPaths.length; i++) {
        final fileSubPath = bookTableData.localPaths[i];
        final file = File("${document.path}/$fileSubPath");
        if (await file.exists()) {
          await file.delete();
        }
      }
      final newBookData =
      bookTableData.copyWith(localPaths: [], isDownload: false);
      await appDatabase.update(appDatabase.bookTable).replace(newBookData);
      getBookList();
      deleteDownloadState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      deleteDownloadState.value = Error(e.toString());
    }
  }

  Future<void> saveImage(String url, String filePath) async {
    final imageResponse = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final saveFile = File(filePath);
    if (imageResponse.data != null) {
      await saveFile.writeAsBytes(imageResponse.data);
    }
  }

  void resetState() {
    addBookState.value = Idle();
    urlTextController.text = "";
  }
}

class BookEntity {
  final BookTableData bookData;
  final bool isDownloading;
  final double downloadProgress;

  BookEntity(this.bookData, this.isDownloading, this.downloadProgress);
}
