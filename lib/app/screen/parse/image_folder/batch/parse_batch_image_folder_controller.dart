import 'dart:io';
import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
class ParseBatchImageFolderController extends GetxController {
  final parentFolderPath = Get.arguments as String;
  final imageFolders = <ImageFolderInfo>[].obs;
  final scanFoldersState = Rx<DKStateQuery<List<ImageFolderInfo>>>(DkStateQueryIdle());
  final saveToLocalState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final appDatabase = Get.find<AppDatabase>();
  static const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
  @override
  void onInit() {
    super.onInit();
    scanImageFolders();
    saveToLocalState.listenEventToast(onSuccess: (_) {
      Get.find<BookController>().fetchBooks();
      Get.back();
    });
  }
  Future<void> scanImageFolders() async {
    scanFoldersState.triggerQuery(query: () async {
      final parentFolder = Directory(parentFolderPath);
      if (!await parentFolder.exists()) throw Exception("文件夹不存在");
      final folders = <ImageFolderInfo>[];
      await for (final entity in parentFolder.list()) {
        if (entity is Directory) {
          final images = <File>[];
          await for (final file in entity.list()) {
            if (file is File && imageExtensions.contains(p.extension(file.path).toLowerCase())) {
              images.add(file);
            }
          }
          if (images.isNotEmpty) {
            images.sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));
            folders.add(ImageFolderInfo(folderPath: entity.path, folderName: p.basename(entity.path), images: images));
          }
        }
      }
      if (folders.isEmpty) throw Exception("没有找到包含图片的文件夹");
      folders.sort((a, b) => a.folderName.compareTo(b.folderName));
      imageFolders.value = folders;
      return folders;
    });
  }
  Future<void> saveAllToLocal() async {
    saveToLocalState.triggerEvent(event: () async {
      if (imageFolders.isEmpty) throw Exception("没有可保存的文件夹");
      final appDocDir = await getApplicationDocumentsDirectory();
      int successCount = 0;
      for (final folderInfo in imageFolders) {
        try {
          final groupPath = "${folderInfo.folderName}-${DateTime.now().microsecondsSinceEpoch}";
          final saveDir = p.join(appDocDir.path, groupPath);
          final localPaths = <String>[];
          int index = 1;
          for (final imageFile in folderInfo.images) {
            final ext = p.extension(imageFile.path);
            final fileName = "${index.toString().padLeft(8, '0')}$ext";
            final savePath = p.join(saveDir, fileName);
            final file = File(savePath);
            await file.parent.create(recursive: true);
            await imageFile.copy(savePath);
            localPaths.add(p.join(groupPath, fileName));
            index++;
          }
          if (localPaths.isNotEmpty) {
            await appDatabase.bookTable.insertOnConflictUpdate(
              BookTableCompanion(
                name: Value(folderInfo.folderName),
                localPaths: Value(localPaths),
                currentPage: Value(0),
              )
            );
            successCount++;
          }
        } catch (e) {
          DKLog.e('保存文件夹 ${folderInfo.folderName} 失败: $e');
        }
      }
      if (successCount == 0) throw Exception('没有成功保存任何书籍');
    });
  }
}
class ImageFolderInfo {
  final String folderPath;
  final String folderName;
  final List<File> images;
  ImageFolderInfo({required this.folderPath, required this.folderName, required this.images});
}
