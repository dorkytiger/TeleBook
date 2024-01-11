import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/modules/book/views/book_page.dart';
import 'package:wo_nas/app/modules/download/views/download_view.dart';

import '../controllers/book_controller.dart';

class BookView extends GetView<BookController> {
  const BookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text(
              '书库',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                  onPressed: () {
                    controller.setGridCount();
                  },
                  icon: const Icon(Icons.grid_view_rounded)),
            ],
          ),
          body: controller.bookPathList.isNotEmpty?RefreshIndicator(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: controller.gridCount.value,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    childAspectRatio:
                        controller.isShowTitle.value ? (1 / 2) : (2 / 3)),
                itemCount: controller.bookPreviewList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        await controller
                            .getBookPageList(controller.bookPathList[index]);
                        await Get.to(() => const BookPage(),
                            arguments: controller.bookNameList[index]);
                      },
                      onLongPress: () {
                        controller.toggleEditing();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white10, width: 5)),
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.file(
                                      File(controller.bookPreviewList[index]),
                                    ),
                                    if (controller.isEditing.value)
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.toggleSelection(index);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: controller.selectedItems
                                                        .contains(index)
                                                    ? Colors.blue
                                                    : Colors.white,
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (controller.isShowTitle.value)
                                Expanded(
                                    child: Text(controller.bookNameList[index]))
                            ],
                          ),
                        ),
                      ));
                },
              ),
              onRefresh: () async {
                await controller.getBookList();
              }):const Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "暂无书籍,点击右下角",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Icon(Icons.download,color: Colors.black54,),
                  Text("下载",style: TextStyle(fontSize: 18, color: Colors.grey),)
                ],
          )
          ),

          bottomNavigationBar: controller.isEditing.value
              ? BottomAppBar(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.toggleEditing(); // 退出编辑模式
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: Colors.blue,
                              ),
                              Text("取消",style: TextStyle(color: Colors.black),)
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text('确认删除'),
                                  content: const Text(
                                    '确定要删除选中的项吗？',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 关闭对话框
                                      },
                                      child: const Text('取消',style: TextStyle(color: Colors.black),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        controller
                                            .deleteSelectedItems(); // 执行删除操作
                                        Navigator.of(context).pop(); // 关闭对话框
                                      },
                                      child: const Text('确认删除',style: TextStyle(color: Colors.black),),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                              Text("删除",style: TextStyle(color: Colors.black),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ));
  }
}
