import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/modules/book/views/book_page.dart';

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
              PopupMenuButton<String>(
                offset: const Offset(0, 55),
                icon: const Icon(Icons.add,size: 35,),
                onSelected: (String result) {
                  // Handle the selection from the popup menu
                  print('Selected: $result');
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: '1',
                    child: TextButton(
                      onPressed: () {
                        controller.toggleEditing();
                      },
                      child: const Text("编辑书库",style: TextStyle(color: Colors.black54,fontSize: 15),),
                    )
                  ),
                  PopupMenuItem<String>(
                    value: '2',
                    child: TextButton(
                      onPressed: () {
                        controller.setGridCount();
                      },
                      child: Obx(()=>Text(controller.isTwice.value?"双行显示":"三行显示",style: const TextStyle(color: Colors.black54,fontSize: 15),)),
                    )
                  ),
                  // PopupMenuItem<String>(
                  //   value: 'option3',
                  //   child:TextButton(
                  //     onPressed: () {  },
                  //     child: const Text("搜素",style: TextStyle(color: Colors.black54,fontSize: 15),),
                  //   )
                  // ),
                ],
              ),
            ],
          ),
          body: RefreshIndicator(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: controller.gridCount.value,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    childAspectRatio:
                        controller.isShowTitle.value ? (1 / 2) : (2 / 3)),
                itemCount: controller.bookPreviewList.length,
                itemBuilder: (BuildContext context, int index) {
                  return controller.bookPathList.isNotEmpty
                      ? GestureDetector(
                          onTap: () async {
                            await controller.getBookPageList(
                                controller.bookPathList[index]);
                            await Get.to(() => const BookPage(),
                                arguments: controller.bookNameList[index]);
                          },
                          onLongPress: () {
                            controller.toggleEditing();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white10, width: 5)),
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Image.file(
                                          File(controller
                                              .bookPreviewList[index]),
                                        ),
                                        if (controller.isEditing.value)
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .toggleSelection(index);
                                                  print(
                                                      controller.selectedItems);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: controller
                                                            .selectedItems
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
                                        child: Text(
                                            controller.bookNameList[index]))
                                ],
                              ),
                            ),
                          ))
                      : const Center(
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "暂无书籍,点击右下角",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Icon(
                              Icons.download,
                              color: Colors.black54,
                            ),
                            Text(
                              "下载",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ));
                },
              ),
              onRefresh: () async {
                await controller.getBookList();
              }),
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
                              Text(
                                "取消",
                                style: TextStyle(color: Colors.black54),
                              )
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
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 关闭对话框
                                      },
                                      child: const Text(
                                        '取消',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        controller.deleteSelectedItems();
                                        Navigator.of(context).pop();
                                        controller.toggleEditing();
                                        controller.getBookList();
                                        Get.forceAppUpdate();
                                      },
                                      child: const Text(
                                        '确认删除',
                                        style: TextStyle(color: Colors.black54),
                                      ),
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
                              Text(
                                "删除",
                                style: TextStyle(color: Colors.black54),
                              )
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
