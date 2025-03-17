import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/constant/host_constant.dart';
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

  final _exportHostBookDataState = Rx<RequestState<void>>(Idle());

  RequestState<void> get exportHostBookDataState =>
      _exportHostBookDataState.value;

  final _importHostBookDataState = Rx<RequestState<void>>(Idle());

  RequestState<void> get importHostBookDataState =>
      _importHostBookDataState.value;

  final _exportHostImageDataState = Rx<RequestState<void>>(Idle());

  RequestState<void> get exportHostImageDataState =>
      _exportHostImageDataState.value;

  final _importHostImageDataState = Rx<RequestState<void>>(Idle());

  RequestState<void> get importHostImageDataState =>
      _importHostImageDataState.value;

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
          message: "已写入本地数据库",
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
    ever(_exportHostBookDataState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "导出成功",
          message: _getSettingDataState.value.getSuccessData().dataPath,
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
    ever(_importHostBookDataState, (state) {
      if (state.isSuccess()) {
        bookController.getBookList();
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "导入成功",
          message: "已写入本地数据库",
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

    ever(_exportHostImageDataState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "导出成功",
          message: "已写入远程主机",
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

    ever(_importHostImageDataState, (state) {
      if (state.isSuccess()) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          title: "导入成功",
          message: "已写入本地数据库",
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
        final newBook =
            book.copyWith(readCount: 0, localPaths: [], isDownload: false);
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

  Future<void> exportHostBookData() async {
    try {
      _exportHostBookDataState.value = Loading();
      final bookDataList =
          await appDatabase.select(appDatabase.bookTable).get();

      String jsonData;
      if (bookDataList.isEmpty) {
        jsonData = "[]";
      } else {
        jsonData = jsonEncode(bookDataList.map((book) {
          final newBook =
              book.copyWith(readCount: 0, localPaths: [], isDownload: false);
          return newBook.toJson();
        }).toList());
      }
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      final socket = await SSHSocket.connect(settingData.host, settingData.port,
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: settingData.username,
        onPasswordRequest: () => settingData.password,
      );
      final sftp = await client.sftp();

      final remoteFile = await sftp.open(
        "${settingData.dataPath}/${HostConstant.dateFileName}",
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write,
      );
      await remoteFile.writeBytes(utf8.encode(jsonData));
      await remoteFile.close();
      sftp.close();
      client.close();
      await socket.close();
      _exportHostBookDataState.value = Success(null);
    } catch (e) {
      debugPrint(e.toString());
      _exportHostBookDataState.value = Error(e.toString());
    }
  }

  Future<void> importHostBookData() async {
    try {
      _importHostBookDataState.value = Loading();
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      final socket = await SSHSocket.connect(settingData.host, settingData.port,
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: settingData.username,
        onPasswordRequest: () => settingData.password,
      );
      final sftp = await client.sftp();

      final remoteFile = await sftp.open(
        "${settingData.dataPath}/${HostConstant.dateFileName}",
      );

      final byteData = await remoteFile.readBytes();

      final jsonData = utf8.decode(byteData);

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
      _importHostBookDataState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      _importHostBookDataState.value = Error(e.toString());
    }
  }

  Future<void> exportHostImageData() async {
    try {
      _exportHostImageDataState.value = Loading();
      final bookDataList =
          await appDatabase.select(appDatabase.bookTable).get();

      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      final socket = await SSHSocket.connect(settingData.host, settingData.port,
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: settingData.username,
        onPasswordRequest: () => settingData.password,
      );
      final sftp = await client.sftp();

      final remoteDirectory = await sftp.listdir(settingData.imagePath);

      final bookNames = remoteDirectory.map((e) => e.filename).toList();

      final document = await getApplicationDocumentsDirectory();

      for (final book in bookDataList) {
        if (_skipDuplicates.value && bookNames.contains(book.name)) {
          continue;
        }
        if (!book.isDownload) {
          continue;
        }

        final remoteDir = "${settingData.imagePath}/${book.name}";
        await sftp.mkdir(remoteDir);
        for (final path in book.localPaths) {
          final file = File("${document.path}/$path");
          final remoteFile = await sftp.open(
            "$remoteDir/${path.split('/').last}",
            mode: SftpFileOpenMode.create |
                SftpFileOpenMode.truncate |
                SftpFileOpenMode.write,
          );
          await remoteFile.write(file.openRead().cast());
          await remoteFile.close();
        }
      }

      sftp.close();
      client.close();
      await socket.close();
      _exportHostImageDataState.value = Success(null);
    } catch (e) {
      debugPrint(e.toString());
      _exportHostImageDataState.value = Error(e.toString());
    }
  }

  Future<void> importHostImageData() async {
    try {
      _importHostImageDataState.value = Loading();
      final bookDataList =
          await appDatabase.select(appDatabase.bookTable).get();
      final settingData =
          await appDatabase.select(appDatabase.settingTable).getSingle();
      final socket = await SSHSocket.connect(settingData.host, settingData.port,
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: settingData.username,
        onPasswordRequest: () => settingData.password,
      );
      final sftp = await client.sftp();

      final remoteDirectory = await sftp.listdir(settingData.imagePath);

      final bookNames = remoteDirectory.map((e) => e.filename).toList();

      final document = await getApplicationDocumentsDirectory();

      for (final book in bookDataList) {
        if (book.isDownload) {
          continue;
        }

        if (!bookNames.contains(book.name)) {
          continue;
        }

        final remoteDirPath = "${settingData.imagePath}/${book.name}";
        List<SftpName> remoteFiles = await sftp.listdir(remoteDirPath);

        List<String> localPaths = [];
        for (final remoteFile in remoteFiles) {
          if (!remoteFile.filename.contains(".jpg")) {
            continue;
          }

          final localDirectory =
              Directory("${document.path}/${book.id}-${book.name}");
          if (!await localDirectory.exists()) {
            await localDirectory.create();
          }
          final localFilePath = "${localDirectory.path}/${remoteFile.filename}";
          localPaths.add("${book.id}-${book.name}/${remoteFile.filename}");
          final localFile = File(localFilePath);
          final openRemoteFile = await sftp.open(
            "$remoteDirPath/${remoteFile.filename}",
          );
          await localFile.writeAsBytes(await openRemoteFile.readBytes());
          await openRemoteFile.close();
        }
        localPaths.sort((a, b) {
          final na = int.parse((a.split('/').last).split(".").first);
          final nb = int.parse((b.split('/').last).split(".").first);
          return na.compareTo(nb);
        });
        appDatabase
            .update(appDatabase.bookTable)
            .replace(book.copyWith(isDownload: true, localPaths: localPaths));
      }

      sftp.close();
      client.close();
      await socket.close();
      _importHostImageDataState.value = Success(null);
      Get.find<BookController>().getBookList();
    } catch (e) {
      debugPrint(e.toString());
      _importHostImageDataState.value = Error(e.toString());
    }
  }

  void onSkipDuplicatesChanged(bool value) {
    _skipDuplicates.value = value;
  }
}

class ExportHostImageDataState {
  int total;
  int current;

  ExportHostImageDataState({required this.total, required this.current});
}
