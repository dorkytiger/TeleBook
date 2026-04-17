import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/screen/collection/widget/collection_form_widget.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'collection_controller.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CollectionController(collectionStore: context.read()),
      child: _CollectionContent(),
    );
  }
}

class _CollectionContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionController>(
      builder: (context, controller, child) {
        final collections = controller.collections;
        return Scaffold(
          appBar: AppBar(
            title: Text('我的收藏夹'),
            actions: [
              IconButton(
                onPressed: () => _saveCollection(context, controller),
                icon: Icon(Icons.add),
                tooltip: '新建收藏夹',
              ),
            ],
          ),
          body: collections.isEmpty
              ? Center(child: CustomEmpty(message: "暂无收藏夹，点击右上角创建一个吧！"))
              : ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    return ListTile(
                      title: Text(collection.name),
                      subtitle: Text(collection.description ?? ""),
                      onTap: () =>
                          controller.showCollectionBooks(collection, context),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _saveCollection(
                              context,
                              controller,
                              initData: CollectionFormData(
                                id: collection.id,
                                name: collection.name,
                                description: collection.description,
                              ),
                            ),
                            icon: Icon(Icons.edit),
                            tooltip: '编辑',
                          ),
                          IconButton(
                            onPressed: () =>
                                _confirmDelete(context, controller, collection),
                            icon: Icon(Icons.delete, color: Colors.red),
                            tooltip: '删除',
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // 确认删除
  void _confirmDelete(
    BuildContext context,
    CollectionController controller,
    CollectionTableData collection,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('确认删除'),
          content: Text('确定要删除收藏夹"${collection.name}"吗？'),
          actions: [
            TextButton(onPressed: () => context.pop(), child: Text('取消')),
            TextButton(
              onPressed: () {
                controller.deleteCollection(context, collection.id);
                context.pop();
              },
              child: Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCollection(
    BuildContext context,
    CollectionController controller, {
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
              controller.saveCollection(
                context,
                initData?.id,
                data.name,
                data.description,
              );
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
