import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/widget/empty_widget.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/feature/collection/ui/provider/collection_provider.dart';

class CollectionView extends ConsumerWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(collectionListProvider);
    final controllerState = ref.watch(collectionControllerProvider);

    ref.listen<AsyncValue<void>>(collectionControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            Navigator.of(context, rootNavigator: true).maybePop();
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

    return Scaffold(
      appBar: AppBar(
        title: Text("收藏夹"),
        actions: [
          IconButton(
            onPressed: controllerState.isLoading
                ? null
                : () => _showCreateDialog(context, ref),
            icon: controllerState.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
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

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return ListTile(
                title: Text(item.collection.name),
                subtitle: Text(item.count.toString()),
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

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("创建收藏夹"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "名称",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bookmark_outline),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("取消"),
            ),
            Consumer(
              builder: (context, ref, _) {
                final isLoading = ref
                    .watch(collectionControllerProvider)
                    .isLoading;
                return TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          ref
                              .read(collectionControllerProvider.notifier)
                              .createCollection(
                                name: nameController.text,
                                description: descController.text,
                              );
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("创建"),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
