import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/enum/reading_direction_enum.dart';
import 'package:tele_book/app/screen/book/screen/page/book_page_controller.dart';

class BookPageScreen extends StatelessWidget {
  final int bookId;

  const BookPageScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          BookPageController(
            bookId: bookId,
            bookStore: context.read(),
            sharedPreferences: context.read(),
          ),
      child: const _BookPageScreenContent(),
    );
  }
}

class _BookPageScreenContent extends StatelessWidget {
  const _BookPageScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookPageController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              '${controller.currentPage + 1} / ${controller.totalPages}',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => _showReadingSettings(context),
              ),
            ],
          ),
          body: controller.totalPages == 0 || controller.bookData == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
            children: [
              controller.readingDirection == ReadingDirection.topToBottom
                  ? SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: List.generate(controller.totalPages, (index) {
                    return GestureDetector(
                      onTap: controller.toggleProgress,
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: _buildPageImage(
                          context,
                          controller,
                          index,
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                      ),
                    );
                  }),
                ),
              )
                  : PageView.builder(
                controller: controller.pageController,
                scrollDirection: Axis.horizontal,
                reverse: controller.readingDirection == ReadingDirection.rightToLeft,
                itemCount: controller.totalPages,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: controller.toggleProgress,
                    child: Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: _buildPageImage(
                          context,
                          controller,
                          index,
                          fit: BoxFit.contain,
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
                  opacity: controller.showProgress ? 1.0 : 0.0,
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
                        if (controller.readingDirection ==
                            ReadingDirection.topToBottom)
                        // 上下阅读模式：显示滚动进度
                          Row(
                            children: [
                              Text(
                                '${((controller.currentPage + 1) /
                                    controller.totalPages * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value:
                                  (controller.currentPage + 1) /
                                      controller.totalPages,
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.totalPages}页',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        else
                        // 左右阅读模式：显示页面进度
                          Row(
                            children: [
                              Text(
                                '${controller.currentPage + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape:
                                    const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                    ),
                                    overlayShape:
                                    const RoundSliderOverlayShape(
                                      overlayRadius: 12,
                                    ),
                                  ),
                                  child: Slider(
                                    value: controller.currentPage
                                        .toDouble(),
                                    min: 0,
                                    max: (controller.totalPages - 1)
                                        .toDouble(),
                                    divisions: controller.totalPages > 1
                                        ? controller.totalPages - 1
                                        : 1,
                                    inactiveColor: Colors.white24,
                                    onChanged: (value) {
                                      controller.jumpToPage(
                                        value.toInt(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.totalPages}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        // 书籍信息
                        if (controller.bookData != null)
                          Text(
                            controller.bookData!.name,
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
          ),
        );
      },
    );
  }

  Widget _buildPageImage(
    BuildContext context,
    BookPageController controller,
    int index, {
    required BoxFit fit,
    double? width,
  }) {
    if (index >= controller.fullImagePaths.length) {
      return const AspectRatio(
        aspectRatio: 0.7,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final screenW = MediaQuery.sizeOf(context).width;
    final cacheW = (screenW * dpr).toInt();
    return Image.file(
      File(controller.fullImagePaths[index]),
      width: width,
      fit: fit,
      cacheWidth: cacheW,
    );
  }

  /// 显示阅读设置对话框
  void _showReadingSettings(BuildContext context) {
    final controller = context.read<BookPageController>();
    showGeneralDialog(
      context: context,
      pageBuilder: (context, ts, tx) {
        return ChangeNotifierProvider.value(
          value: controller,
          child: Consumer<BookPageController>(
            builder: (context, ctrl, _) => AlertDialog(
              title: const Text('阅读设置'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('选择阅读方向：'),
                  const SizedBox(height: 16),
                  RadioGroup<ReadingDirection>(
                    onChanged: (value) {
                      if (value != null) {
                        ctrl.saveReadingDirection(value);
                      }
                    },
                    groupValue: ctrl.readingDirection,
                    child: Column(
                      children: [
                        RadioListTile(
                          value: ReadingDirection.leftToRight,
                          selected: ctrl.readingDirection == ReadingDirection.leftToRight,
                          title: const Text('左右阅读'),
                        ),
                        RadioListTile(
                          value: ReadingDirection.topToBottom,
                          selected: ctrl.readingDirection == ReadingDirection.topToBottom,
                          title: const Text('上下阅读'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
