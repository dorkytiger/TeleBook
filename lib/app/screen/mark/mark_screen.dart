import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/constant/mark_constant.dart';
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
                    leading: CircleAvatar(backgroundColor: Color(mark.color)),
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
                              color: mark.color,
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Scaffold(
              appBar: AppBar(
                title: Text(initData == null ? "添加书签" : "编辑书签"),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text("标签名称"),
                      TextField(
                        controller: controller.markNameController,
                        decoration: InputDecoration(
                          hintText: "请输入标签名称",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Text("标签颜色"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => SegmentedButton(
                            onSelectionChanged: (newSelection) {
                              final color = MarkConstant.colorList.firstWhere(
                                (color) => color == newSelection.first,
                              );
                              controller.selectedMarkColor.value = color;
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.selected)) {
                                  return controller.selectedMarkColor.value;
                                }
                                return Colors.transparent;
                              }),
                            ),
                            showSelectedIcon: false,
                            segments: [
                              ...MarkConstant.colorList.map(
                                (color) => ButtonSegment<Color>(
                                  value: color,
                                  label: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color:
                                          controller.selectedMarkColor.value !=
                                              color
                                          ? color
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            selected: {controller.selectedMarkColor.value},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () {
                    controller.markService.saveMark(
                      id: initData?.id,
                      name: controller.markNameController.text,
                      color: controller.selectedMarkColor.value.toARGB32(),
                    );
                    Get.back();
                  },
                  label: Text("确认"),
                  icon: Icon(Icons.check),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
