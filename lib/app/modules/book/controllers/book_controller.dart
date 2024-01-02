import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:get/get.dart';
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

 Future<Uint8List> getPreview(String filePath) async{
    final file = await sftp.open(filePath);
    final content = await file.readBytes();
    update();
    return content;
  }



  getBookPageList(String filePath) async {
    bookPageList.value = [];
    final pathList = await client.run("ls \"$filePath\"");
    var lines = utf8.decode(pathList).split("\n");
    print(lines);
    for (String line in lines) {
      if (line.contains(".jpg")) {
        bookPageList.add("$filePath$line");
      }
    }
    print(bookPageList);
    update();
  }

  Future<Uint8List> getCurrentBookPage(String filePath) async {
    final file = await sftp.open(filePath);
    final content = await file.readBytes();
    update();
    return content;
  }

  extractLastFolderName(String filePath) {
    var pathString = filePath.substring(0, filePath.lastIndexOf("/"));
    return pathString.substring(pathString.lastIndexOf("/") + 1);
  }
}
