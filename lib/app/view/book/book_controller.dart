import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wo_nas/app/db/app_database.dart';
import 'package:wo_nas/app/util/html_util.dart';

import '../../util/request_state.dart';

class BookController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();
  final getBookListState = Rx<RequestState<List<BookTableData>>>(Idle());
  final bookEntityList = <BookEntity>[].obs;
  final addBookState = Rx<RequestState<void>>(Idle());
  final deleteBookState = Rx<RequestState<void>>(Idle());
  final urlTextController = TextEditingController();
  PageController pageController = PageController();

  @override
  void onInit() async {
    getBookList();
    super.onInit();
    ever(addBookState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          title: "添加成功",
          message: "添加书籍成功",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(
            GetSnackBar(title: "添加失败", message: state.getErrorMessage()));
        return;
      }
    });

    ever(deleteBookState, (state){
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          title: "删除成功",
          message: "删除书籍成功",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(
            GetSnackBar(title: "删除失败", message: state.getErrorMessage()));
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
      bookEntityList.value =
          bookList.map((e) => BookEntity(e, false, 0)).toList();
      getBookListState.value = Success(bookList);
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
      for (var file in tableData.localPaths) {
        if (await File(file).exists()) {
          await File(file).delete();
        }
      }
      await (appDatabase.delete(appDatabase.bookTable)
            ..where((t) => t.id.equals(id)))
          .go();
      deleteBookState.value = const Success(null);
      getBookList();
    } catch (e) {
      debugPrint(e.toString());
      deleteBookState.value = Error(e.toString());
    }
  }

  Future<void> downLoadBook(BookEntity bookEntity) async {
    final index = bookEntityList.indexOf(bookEntity);
    try {
      bookEntityList[index] = BookEntity(bookEntity.bookData, true, 0);
      bookEntityList.refresh();

      final bookPath = await createBookPath(
          "${bookEntity.bookData.id}-${bookEntity.bookData.name}");

      for (var i = bookEntity.bookData.downloadCount;
          i < bookEntity.bookData.imageUrls.length;
          i++) {
        final url = bookEntity.bookData.imageUrls[i];
        final filePath = "$bookPath/$i.jpg";
        await saveImage(url, filePath);
        debugPrint("下载图片：$filePath");
        final localPaths = bookEntity.bookData.localPaths;
        localPaths.add(filePath);

        final newBookData = bookEntityList[index]
            .bookData
            .copyWith(localPaths: localPaths, downloadCount: i + 1);
        await appDatabase.update(appDatabase.bookTable).replace(newBookData);
        bookEntityList[index] = BookEntity(
            bookEntity.bookData.copyWith(localPaths: localPaths),
            true,
            (i + 1) / bookEntity.bookData.imageUrls.length);
        bookEntityList.refresh();
      }
      final newBookData = bookEntityList[index]
          .bookData
          .copyWith(isDownload: true, downloadCount: 0);
      await appDatabase.update(appDatabase.bookTable).replace(newBookData);
      bookEntityList[index] = BookEntity(newBookData, false, 0);
      bookEntityList.refresh();
    } catch (e) {
      debugPrint(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "下载${bookEntity.bookData.name}失败",
        message: e.toString(),
      ));
    }
    getBookList();
  }

  Future<void> deleteDownload(BookEntity bookEntity) async {
    try {
      final index = bookEntityList.indexOf(bookEntity);
      for (var i = 0; i < bookEntity.bookData.localPaths.length; i++) {
        final filePath = bookEntity.bookData.localPaths[i];
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      final newBookData = bookEntityList[index]
          .bookData
          .copyWith(localPaths: [], isDownload: false);
      await appDatabase.update(appDatabase.bookTable).replace(newBookData);
      bookEntityList[index] = BookEntity(newBookData, false, 0);
      bookEntityList.refresh();
      getBookList();
      Get.showSnackbar(GetSnackBar(
        title: "删除${bookEntity.bookData.name}成功",
        message: "删除成功",
      ));
    } catch (e) {
      debugPrint(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "删除${bookEntity.bookData.name}失败",
        message: e.toString(),
      ));
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

  Future<String> createBookPath(String name) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final appPath = "${appDirectory.path}/TeleBook";
    if (!await Directory(appPath).exists()) {
      await Directory(appPath).create();
    }
    final bookPath = "$appPath/$name";

    if (!await Directory(bookPath).exists()) {
      await Directory(bookPath).create();
    }
    return bookPath;
  }
}

class BookEntity {
  final BookTableData bookData;
  final bool isDownloading;
  final double downloadProgress;

  BookEntity(this.bookData, this.isDownloading, this.downloadProgress);
}
