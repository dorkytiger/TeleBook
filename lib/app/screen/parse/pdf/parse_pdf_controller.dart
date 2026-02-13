import 'dart:typed_data';
import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:get/get.dart' hide Value;
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:tele_book/app/service/import_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ParsePdfController extends GetxController {
  final path = Get.arguments['path'] as String;
  final PdfImageConverter _converter = PdfImageConverter();
  final images = Rxn<List<Uint8List?>>();
  final renderPageState = Rx<DKStateQuery<List<Uint8List?>>>(
    DkStateQueryIdle(),
  );
  final importService = Get.find<ImportService>();

  @override
  void onInit() {
    super.onInit();
    renderPDF();
  }

  Future<void> renderPDF() async {
    renderPageState.triggerQuery(
      query: () async {
        await _converter.openPdf(path);
        return images.value = await _converter.renderAllPages();
      },
    );
  }

  Future<void> importPDF() async {
    if (images.value == null || images.value!.isEmpty) {
      DKLog.e("没有可导入的图片");
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final name = p.basenameWithoutExtension(path);
    final type = ImportType.pdf;

    // 创建导入组
    final group = ImportGroup(id: id, name: name, type: type);

    // 获取临时目录
    final tempDir = await getTemporaryDirectory();
    final pdfTempDir = Directory("${tempDir.path}/pdf_$id");
    if (!await pdfTempDir.exists()) {
      await pdfTempDir.create(recursive: true);
    }

    // 为每一页创建任务
    for (var i = 0; i < images.value!.length; i++) {
      final imageData = images.value![i];
      if (imageData == null) continue;

      // 将图片数据保存到临时文件
      final tempFile = File("${pdfTempDir.path}/page_${i + 1}.png");
      await tempFile.writeAsBytes(imageData);

      // 创建任务
      final taskId = "${id}_task_$i";
      final task = ImportTask(
        id: taskId,
        groupId: id,
        filePath: tempFile.path,
      );

      group.tasks.add(task);
    }

    DKLog.d("创建导入组: $name, 任务数: ${group.tasks.length}");

    // 添加到导入服务并开始导入
    importService.addImportGroup(group);
    await importService.startImport(id);

    // 导入完成后清理临时目录
    if (await pdfTempDir.exists()) {
      await pdfTempDir.delete(recursive: true);
    }
  }
}
