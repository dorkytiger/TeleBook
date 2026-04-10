import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'mark_controller.dart';

class MarkScreen extends GetView<MarkController> {
  const MarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书签管理"),
        actions: [
          IconButton(
            onPressed: () {
              _saveMark(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(
        () => controller.markService.marks.isEmpty
            ? Center(child: CustomEmpty(message: "暂无书签，点击右上角添加"))
            : ListView.builder(
                itemCount: controller.markService.marks.length,
                itemBuilder: (context, index) {
                  final mark = controller.markService.marks[index];
                  return ListTile(
                    title: Text(mark.name),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(value: 'edit', child: Text('编辑')),
                          PopupMenuItem(value: 'delete', child: Text('删除')),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 'edit') {
                          _saveMark(
                            context,
                            initData: MarkFormData(
                              id: mark.id,
                              name: mark.name,
                              description: mark.description,
                            ),
                          );
                        } else if (value == 'delete') {
                          controller.markService.deleteMark(mark.id);
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _saveMark(BuildContext context, {MarkFormData? initData}) {
    // 重置或设置表单数据
    if (initData != null) {
      controller.markNameController.text = initData.name;
      controller.markDescriptionController.text = initData.description ?? "";
    } else {
      controller.resetMarkForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // Return a simple Material-based form so the confirm button can be
        // placed in the header (right side) and content stays non-scrollable.
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: kToolbarHeight,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            initData == null ? "添加书签" : "编辑书签",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          if (!controller.validateMarkName()) {
                            return;
                          }
                          controller.markService.saveMark(
                            id: initData?.id,
                            name: controller.markNameController.text.trim(),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),

                // content (non-scrollable)
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("标签名称"),
                        Obx(() {
                          return TextField(
                            controller: controller.markNameController,
                            decoration: InputDecoration(
                              hintText: "请输入标签名称",
                              errorText: controller.markNameError.value,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }),
                        Text("标签描述"),
                        TextField(
                          controller: controller.markDescriptionController,
                          decoration: InputDecoration(
                            hintText: "请输入标签描述",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
