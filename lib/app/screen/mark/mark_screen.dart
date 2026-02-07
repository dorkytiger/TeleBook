import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/screen/mark/widget/mark_edit_form_widget.dart';
import 'mark_controller.dart';

class MarkScreen extends GetView<MarkController> {
  const MarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: "书签管理",
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.add,
            action: () {
              controller.clearFormData();
              Navigator.of(context).push(
                TDSlidePopupRoute(
                  focusMove: true,
                  slideTransitionFrom: SlideTransitionFrom.bottom,
                  builder: (context) {
                    return MarkEditFormWidget(
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
                ),
              );
            },
          ),
        ],
      ),
      body: controller.getMarkListState.display(
        emptyBuilder: () {
          return TDEmpty();
        },
        loadingBuilder: () => const Center(child: CircularProgressIndicator()),
        successBuilder: (data) {
          return Column(
            children: [
              SizedBox(height: 16),
              TDCellGroup(
                theme: TDCellGroupTheme.cardTheme,
                cells: [
                  ...data.map(
                    (mark) => TDCell(
                      title: mark.name,
                      imageWidget: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(mark.color),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      noteWidget: Row(
                        children: [
                          TDButton(
                            icon: Icons.edit,
                            theme: TDButtonTheme.primary,
                            type: TDButtonType.text,
                            onTap: () {
                              controller.initFormData(mark);
                              Navigator.of(context).push(
                                TDSlidePopupRoute(
                                  focusMove: true,
                                  slideTransitionFrom:
                                      SlideTransitionFrom.bottom,
                                  builder: (context) {
                                    return MarkEditFormWidget(
                                      onConfirm: () {
                                        controller.updateMark(mark.id);
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                      markNameController:
                                          controller.markNameController,
                                      selectedColor: controller.selectedMarkColor.value,
                                      onColorSelected: (color) {
                                        controller.selectedMarkColor.value =
                                            color;
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 8),
                          TDButton(
                            icon: Icons.delete,
                            type: TDButtonType.text,
                            theme: TDButtonTheme.danger,
                            onTap: () {
                              showGeneralDialog(
                                context: context,
                                pageBuilder: (context, _, _) {
                                  return TDAlertDialog(
                                    title: "删除书签",
                                    content: "确定要删除该书签吗？删除后不可恢复。",
                                    rightBtn: TDDialogButtonOptions(
                                      title: "删除",
                                      action: () {
                                        controller.deleteMark(mark.id);
                                        Navigator.of(context).pop();
                                      },
                                      theme: TDButtonTheme.danger,
                                    ),
                                    leftBtn: TDDialogButtonOptions(
                                      title: "取消",
                                      action: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
