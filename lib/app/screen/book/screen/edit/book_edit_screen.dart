import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_controller.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class BookEditScreen extends GetView<BookEditController> {
  const BookEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '编辑书籍',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.check,
            iconWidget: Obx(() {
              final state = controller.saveState.value;
              return state is Loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check);
            }),
            action: () => controller.saveChanges(),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            // 书籍名称输入框
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TDInput(
                controller: controller.bookName,
                hintText: '请输入书籍名称',
                leftLabel: '书籍名称',
                backgroundColor: Colors.white,
                additionInfo: '修改书籍名称后需要点击右上角的保存按钮',
              ),
            ),

            // 工具栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Text(
                    '共 ${controller.imageList.length} 页',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  TDButton(
                    text: '添加图片',
                    size: TDButtonSize.small,
                    theme: TDButtonTheme.primary,
                    icon: Icons.add_photo_alternate,
                    onTap: () => controller.addImages(),
                  ),
                ],
              ),
            ),

            // 可拖拽的网格列表
            Expanded(child: ReorderableGridView(controller: controller)),
          ],
        );
      }),
    );
  }
}

/// 可拖拽排序的网格视图
class ReorderableGridView extends StatelessWidget {
  final BookEditController controller;

  const ReorderableGridView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.imageList.length,
      onReorder: controller.reorderImages,
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final imagePath = controller.imageList[index];
        final fullPath = '${controller.appDirectory}/$imagePath';

        return KeyedSubtree(
          key: ValueKey(imagePath),
          child: TDCell(
            title: "第 ${index + 1} 页",
            leftIconWidget: CustomImageLoader(localUrl: fullPath),
            rightIconWidget: TDButton(
              icon: Icons.delete_outline,
              theme: TDButtonTheme.danger,
              size: TDButtonSize.small,
              onTap: () => _showDeleteConfirm(context, index),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirm(BuildContext context, int index) {
    Get.dialog(
      TDAlertDialog(
        title: '确认删除',
        content: '确定要删除这张图片吗？',
        rightBtn: TDDialogButtonOptions(
          title: '删除',
          theme: TDButtonTheme.danger,
          action: () {
            Get.back();
            controller.deleteImage(index);
          },
        ),
        leftBtn: TDDialogButtonOptions(
          title: '取消',
          action: () {
            Get.back();
          },
        ),
      ),
    );
  }
}

/// 网格图片项
class GridImageItem extends StatelessWidget {
  final int index;
  final String fullPath;
  final VoidCallback onDelete;

  const GridImageItem({
    super.key,
    required this.index,
    required this.fullPath,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Stack(
        children: [
          // 图片内容
          Row(
            children: [
              // 拖拽手柄
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Icon(Icons.drag_handle, color: Colors.grey[400]),
              ),
              // 缩略图
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[200],
                ),
                clipBehavior: Clip.antiAlias,
                child: File(fullPath).existsSync()
                    ? Image.file(
                        File(fullPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // 页码信息
              Expanded(
                child: Text(
                  '第 ${index + 1} 页',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // 删除按钮
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 22,
                ),
                onPressed: onDelete,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
