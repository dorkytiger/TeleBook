import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/screen/collection/widget/collection_edit_form_widget.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/widget/td/td_cell_group_title_widge.dart';
import 'package:tele_book/app/widget/td/td_cell_image_icon_widget.dart';
import 'collection_controller.dart';

class CollectionScreen extends GetView<CollectionController> {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收藏夹管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.clearFormData();
              Get.bottomSheet(
                _editCollectionForm(false),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: controller.getCollectionState.displaySuccess(
        successBuilder: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                TDCellGroup(
                  theme: TDCellGroupTheme.cardTheme,
                  cells: [
                    ...data.map((collection) {
                      final iconData = CollectionConstant.iconList.firstWhere(
                        (element) => element.codePoint == collection.icon,
                      );
                      final color = CollectionConstant.colorList.firstWhere(
                        (element) => element.toARGB32() == collection.color,
                      );
                      return TDCell(
                        title: collection.name,
                        imageWidget: TDCellImageIconWidget(
                          iconData: iconData,
                          color: color,
                        ),
                        noteWidget: Row(
                          children: [
                            TDButton(
                              icon: Icons.edit,
                              theme: TDButtonTheme.primary,
                              type: TDButtonType.text,
                              onTap: () {
                                controller.initFormData(collection);
                                Get.bottomSheet(
                                  _editCollectionForm(true),
                                  isScrollControlled: true,
                                );
                              },
                            ),
                            TDButton(
                              icon: Icons.delete,
                              theme: TDButtonTheme.danger,
                              type: TDButtonType.text,
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  pageBuilder:
                                      (
                                        BuildContext buildContext,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                      ) {
                                        return TDAlertDialog(
                                          title: '删除收藏夹',
                                          content: '确定要删除该收藏夹吗？',
                                          leftBtnAction: () {
                                            Get.back();
                                          },
                                          rightBtnAction: () {
                                            controller.deleteCollection(
                                              collection.id,
                                            );
                                          },
                                        );
                                      },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _editCollectionForm(bool isEditMode) {
    return CollectionEditFormWidget(
      nameController: controller.collectionNameController,
      selectedColorId: controller.selectedCollectionColor.value
          ?.toARGB32()
          .toString(),
      selectedIconId: controller.selectedCollectionIconData.value?.codePoint
          .toString(),
      onConfirm: () {
        if (isEditMode) {
          controller.editCollection();
        } else {
          controller.addCollection();
        }
      },
      onCancel: () {
        Navigator.of(Get.context!).pop();
        controller.clearFormData();
      },
      onIconSelected: (iconData) {
        controller.selectedCollectionIconData.value = iconData;
      },
      onColorSelected: (color) {
        controller.selectedCollectionColor.value = color;
      },
    );
  }
}
