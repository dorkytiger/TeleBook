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

class ParseImageFolderController extends GetxController {
  final folderPath = Get.arguments as String;
  final images = <File>[].obs;
  final scanImageState = Rx<DKStateQuery<List<File>>>(DkStateQueryIdle());
  final saveToLocalState = Rx<DKStateEvent<void>>(DKStateEventIdle());

  // database reference
  final appDatabase = Get.find<AppDatabase>();

  // 支持的图片格式
  static const imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp'
  ];

  @override
  void onInit() {
    super.onInit();
    scanImages();
    saveToLocalState.listenEventToast(
      onSuccess: (_) {
        final booksController = Get.find<BookController>();
        booksController.fetchBooks();
        Get.back();
      },
    );
  }

  Future<void> scanImages() async {
    scanImageState.triggerQuery(
      query: () async {
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          throw Exception("文件夹不存在");
        }

        final files = <File>[];
        await for (final entity in folder.list()) {
          if (entity is File) {
            final ext = p.extension(entity.path).toLowerCase();
            if (imageExtensions.contains(ext)) {
              files.add(entity);
            }
          }
        }

        if (files.isEmpty) {
          throw Exception("文件夹中没有找到图片文件");
        }

        // 按文件名排序
        files.sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));
        images.value = files;
        return files;
      },
    );
  }

  Future<void> saveImagesToLocal() async {
    saveToLocalState.triggerEvent(
      event: () async {
        if (images.isEmpty) {
          throw Exception("没有可保存的图片");
        }

        final title = p.basename(folderPath);
        final groupPath = "$title-${DateTime.now().microsecondsSinceEpoch}";
        final appDocDir = await getApplicationDocumentsDirectory();
        final saveDir = p.join(appDocDir.path, groupPath);

        final localPaths = <String>[];
        int index = 1;

        for (final imageFile in images) {
          // 文件名格式：00000001.jpg
          final ext = p.extension(imageFile.path);
          final fileName = "${index.toString().padLeft(8, '0')}$ext";
          final savePath = p.join(saveDir, fileName);

          final file = File(savePath);
          await file.parent.create(recursive: true);
          await imageFile.copy(savePath);

          localPaths.add(p.join(groupPath, fileName));
          index++;
        }

        if (localPaths.isEmpty) {
          throw Exception('没有可保存的有效图片');
        }

        await appDatabase.bookTable.insertOnConflictUpdate(
          BookTableCompanion(
            name: Value(title),
            localPaths: Value(localPaths),
          ),
        );
      },
    );
  }
}
