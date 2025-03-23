import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingExportController extends GetxController {
  final appDatabase = Get.find<AppDatabase>();

  final getDownloadBookState = Rx<RequestState<List<BookTableData>>>(Idle());
  final exportBookList = Rx<Map<String, ExportBook>>({});

  final selectedExportIds = Rx<List<String>>([]);

  final exportBookState = Rx<RequestState<void>>(Idle());

  @override
  void onInit() {
    super.onInit();
    getDownloadBook();
    ever(exportBookState, (state){
      if(state.isSuccess()){
        Get.showSnackbar(const GetSnackBar(
          title: "导出成功",
          message: "导出成功",
          duration: Duration(seconds: 3),
        ));
        return;
      }
      if(state.isError()){
        Get.showSnackbar(GetSnackBar(
          title: "导出失败",
          message: state.getErrorMessage(),
          duration: const Duration(seconds: 3),
        ));
        return;
      }
    });
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
      final serverBookList = await _getServerBookList();
      for (var book in downloadBookList) {
        final isExport = serverBookList.contains(book.name);
        exportBookList.value[book.id.toString()] = ExportBook(book, isExport,
            ExportBookStatus.idle, 0, book.localPaths.length, "");
      }
      getDownloadBookState.value = Success(downloadBookList);
    } catch (e) {
      debugPrint(e.toString());
      getDownloadBookState.value = Error(e.toString());
    }
  }

  Future<List<String>> _getServerBookList() async {
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
    final file = await sftp.stat(setting.imagePath);
    if (!file.isDirectory) {
      throw Exception("数据目录不是文件夹");
    }
    final serverBookList = await sftp.listdir(setting.imagePath);
    sftp.close();
    client.close();
    return serverBookList.map((e) => e.filename).toList();
  }

  void setSelectedExportIds(List<String> ids) {
    selectedExportIds.value = ids;
  }

  Future<void> exportBook() async {
    try {
      exportBookState.value = Loading();
      WakelockPlus.enable();
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
      for (var id in selectedExportIds.value) {
        // 设置当前状态为正在导出
        final book = exportBookList.value[id]!;
        exportBookList.value[id]!.status = ExportBookStatus.running;
        exportBookList.refresh();

        // 检查远程目录是否存在
        final remoteBookPath = "${setting.imagePath}/${book.data.name}";
        final remoteDirList = await sftp.listdir(setting.imagePath);
        if (!remoteDirList.map((e)=>e.filename).contains(book.data.name)) {
          await sftp.mkdir(remoteBookPath);
        }

        // 写入bookData为json文件
        final bookDataFile = await sftp.open(
          "$remoteBookPath/.data.json",
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write,
        );
        await bookDataFile.writeBytes(utf8.encode(jsonEncode(book.data)));

        // 获取本地目录
        final localDoc = await getApplicationDocumentsDirectory();

        // 写入图片
        for (var i = 0; i < book.data.localPaths.length; i++) {
          try{
            final localFile = File("${localDoc.path}/${book.data.localPaths[i]}");
            final subPath = "${book.data.name}/$i.jpg";
            final remoteFile = await sftp.open(
              "${setting.imagePath}/$subPath",
              mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write,
            );
            await remoteFile.write(localFile.openRead().cast());
            await remoteFile.close();
            exportBookList.value[id]!.current++;
            exportBookList.refresh();
          }catch(e){
            exportBookList.value[id]!.status = ExportBookStatus.error;
            exportBookList.value[id]!.errorMessage = e.toString();
            exportBookList.refresh();
            debugPrint(e.toString());
          }
        }
        exportBookList.value[id]!.status = ExportBookStatus.complete;
        exportBookList.refresh();
      }
      sftp.close();
      client.close();
      exportBookState.value = const Success(null);
    } catch (e) {
      debugPrint(e.toString());
      exportBookState.value = Error(e.toString());
    }
    WakelockPlus.disable();
  }
}

class ExportBook {
  BookTableData data;
  bool isExport;
  ExportBookStatus status = ExportBookStatus.idle;
  int current = 0;
  int total = 0;
  String errorMessage = "";

  ExportBook(this.data, this.isExport, this.status, this.current, this.total,
      this.errorMessage);
}

enum ExportBookStatus {
  idle,
  running,
  complete,
  error,
}
