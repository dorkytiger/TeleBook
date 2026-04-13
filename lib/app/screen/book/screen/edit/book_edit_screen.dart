import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/book/screen/edit/book_edit_controller.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class BookEditScreen extends GetView<BookEditController> {
  const BookEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑书籍'),
        actions: [
          IconButton(
            onPressed: () {
              controller.saveChanges();
            },
            icon: Icon(Icons.save),
            tooltip: '保存',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: controller.bookName,
              decoration: InputDecoration(
                labelText: "书籍名称",
                fillColor: Colors.transparent,
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // 可拖拽的网格列表
          Expanded(child: ReorderableGridView(controller: controller)),
        ],
      ),
    );
  }
}

/// 可拖拽排序的网格视图
class ReorderableGridView extends StatelessWidget {
  final BookEditController controller;

  const ReorderableGridView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.imageList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                '暂无图片',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        );
      }

      return ReorderableListView.builder(
        itemCount: controller.imageList.length,
        onReorder: controller.reorderImages,
        padding: EdgeInsets.all(16),
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
          return Column(
            key: ValueKey(imagePath),
            mainAxisSize: MainAxisSize.min, // ← 加这个
            children: [
              ListTile(
                // ← 直接放 ListTile，不套 Expanded
                leading: CustomImageLoader(localUrl: fullPath),
                title: Text("第 ${index + 1} 页", style: TextStyle(fontSize: 14)),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                  onPressed: () => _showDeleteConfirm(context, index),
                ),
              ),
              SizedBox(height: 16),
            ],
          );
        },
      );
    });
  }

  void _showDeleteConfirm(BuildContext context, int index) {
    Get.dialog(
      AlertDialog(
        title: Text('确认删除'),
        content: Text('确定要删除第 ${index + 1} 页吗？'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('取消')),
          TextButton(
            onPressed: () {
              controller.deleteImage(index);
              Get.back();
            },
            child: Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
