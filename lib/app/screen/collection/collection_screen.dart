import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/screen/collection/widget/collection_form_widget.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'collection_controller.dart';

class CollectionScreen extends GetView<CollectionController> {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('收藏夹管理'),
          actions: [
            IconButton(
              icon: Icon(controller.isEditMode.value ? Icons.done : Icons.edit),
              onPressed: controller.toggleEditMode,
            ),
            if (!controller.isEditMode.value)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _saveCollection(context),
              ),
          ],
        ),
        body: Obx(() {
          if (controller.collectionService.collections.isEmpty) {
            return Center(child: CustomEmpty(message: "暂无收藏夹，点击右上角添加"));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Divider(
                height: 16,
                thickness: 0.5,
                color: Theme.of(context).dividerColor,
              ),
            ),

            itemCount: controller.collectionService.collections.length,
            itemBuilder: (context, index) {
              final collection =
                  controller.collectionService.collections[index];
              final bookCount = controller.collectionService.collectionBooks
                  .where((cb) => cb.collectionId == collection.id)
                  .length;
              final isEditMode = controller.isEditMode.value;

              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: isEditMode
                    ? null
                    : () => _showCollectionBooks(context, collection),
                title: Text(
                  collection.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '$bookCount 本书籍',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    if (collection.description != null &&
                        collection.description!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          collection.description!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.6),
                                fontStyle: FontStyle.italic,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                trailing: isEditMode
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _saveCollection(
                              context,
                              initData: CollectionFormData(
                                id: collection.id,
                                name: collection.name,
                                description: collection.description,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () =>
                                _confirmDelete(context, collection),
                          ),
                        ],
                      )
                    : Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          );
        }),
      ),
    );
  }

  // 显示收藏夹中的书籍网格
  void _showCollectionBooks(BuildContext context, collection) {
    controller.showCollectionBooks(collection);
  }

  // 确认删除
  void _confirmDelete(BuildContext context, collection) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('确认删除'),
          content: Text('确定要删除收藏夹"${collection.name}"吗？'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('取消')),
            TextButton(
              onPressed: () {
                controller.collectionService.deleteCollection(collection.id);
                Get.back();
              },
              child: Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCollection(
    BuildContext context, {
    CollectionFormData? initData,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CollectionFormWidget(
            initialData: initData,
            onConfirm: (data) {
              controller.collectionService.saveCollection(
                id: initData?.id,
                name: data.name,
                description: data.description,
              );
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
