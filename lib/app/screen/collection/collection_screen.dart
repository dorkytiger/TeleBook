import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/util/request_state.dart';
import 'package:tele_book/app/widget/td/td_cell_group_title_widge.dart';
import 'collection_controller.dart';

class CollectionScreen extends GetView<CollectionController> {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(
        title: '收藏夹管理',
        rightBarItems: [
          TDNavBarItem(
            icon: Icons.add,
            action: () {
              Get.bottomSheet(
                _editCollectionForm(false),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => DisplayResult(
          state: controller.getCollectionState.value,
          onSuccess: (data) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ...data.map(
                    (collection) => TDSwipeCell(
                      cell: TDCell(title: collection.name),
                      right: TDSwipeCellPanel(
                        children: [
                          TDSwipeCellAction(
                            label: '编辑',
                            backgroundColor: TDTheme.of(
                              context,
                            ).brandNormalColor,
                            onPressed: (context) {
                              controller.collectionNameController.text =
                                  collection.name;
                              Get.bottomSheet(
                                _editCollectionForm(
                                  true,
                                  collectionId: collection.id,
                                ),
                                isScrollControlled: true,
                              );
                            },
                          ),
                          TDSwipeCellAction(
                            label: '删除',
                            backgroundColor: TDTheme.of(
                              context,
                            ).errorNormalColor,
                            onPressed: (context) {
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
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _editCollectionForm(bool isEditMode, {int? collectionId}) {
    return TDPopupBottomConfirmPanel(
      rightClick: () {
        if (isEditMode) {
          controller.editCollection(collectionId!);
        } else {
          controller.addCollection();
        }
      },
      child: Column(
        children: [
          TDInput(
            required: true,
            controller: controller.collectionNameController,
            leftLabel: "收藏夹名称",
            hintText: "请输入收藏夹名称",
          ),
        ],
      ),
    );
  }
}
