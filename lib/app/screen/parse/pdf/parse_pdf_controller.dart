import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:get/get.dart' hide Value;
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/home/home_controller.dart';
import 'package:tele_book/app/screen/task/task_controller.dart';
import 'package:tele_book/app/service/import_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ParsePdfController extends GetxController {
  final path = Get.arguments['path'] as String;
  final PdfImageConverter _converter = PdfImageConverter();
  final importService = Get.find<ImportService>();

  /// 初始化状态（打开PDF、获取页数）
  final initState = Rx<DKStateQuery<int>>(DkStateQueryIdle());
  final importState = Rx<DKStateEvent<void>>(DKStateEventIdle());

  /// 每一页的图片数据，null 表示还未渲染
  final pageImages = <Uint8List?>[].obs;

  /// 每一页是否正在渲染中
  final pageLoading = <bool>[].obs;

  /// 串行渲染队列，确保每次只有一页在渲染（Android 限制）
  Future<void> _renderQueue = Future.value();

  int get totalPages => pageImages.length;

  @override
  void onInit() {
    super.onInit();
    importState.listenEventToast();
    _openPdf();
  }

  @override
  void onClose() {
    _converter.closePdf();
    super.onClose();
  }

  Future<void> _openPdf() async {
    initState.triggerQuery(
      query: () async {
        await _converter.openPdf(path);
        final count = _converter.pageCount;
        // 初始化列表，全部置为 null（未渲染）
        pageImages.assignAll(List<Uint8List?>.filled(count, null));
        pageLoading.assignAll(List<bool>.filled(count, false));
        return count;
      },
    );
  }

  /// 渲染指定页（0-based），已渲染或正在渲染时直接返回
  /// 通过 _renderQueue 串行执行，避免 Android 并发渲染冲突
  Future<void> renderPage(int index) async {
    if (index < 0 || index >= totalPages) return;
    if (pageImages[index] != null) return;
    if (pageLoading[index]) return;

    pageLoading[index] = true;
    pageLoading.refresh();

    // 将本次渲染追加到队列末尾，保证串行
    _renderQueue = _renderQueue.then((_) => _doRender(index));
    await _renderQueue;
  }

  Future<void> _doRender(int index) async {
    // 可能在排队期间已经被渲染或释放后重新入队，再检查一次
    if (index < 0 || index >= totalPages) return;
    if (pageImages[index] != null) {
      pageLoading[index] = false;
      pageLoading.refresh();
      return;
    }
    try {
      final image = await _converter.renderPage(index);
      pageImages[index] = image;
      pageImages.refresh();
    } catch (e) {
      DKLog.e('渲染第 ${index + 1} 页失败: $e');
    } finally {
      if (index < pageLoading.length) {
        pageLoading[index] = false;
        pageLoading.refresh();
      }
    }
  }

  /// 释放指定页的内存（离屏后调用）
  void releasePage(int index) {
    if (index < 0 || index >= totalPages) return;
    if (pageImages[index] == null) return;
    pageImages[index] = null;
    pageImages.refresh();
  }

  Future<void> importPDF() async {
    await importState.triggerEvent(
      event: () async {
        // 导入时按需逐页渲染，避免全量持有
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        final name = p.basenameWithoutExtension(path);
        const type = ImportType.pdf;

        final group = ImportGroup(id: id, name: name, type: type);

        final tempDir = await getTemporaryDirectory();
        final pdfTempDir = Directory("${tempDir.path}/pdf_$id");
        if (!await pdfTempDir.exists()) {
          await pdfTempDir.create(recursive: true);
        }

        for (var i = 0; i < totalPages; i++) {
          // 按需渲染，用完立刻释放
          Uint8List? imageData = pageImages[i];
          bool rendered = false;
          if (imageData == null) {
            imageData = await _converter.renderPage(i);
            rendered = true;
          }
          if (imageData == null) continue;

          final tempFile = File("${pdfTempDir.path}/page_${i + 1}.png");
          await tempFile.writeAsBytes(imageData);

          // 如果是临时渲染的，释放掉
          if (rendered) imageData = null;

          group.tasks.add(
            ImportTask(
              id: "${id}_task_$i",
              groupId: id,
              filePath: tempFile.path,
            ),
          );
        }

        DKLog.d("创建导入组: $name, 任务数: ${group.tasks.length}");

        importService.addImportGroup(group);
        await importService.startImport(id);

        if (await pdfTempDir.exists()) {
          await pdfTempDir.delete(recursive: true);
        }

        Get.back();
        final homeController = Get.find<HomeController>();
        homeController.selectedIndex.value = 1;
        final taskController = Get.find<TaskController>();
        taskController.tabController.animateTo(1);
      },
    );
  }
}
