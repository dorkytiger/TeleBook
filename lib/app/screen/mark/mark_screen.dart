import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'mark_controller.dart';

class MarkScreen extends StatelessWidget {
  const MarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarkController(markStore: context.read()),
      child: const _MarkContent(),
    );
  }
}

class _MarkContent extends StatelessWidget {
  const _MarkContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkController>(
      builder: (context, controller, _) {
        final marks = controller.markStore.marks;
        return Scaffold(
          appBar: AppBar(
            title: const Text('书签管理'),
            actions: [
              IconButton(
                onPressed: () => _saveMark(context, controller),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: marks.isEmpty
              ? const Center(child: CustomEmpty(message: '暂无书签，点击右上角添加'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(
                      height: 16,
                      thickness: 0.5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  itemCount: marks.length,
                  itemBuilder: (context, index) {
                    final mark = marks[index];
                    return ListTile(
                      title: Text(
                        mark.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: mark.description != null &&
                              mark.description!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                mark.description!,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.7),
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : null,
                      trailing: MenuAnchor(
                        alignmentOffset: const Offset(-32, 0),
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.edit),
                            onPressed: () => _saveMark(
                              context,
                              controller,
                              initData: MarkFormData(
                                id: mark.id,
                                name: mark.name,
                                description: mark.description,
                              ),
                            ),
                            child: const Text('编辑'),
                          ),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteMark(mark.id),
                            child: const Text('删除'),
                          ),
                        ],
                        builder: (_, menuController, __) => IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => menuController.isOpen
                              ? menuController.close()
                              : menuController.open(),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  void _saveMark(
    BuildContext context,
    MarkController controller, {
    MarkFormData? initData,
  }) {
    if (initData != null) {
      controller.markNameController.text = initData.name;
      controller.markDescriptionController.text = initData.description ?? '';
    } else {
      controller.resetMarkForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Material(
            color: Theme.of(sheetContext).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  height: kToolbarHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(sheetContext).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            initData == null ? '添加书签' : '编辑书签',
                            style: Theme.of(sheetContext)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      // 使用 ListenableBuilder 仅重建按钮区域
                      ListenableBuilder(
                        listenable: controller,
                        builder: (_, __) => IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            if (!controller.validateMarkName()) return;
                            controller.saveMark(
                              id: initData?.id,
                              name: controller.markNameController.text.trim(),
                              description: controller
                                          .markDescriptionController.text
                                          .trim()
                                          .isEmpty
                                  ? null
                                  : controller.markDescriptionController.text
                                        .trim(),
                            );
                            Navigator.of(sheetContext).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Form
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListenableBuilder(
                          listenable: controller,
                          builder: (_, __) => TextField(
                            controller: controller.markNameController,
                            decoration: InputDecoration(
                              hintText: '请输入书签名称',
                              labelText: '书签名称',
                              prefixIcon:
                                  const Icon(Icons.bookmark_outline),
                              errorText: controller.markNameError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: controller.markDescriptionController,
                          decoration: InputDecoration(
                            hintText: '请输入书签描述（可选）',
                            labelText: '书签描述',
                            prefixIcon:
                                const Icon(Icons.description_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
