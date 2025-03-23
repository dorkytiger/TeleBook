import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/view/book/book_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingImportController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final getImportBookListState = Rx<RequestState<void>>(Idle());

  final importBookMap = Rx<Map<String, ImportBook>>({});

  final selectImportBookIds = Rx<List<String>>([]);

  final importBookState = Rx<RequestState<void>>(Idle());

  @override
  void onInit() {
    super.onInit();
    getImportBookList();
    ever(importBookState, (state){
      if(state.isSuccess()){
        Get.showSnackbar(const GetSnackBar(
          title: "导入成功",
          message: "导入成功",
          duration: Duration(seconds: 3),
        ));
        return;
      }
      if(state.isError()){
        Get.showSnackbar(GetSnackBar(
          title: "导入失败",
          message: state.getErrorMessage(),
          duration: const Duration(seconds: 3),
        ));
        return;
      }
    });
  }

  Future<void> getImportBookList() async {
    try {
      getImportBookListState.value = Loading();
      final bookList = await appDatabase.select(appDatabase.bookTable).get();
      final setting =
          await appDatabase.select(appDatabase.settingTable).getSingle();

      final socket = await SSHSocket.connect(setting.host, setting.port,
          timeout: const Duration(seconds: 5));
      final client = SSHClient(
        socket,
        username: setting.username,
        onPasswordRequest: () => setting.password,
      );

      final sftp = await client.sftp();

      final remoteBookList = (await sftp.listdir(setting.imagePath))
          .map((e) => e.filename)
          .where((filename) =>
              filename != '.' && filename != '..' && filename != '.DS_Store');

      for (var book in remoteBookList) {
        final isImport = bookList.any((e) => e.name == book && e.isDownload);
        final total = (await sftp.listdir("${setting.imagePath}/$book"))
            .where((sftpFile) => sftpFile.filename.endsWith(".jpg"))
            .length;
        importBookMap.value[book] =
            ImportBook(book, isImport, ImportBookStatus.idle, 0, total, "");
      }
      sftp.close();
      client.close();
      if (importBookMap.value.isEmpty) {
        getImportBookListState.value = Empty();
        return;
      }
      getImportBookListState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      getImportBookListState.value = Error(e.toString());
    }
  }

  Future<void> importBook() async {
    try {
      importBookState.value = Loading();
      WakelockPlus.enable();
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
      final localDoc = await getApplicationDocumentsDirectory();

      for (var id in selectImportBookIds.value) {
        try {
          importBookMap.value[id]!.status = ImportBookStatus.running;
          importBookMap.refresh();
          final remoteDir = "${settingData.imagePath}/$id";
          final localDir = "${localDoc.path}/$id";
          if (!await Directory(localDir).exists()) {
            await Directory(localDir).create(recursive: true);
          }

          final remoteImages = (await sftp.listdir(remoteDir))
              .map((e) => e.filename)
              .where((filename) => filename.endsWith(".jpg"));

          for (var remoteImage in remoteImages) {
            final remoteFile = await sftp.open("$remoteDir/$remoteImage",
                mode: SftpFileOpenMode.read);
            final localFile = File("$localDir/$remoteImage");
            await localFile.writeAsBytes(await remoteFile.readBytes());
            importBookMap.value[id]!.current++;
            importBookMap.refresh();
          }

          // 读取json
          final remoteFile = await sftp.open("$remoteDir/.data.json",
              mode: SftpFileOpenMode.read);
          final byteData = await remoteFile.readBytes();
          final jsonString = utf8.decode(byteData);
          final jsonData = jsonDecode(jsonString);
          final bookTableData = BookTableData.fromJson(jsonData);

          final bookData = await (appDatabase.select(appDatabase.bookTable)
                ..where((t) => t.name.equals(id)))
              .getSingleOrNull();

          if (bookData == null) {
            await appDatabase.into(appDatabase.bookTable).insert(
                BookTableCompanion.insert(
                    name: bookTableData.name,
                    baseUrl: bookTableData.baseUrl,
                    localPaths: bookTableData.localPaths,
                    imageUrls: bookTableData.imageUrls,
                    createTime: bookTableData.createTime));
          } else {
            await appDatabase.update(appDatabase.bookTable).replace(bookData
                .copyWith(isDownload: true, localPaths: bookData.localPaths));
          }
          Get.find<BookController>().getBookList();

          importBookMap.value[id]!.status = ImportBookStatus.complete;
          importBookMap.refresh();
        } catch (e) {
          debugPrint(e.toString());
          importBookMap.value[id]!.status = ImportBookStatus.error;
          importBookMap.value[id]!.errorMessage = e.toString();
        }
      }
      importBookState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      importBookState.value = Error(e.toString());
    }
    WakelockPlus.disable();
  }

  void setImportBookIds(List<String> ids) {
    selectImportBookIds.value = ids;
  }
}

class ImportBook {
  String name;
  bool isImport;
  ImportBookStatus status = ImportBookStatus.idle;
  int current = 0;
  int total = 0;
  String errorMessage = "";

  ImportBook(this.name, this.isImport, this.status, this.current, this.total,
      this.errorMessage);
}

enum ImportBookStatus {
  idle,
  running,
  complete,
  error,
}
