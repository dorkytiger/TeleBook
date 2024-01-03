import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookController extends GetxController {
  RxList<String> bookPreviewList = <String>[].obs;
  RxList<String> bookPathList = <String>[].obs;
  RxList<String> bookNameList = <String>[].obs;
  RxList<String> bookPageList = <String>[].obs;
  late SSHClient client;
  late SharedPreferences sharedPreferences;
  late SftpClient sftp;

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    client = SSHClient(
        await SSHSocket.connect(sharedPreferences.getString('host') ?? "",
            int.parse(sharedPreferences.getString('port') ?? "")),
        username: sharedPreferences.getString('user') ?? "",
        onPasswordRequest: () => sharedPreferences.getString("pass"));
    getBookList();
    sftp = await client.sftp();
    super.onInit();
  }

  getBookList() async {
    await checkSSH();
    final pathList =
        await client.run("ls ${sharedPreferences.getString('book')} -R");
    var pathString = utf8.decode(pathList).trim();

    List<String> lines = pathString.split("\n");
    String currentDirectory = "";
    bookPreviewList.value = [];
    bookNameList.value = [];
    for (String line in lines) {
      if (line.endsWith(":")) {
        currentDirectory = line.substring(0, line.length - 1);
      } else if (line.isNotEmpty && currentDirectory.isNotEmpty) {
        if (line.contains(".jpg")) {
          var bookPreviewPath = "$currentDirectory/$line";
          bookNameList.add(extractLastFolderName(bookPreviewPath));
          bookPathList.add(bookPreviewPath.substring(
              0, bookPreviewPath.lastIndexOf("/") + 1));
          bookPreviewList.add(bookPreviewPath);
          currentDirectory = "";
        }
      }
    }
    update();
  }

  Future<Uint8List> getPreview(String filePath) async {
    await checkSSH();
    try {
      final tmpDirectory = await getApplicationCacheDirectory();
      final tmpFile =
          File("${tmpDirectory.path}/${filePath.replaceAll("/", "")}");
      if (tmpFile.existsSync()) {
        return await tmpFile.readAsBytes();
      }
      final file = await sftp.open(filePath);
      final content = await file.readBytes();
      tmpFile.writeAsBytesSync(content);
      return content;
    } catch (e) {
      print("Error in getPreview: $e");
      // Handle the error or rethrow it as needed
      rethrow;
    }
  }

  getBookPageList(String filePath) async {
    await checkSSH();
    bookPageList.value = [];
    final pathList = await client.run("ls \"$filePath\"");
    var lines = utf8.decode(pathList).split("\n");

    for (String line in lines) {
      if (line.contains(".jpg")) {
        bookPageList.add("$filePath$line");
      }
    }
    print(bookPageList.length);
    update();
  }

  Future<Uint8List> getCurrentBookPage(String filePath,String bookName) async {
    await checkSSH();
    try {

      final tmp = await getApplicationCacheDirectory();
      final tmpDirectory=Directory("${tmp.path}/$bookName");
      if(!tmpDirectory.existsSync()){
        tmpDirectory.create();
      }
      final tmpFile = File(
          "${tmp.path}/$bookName/${filePath.replaceAll("/", "")}");
      if (tmpFile.existsSync()) {
        print(bookPageList.length);
        return await tmpFile.readAsBytes();
      }
      final file = await sftp.open(filePath);
      final content = await file.readBytes();
      tmpFile.writeAsBytesSync(content);
      update();
      print(bookPageList.length);
      return content;
    } catch (e) {
      print("Error in getPreview: $e");
      // Handle the error or rethrow it as needed
      rethrow;
    }
  }

  extractLastFolderName(String filePath) {
    var pathString = filePath.substring(0, filePath.lastIndexOf("/"));
    return pathString.substring(pathString.lastIndexOf("/") + 1);
  }

  checkSSH() async {
    if (client.isClosed) {
      client = SSHClient(
          await SSHSocket.connect(sharedPreferences.getString('host') ?? "",
              int.parse(sharedPreferences.getString('port') ?? "")),
          username: sharedPreferences.getString('user') ?? "",
          onPasswordRequest: () => sharedPreferences.getString("pass"));
    }
    sftp = await client.sftp();
  }
}
