import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/mark/widget/mark_edit_form_widget.dart';
import 'package:tele_book/app/widget/custom_empty.dart';
import 'package:tele_book/app/widget/custom_loading.dart';
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: 0.6,
                    expand: false,
                    builder: (context, scrollController) {
                      return MarkEditFormWidget(
                        scrollController: scrollController,
                        onConfirm: () {
                          controller.addMark();
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                        selectedColor: controller.selectedMarkColor.value,
                        markNameController: controller.markNameController,
                        onColorSelected: (color) {
                          controller.selectedMarkColor.value = color;
                        },
                      );
                    },
                  );
                },
              );
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
                    leading: CircleAvatar(backgroundColor: Color(mark.color)),
                    title: Text(mark.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.markNameController.text = mark.name;
                            controller.selectedMarkColor.value = Color(
                              mark.color,
                            );
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  initialChildSize: 0.5,
                                  minChildSize: 0.5,
                                  maxChildSize: 0.6,
                                  builder: (context, scrollController) {
                                    return MarkEditFormWidget(
                                      scrollController: scrollController,
                                      onConfirm: () {
                                        controller.updateMark(mark.id);
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                      selectedColor:
                                          controller.selectedMarkColor.value,
                                      markNameController:
                                          controller.markNameController,
                                      onColorSelected: (color) {
                                        controller.selectedMarkColor.value =
                                            color;
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "删除书签",
                              content: Text("确定要删除这个书签吗？"),
                              onConfirm: () {
                                controller.deleteMark(mark.id);
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
