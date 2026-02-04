import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'parse_batch_image_folder_controller.dart';
class ParseBatchImageFolderScreen extends GetView<ParseBatchImageFolderController> {
  const ParseBatchImageFolderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "批量导入图片文件夹",
        onBack: () => Get.back(),
      ),
      body: controller.scanFoldersState.displaySuccess(
        loadingBuilder: () => Center(
          child: TDLoading(size: TDLoadingSize.large, text: "正在扫描文件夹..."),
        ),
        successBuilder: (data) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: TDTheme.of(context).brandNormalColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: TDText(
                        "找到 ${data.length} 个文件夹，共 ${data.fold<int>(0, (sum, folder) => sum + folder.images.length)} 张图片",
                        font: TDTheme.of(context).fontBodyMedium,
                        textColor: TDTheme.of(context).fontGyColor1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final folderInfo = data[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.folder, color: TDTheme.of(context).brandNormalColor),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TDText(
                                    folderInfo.folderName,
                                    font: TDTheme.of(context).fontBodyLarge,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TDTag(
                                  "${folderInfo.images.length} 张",
                                  size: TDTagSize.small,
                                  theme: TDTagTheme.primary,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: folderInfo.images.length.clamp(0, 5),
                                itemBuilder: (context, imgIndex) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Image.file(
                                      folderInfo.images[imgIndex],
                                      width: 60,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TDButton(
                  text: "批量保存到本地",
                  width: double.infinity,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () => controller.saveAllToLocal(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
