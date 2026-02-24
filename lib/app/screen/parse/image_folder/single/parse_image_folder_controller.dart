import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:get/get.dart' hide Value;
import 'package:path/path.dart' as p;
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/book/book_controller.dart';
import 'package:tele_book/app/service/import_service.dart';

class ParseImageFolderController extends GetxController {
  final folderPath = Get.arguments as String;
  final images = <File>[].obs;
  final scanImageState = Rx<DKStateQuery<List<File>>>(DkStateQueryIdle());
  final saveToLocalState = Rx<DKStateEvent<void>>(DKStateEventIdle());

  final importService = Get.find<ImportService>();

  // 支持的图片格式
  static const imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
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
    await saveToLocalState.triggerEvent(
      event: () async {
        if (images.isEmpty) {
          throw Exception("没有可保存的图片");
        }

        final title = p.basename(folderPath);

        // 构建 ImportGroup，直接用原始 File 列表
        final group = await importService.buildImportGroup(
          name: title,
          type: ImportType.folder,
          files: images,
        );

        importService.addImportGroup(group);
        await importService.startImport(group.id);

        if (group.status.value == ImportStatus.failed) {
          throw Exception("导入失败");
        }
      },
    );
  }
}
