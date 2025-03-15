import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/book_controller.dart';

class SettingController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final _getSettingDataState = Rx<RequestState<SettingTableData>>(Idle());

  get getSettingDataState => _getSettingDataState.value;

  final _skipDuplicates = true.obs;

  get skipDuplicate => _skipDuplicates.value;

  final _importBookDataState = Rx<RequestState<void>>(Idle());

  final _exportBookDataState = Rx<RequestState<String>>(Idle());

  final bookController = Get.find<BookController>();

  @override
  void onInit() {
    getSettingData();
    super.onInit();
    ever(_exportBookDataState, (RequestState<String> state) {
      if (state.isSuccess()) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "导出成功",
          message: "文件路径：${state.getSuccessData()}",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "导出失败",
          message: state.getErrorMessage(),
        ));
        return;
      }
    });
    ever(_importBookDataState, (state) {
      if (state.isSuccess()) {
        bookController.getBookList();
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "导入成功",
          message: "已写入数据库",
        ));
        return;
      }
      if (state.isError()) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "导入失败",
          message: state.getErrorMessage(),
        ));
        return;
      }
    });
  }

  Future<void> getSettingData() async {
    try {
      _getSettingDataState.value = Loading();
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      _getSettingDataState.value = Success(settingData);
    } catch (e) {
      _getSettingDataState.value = Error(e.toString());
      debugPrint(e.toString());
    }
  }

  Future<void> updateSettingData(SettingTableData settingData) async {
    try {
      await appDatabase.update(appDatabase.settingTable).replace(settingData);
      getSettingData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> importBookData() async {
    try {
      _importBookDataState.value = Loading();
      // Get the file
      final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (file == null) {
        return;
      }

      // Read the JSON data from the file
      final jsonData = await File(file.files.first.path!).readAsString();

      // Convert the JSON data to a list of book data
      final bookDataList = (jsonDecode(jsonData) as List)
          .map((book) => BookTableData.fromJson(book as Map<String, dynamic>))
          .toList();

      if (_skipDuplicates.value) {
        // Query all book data
        final existingBookDataList =
            await appDatabase.select(appDatabase.bookTable).get();

        // Remove the existing book data from the list
        bookDataList.removeWhere((book) => existingBookDataList
            .any((existingBook) => existingBook.id == book.id));
      }

      // Insert the book data into the database
      await appDatabase.batch((batch) {
        batch.insertAll(appDatabase.bookTable, bookDataList);
      });
      _importBookDataState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      _importBookDataState.value = Error(e.toString());
    }
  }

  Future<void> exportBookData() async {
    try {
      _exportBookDataState.value = Loading();
      // Query all book data
      final bookDataList =
          await appDatabase.select(appDatabase.bookTable).get();

      // Convert the data to JSON format
      final jsonData = jsonEncode(bookDataList.map((book) {
        final newBook = book.copyWith(readCount: 0, localPaths: [], isDownload: false);
        return newBook.toJson();
      }).toList());

      final exportFileName =
          'book-data-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.json';

      if (GetPlatform.isMobile) {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: '请选择保存文件地址',
          fileName: exportFileName,
          bytes: utf8.encode(jsonData),
        );
        if (outputFile == null) {
          return;
        }
      }

      if (GetPlatform.isDesktop) {
        final outputDirectory = await FilePicker.platform.getDirectoryPath();
        if (outputDirectory == null) {
          return;
        }
        final file = File("$outputDirectory/$exportFileName");
        await file.writeAsString(jsonData);
      }

      _exportBookDataState.value = Success(exportFileName);
    } catch (e) {
      debugPrint(e.toString());
      _exportBookDataState.value = Error(e.toString());
    }
  }

  void onSkipDuplicatesChanged(bool value) {
    _skipDuplicates.value = value;
  }
}
