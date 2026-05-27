import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/empty_widget.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/collection/ui/provider/collection_provider.dart';

class CollectionView extends ConsumerWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(collectionListProvider);

    ref.listen<AsyncValue<void>>(createCollectionControllerProvider, (
      prev,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("创建收藏夹成功")));
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("创建收藏夹失败: $e")));
        },
      );
    });

    ref.listen<AsyncValue<void>>(updateCollectionControllerProvider, (
      prev,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("更新收藏夹成功")));
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("更新收藏夹失败: $e")));
        },
      );
    });

    ref.listen<AsyncValue<void>>(deleteCollectionControllerProvider, (
      prev,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("删除收藏夹成功")));
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("删除收藏夹失败: $e")));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("收藏夹"),
        actions: [
          IconButton(
            onPressed: () => _showCreateBottomSheet(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: listAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: CustomEmptyWidget(
                icon: Icons.collections_bookmark_outlined,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push(
                  AppRoute.collectionBook,
                  extra: item.collection.id,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (item.coverImages.isEmpty)
                      AspectRatio(
                        aspectRatio: 1,
                        child: SizedBox(
                          child: Icon(
                            Icons.collections_bookmark_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    else
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GridView.count(
                            crossAxisCount: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            children: item.coverImages.take(4).map((url) {
                              return Image.file(
                                File(url),
                                fit: BoxFit.cover,
                                cacheWidth: 200,
                                cacheHeight: 200,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        minVerticalPadding: 0,

                        title: Text(
                          item.collection.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text("${item.count} 本书"),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'update') {
                              _showUpdateBottomSheet(
                                context,
                                ref,
                                collectionId: item.collection.id,
                                initialName: item.collection.name,
                                initialDescription:
                                    item.collection.description ?? '',
                              );
                            }
                            if (value == 'delete') {
                              _showDeleteConfirmDialog(
                                context,
                                item.collection.id,
                                ref,
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'update', child: Text('编辑')),
                            PopupMenuItem(value: 'delete', child: Text('删除')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, st) {
          return Center(
            child: CustomErrorWidget(
              stackTrace: st,
              errorMessage: e.toString(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateBottomSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final formData = await showModalBottomSheet<_CollectionFormData>(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: MediaQuery.of(sheetContext).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("创建收藏夹", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "收藏夹名称",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.collections_bookmark_outlined),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "描述",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final desc = descController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("名称不能为空")));
                        return;
                      }
                      Navigator.of(
                        sheetContext,
                      ).pop(_CollectionFormData(name: name, description: desc));
                    },
                    child: const Text("创建"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (formData == null) return;
    ref
        .read(createCollectionControllerProvider.notifier)
        .createCollection(
          name: formData.name,
          description: formData.description,
        );
  }

  Future<void> _showUpdateBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    required int collectionId,
    required String initialName,
    required String initialDescription,
  }) async {
    final nameController = TextEditingController(text: initialName);
    final descController = TextEditingController(text: initialDescription);

    final formData = await showModalBottomSheet<_CollectionFormData>(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: MediaQuery.of(sheetContext).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("编辑收藏夹", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "收藏夹名称",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.collections_bookmark_outlined),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "描述",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final desc = descController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("名称不能为空")));
                        return;
                      }
                      Navigator.of(
                        sheetContext,
                      ).pop(_CollectionFormData(name: name, description: desc));
                    },
                    child: const Text("更新"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (formData == null) return;
    ref
        .read(updateCollectionControllerProvider.notifier)
        .updateCollection(
          collectionId: collectionId,
          name: formData.name,
          description: formData.description,
        );
  }

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    int collectionId,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("删除收藏夹"),
          content: const Text("确定要删除这个收藏夹吗？"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text("取消"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text("删除"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ref
          .read(deleteCollectionControllerProvider.notifier)
          .deleteCollection(collectionId: collectionId);
    }
  }
}

class _CollectionFormData {
  final String name;
  final String description;

  const _CollectionFormData({required this.name, required this.description});
}
