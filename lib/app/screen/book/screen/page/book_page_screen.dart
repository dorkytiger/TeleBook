import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_controller.dart';

class BookPageScreen extends GetView<BookPageController> {
  const BookPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
              '${controller.currentPage.value + 1} / ${controller.totalPages.value}',
              style: const TextStyle(color: Colors.white),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: controller.toggleProgress,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.totalPages.value == 0) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          children: [
            // 图片浏览器 - 支持左右滑动
            PageView.builder(
              controller: controller.pageController,
              itemCount: controller.totalPages.value,
              itemBuilder: (context, index) {
                final imagePath =
                    '${controller.appDirectory}/${controller.bookData.localPaths[index]}';
                return GestureDetector(
                  onTap: controller.toggleProgress,
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.broken_image,
                                  size: 64,
                                  color: Colors.white54,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '图片加载失败',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  imagePath,
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            // 底部进度条
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: controller.showProgress.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 进度条
                      Row(
                        children: [
                          Text(
                            '${controller.currentPage.value + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Obx(() => SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                    ),
                                    overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 12,
                                    ),
                                  ),
                                  child: Slider(
                                    value: controller.currentPage.value
                                        .toDouble(),
                                    min: 0,
                                    max: (controller.totalPages.value - 1)
                                        .toDouble(),
                                    divisions: controller.totalPages.value > 1
                                        ? controller.totalPages.value - 1
                                        : 1,
                                    activeColor: TDTheme.of(context).brandColor7,
                                    inactiveColor: Colors.white24,
                                    onChanged: (value) {
                                      controller.jumpToPage(value.toInt());
                                    },
                                  ),
                                )),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${controller.totalPages.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 书籍信息
                      Text(
                        controller.bookData.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

