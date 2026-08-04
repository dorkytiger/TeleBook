import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/empty_widget.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/core/route/app_route.dart';
import 'package:tele_book/feature/collection/ui/provider/collection_provider.dart';

class CollectionView extends ConsumerStatefulWidget {
  const CollectionView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CollectionViewState();
}

class _CollectionViewState extends ConsumerState<CollectionView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(collectionListProvider);

    ref.listen<AsyncValue<void>>(createCollectionControllerProvider, (
      prev,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            showFToast(context: context, title: Text("创建收藏夹成功"));
          }
        },
        error: (e, _) {
          showFToast(
            context: context,
            title: Text("创建收藏夹失败"),
            description: Text(e.toString()),
          );
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
            showFToast(context: context, title: Text("修改收藏夹成功"));
          }
        },
        error: (e, _) {
          showFToast(
            context: context,
            title: Text("修改收藏夹失败"),
            description: Text(e.toString()),
          );
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
            showFToast(context: context, title: Text("删除收藏夹成功"));
          }
        },
        error: (e, _) {
          showFToast(
            context: context,
            title: Text("删除收藏夹失败"),
            description: Text(e.toString()),
          );
        },
      );
    });

    return FScaffold(
      header: FHeader(
        title: Text("收藏夹"),
        suffixes: [
          FHeaderAction(
            onPress: () => _showCreateBottomSheet(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      child: listAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: CustomEmptyWidget(
                icon: Icons.collections_bookmark_outlined,
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 230,
            ),
            itemCount: list.length,
            itemBuilder: (listContext, index) {
              final item = list[index];
              final controller = FPopoverController(vsync: this);
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
                                cacheWidth: 300,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),

                    FItem(
                      title: Text(
                        item.collection.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text("${item.count} 本书"),
                      suffix: FPopoverMenu(
                        control: FPopoverControl.managed(
                          controller: controller,
                        ),
                        autofocus: true,
                        menu: [
                          .group(
                            children: [
                              .item(
                                title: Text('编辑'),
                                prefix: Icon(FLucideIcons.edit),
                                onPress: () {
                                  controller.hide();
                                  _showUpdateBottomSheet(
                                    context,
                                    ref,
                                    collectionId: item.collection.id,
                                    initialName: item.collection.name,
                                    initialDescription:
                                        item.collection.description ?? '',
                                  );
                                },
                              ),
                              .item(
                                variant: .destructive,
                                title: Text('删除'),
                                prefix: Icon(FLucideIcons.delete),
                                onPress: () {
                                  controller.hide();
                                  _showDeleteConfirmDialog(
                                    context,
                                    item.collection.id,
                                    ref,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                        builder: (context, controller, child) {
                          return FButton.icon(
                            onPress: () {
                              controller.show();
                            },
                            variant: .ghost,
                            child: Icon(FLucideIcons.moreHorizontal),
                          );
                        },
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
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formData = await showFSheet<_CollectionFormData>(
      context: context,
      side: .btt,
      mainAxisMaxRatio: null,
      builder: (sheetContext) {
        return Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: .symmetric(
                horizontal: BorderSide(color: context.theme.colors.border),
              ),
            ),
            child: Padding(
              padding: .all(24),
              child: Column(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "创建收藏夹",
                    style: context.theme.typography.display.xl2.copyWith(
                      fontWeight: .w600,
                      color: context.theme.colors.foreground,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "按自己的习惯创建收藏夹，方便管理书籍",
                    style: context.theme.typography.body.sm.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FTextFormField(
                    control: FTextFieldControl.managed(
                      controller: nameController,
                    ),
                    label: Text("收藏夹名称"),
                    hint: "请输入收藏夹名称",
                    prefixBuilder: (context, style, _) {
                      return FButton.icon(
                        onPress: () {},
                        style: style.obscureButtonStyle,
                        child: Icon(Icons.collections_bookmark_outlined),
                      );
                    },
                    validator: (v) => (v?.isEmpty ?? true) ? "请输入收藏夹名称" : null,
                  ),
                  SizedBox(height: 16),
                  FTextFormField(
                    control: FTextFieldControl.managed(
                      controller: descController,
                    ),
                    label: Text("描述"),
                    hint: "请输入收藏夹描述（可选）",
                    prefixBuilder: (context, style, _) {
                      return FButton.icon(
                        onPress: () {},
                        style: style.obscureButtonStyle,
                        child: Icon(Icons.description_outlined),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FButton(
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          context.pop(
                            _CollectionFormData(
                              name: nameController.text,
                              description: descController.text,
                            ),
                          );
                        }
                      },
                      prefix: Icon(FLucideIcons.plus),
                      child: const Text("创建"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (formData != null) {
      await ref
          .read(createCollectionControllerProvider.notifier)
          .createCollection(
            name: formData.name,
            description: formData.description,
          );
    }
  }

  Future<void> _showUpdateBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    required int collectionId,
    required String initialName,
    required String initialDescription,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: initialName);
    final descController = TextEditingController(text: initialDescription);
    final formData = await showFSheet<_CollectionFormData>(
      context: context,
      side: .btt,
      mainAxisMaxRatio: null,
      builder: (sheetContext) {
        return Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.colors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: .symmetric(
                horizontal: BorderSide(color: context.theme.colors.border),
              ),
            ),
            child: Padding(
              padding: .all(16),
              child: Column(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "编辑收藏夹",
                    style: context.theme.typography.display.xl2.copyWith(
                      fontWeight: .w600,
                      color: context.theme.colors.foreground,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "按自己的习惯创建收藏夹，方便管理书籍",
                    style: context.theme.typography.body.sm.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FTextFormField(
                    control: FTextFieldControl.managed(
                      controller: nameController,
                    ),
                    label: Text("收藏夹名称"),
                    hint: "请输入收藏夹名称",
                    prefixBuilder: (context, style, _) {
                      return FButton.icon(
                        onPress: () {},
                        style: style.obscureButtonStyle,
                        child: Icon(Icons.collections_bookmark_outlined),
                      );
                    },
                    validator: (v) => (v?.isEmpty ?? true) ? "请输入收藏夹名称" : null,
                  ),
                  SizedBox(height: 16),
                  FTextFormField(
                    control: FTextFieldControl.managed(
                      controller: descController,
                    ),
                    label: Text("描述"),
                    hint: "请输入收藏夹描述（可选）",
                    prefixBuilder: (context, style, _) {
                      return FButton.icon(
                        onPress: () {},
                        style: style.obscureButtonStyle,
                        child: Icon(Icons.description_outlined),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FButton(
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          context.pop(
                            _CollectionFormData(
                              name: nameController.text,
                              description: descController.text,
                            ),
                          );
                        }
                      },
                      prefix: Icon(FLucideIcons.edit),
                      child: const Text("修改"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (formData != null) {
      ref
          .read(updateCollectionControllerProvider.notifier)
          .updateCollection(
            collectionId: collectionId,
            name: nameController.text,
            description: descController.text,
          );
    }
  }

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    int collectionId,
    WidgetRef ref,
  ) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (dialogContext, style, animate) => FDialog.adaptive(
        horizontalBuilder: (context, style) {
          return Padding(
            padding: .all(16),
            child: Column(
              mainAxisSize: .min,
              children: [
                const Text("删除收藏夹"),
                const Text("确定要删除这个收藏夹吗？"),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text("取消"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text("删除"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },

        verticalBuilder: (context, style) {
          return Padding(
            padding: .all(16),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                Text("删除收藏夹", style: style.titleTextStyle),
                SizedBox(height: 8),
                Text("确定要删除这个收藏夹吗？", style: style.bodyTextStyle),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    FButton(
                      variant: .ghost,
                      onPress: () => Navigator.of(dialogContext).pop(false),
                      child: const Text("取消"),
                    ),
                    SizedBox(width: 8),
                    FButton(
                      variant: .destructive,
                      onPress: () => Navigator.of(dialogContext).pop(true),
                      child: const Text("删除"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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
