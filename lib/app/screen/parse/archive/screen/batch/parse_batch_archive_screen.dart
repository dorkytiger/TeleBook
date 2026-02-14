import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/parse/archive/screen/batch/parse_batch_archive_controller.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class ParseBatchArchiveScreen extends GetView<ParseBatchArchiveController> {
  const ParseBatchArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("批量导入压缩包"),
        onBack: () {
          Get.back();
        },
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.check,
            action: () {
              controller.saveAllBooks();
            },
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.extractArchivesState.value;
        if (state.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                TDText('解压失败: ${state.toString()}'),
                const SizedBox(height: 16),
                TDButton(text: '返回', onTap: () => Get.back()),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TDText(
                    '共找到 ${controller.archiveFolders.length} 个压缩包',
                    font: TDTheme.of(context).fontBodyLarge,
                    fontWeight: FontWeight.bold,
                  ),

                  if (state.isLoading) ...[
                    const SizedBox(height: 8),
                    TDProgress(
                      type: TDProgressType.linear,
                      value:
                          (controller.extractArchiveProgress.value /
                          controller.extractArchiveTotal.value),
                    ),
                    const SizedBox(height: 8),
                    TDText(
                      '正在解压压缩包...',
                      font: TDTheme.of(context).fontBodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.archiveFolders.length,
                itemBuilder: (context, index) {
                  final archiveFolder = controller.archiveFolders[index];
                  return _buildArchiveItem(context, archiveFolder, index);
                },
              ),
            ),
            Obx(() {
              final saveState = controller.saveAllBooksState.value;
              if (saveState.isLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TDLoading(
                        size: TDLoadingSize.small,
                        icon: TDLoadingIcon.circle,
                      ),
                      SizedBox(width: 8),
                      TDText('正在保存书籍...'),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }

  Widget _buildArchiveItem(
    BuildContext context,
    ArchiveFolder archiveFolder,
    int index,
  ) {
    return TDCell(
      title: archiveFolder.title,
      leftIconWidget: CustomImageLoader(
        localUrl:
            archiveFolder.files.firstOrNull?.path ??
            '${controller.appDirectory}/${archiveFolder.files.first.path}',
      ),
      arrow: true,
      onClick: (cell) {
        controller.editArchiveFolder(index);
      },
      description: '${archiveFolder.files.length} 个文件',
    );
  }
}
