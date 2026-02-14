import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/screen/collection/widget/collection_form_widget.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

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
              saveCollection(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.collectionService.collections.isEmpty) {
          return Center(child: CustomEmpty(message: "暂无收藏夹，点击右上角添加"));
        }
        return ListView.builder(
          itemCount: controller.collectionService.collections.length,
          itemBuilder: (context, index) {
            final collection = controller.collectionService.collections[index];
            final icon = CollectionConstant.iconList.firstWhere(
              (iconData) => iconData.codePoint == collection.icon,
            );
            return ListTile(
              title: Text(collection.name),
              leading: Icon(icon, color: Color(collection.color)),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: 'edit', child: Text('编辑')),
                    PopupMenuItem(value: 'delete', child: Text('删除')),
                  ];
                },
                onSelected: (value) {
                  if (value == 'edit') {
                    saveCollection(
                      context,
                      initData: CollectionFormData(
                        id: collection.id,
                        name: collection.name,
                        iconData: collection.icon,
                        color: collection.color,
                      ),
                    );
                  } else if (value == 'delete') {
                    controller.collectionService.deleteCollection(
                      collection.id,
                    );
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> saveCollection(
    BuildContext context, {
    CollectionFormData? initData,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return CollectionFormWidget(
              scrollController: scrollController,
              onConfirm: (data) {
                controller.collectionService.saveCollection(
                  id: initData?.id,
                  name: data.name,
                  icon: data.iconData,
                  color: data.color,
                );
              },
            );
          },
        );
      },
    );
  }
}
