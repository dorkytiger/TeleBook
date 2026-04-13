import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'mark_controller.dart';

class MarkScreen extends GetView<MarkController> {
  const MarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书签管理"),
        actions: [
          IconButton(
            onPressed: () {
              _saveMark(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(
        () => controller.markService.marks.isEmpty
            ? Center(child: CustomEmpty(message: "暂无书签，点击右上角添加"))
            : ListView.separated(
                padding: EdgeInsets.all(16),
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Divider(
                    height: 16,
                    thickness: 0.5,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                itemCount: controller.markService.marks.length,
                itemBuilder: (context, index) {
                  final mark = controller.markService.marks[index];
                  return ListTile(
                    title: Text(
                      mark.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle:
                        mark.description != null && mark.description!.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 4),
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
                      alignmentOffset: Offset(-32, 0),
                      menuChildren: [
                        MenuItemButton(
                          leadingIcon: const Icon(Icons.edit),
                          onPressed: () => _saveMark(
                            context,
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
                          onPressed: () =>
                              controller.markService.deleteMark(mark.id),
                          child: const Text('删除'),
                        ),
                      ],
                      builder: (context, controller, child) => IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => controller.isOpen
                            ? controller.close()
                            : controller.open(),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _saveMark(BuildContext context, {MarkFormData? initData}) {
    // 重置或设置表单数据
    if (initData != null) {
      controller.markNameController.text = initData.name;
      controller.markDescriptionController.text = initData.description ?? "";
    } else {
      controller.resetMarkForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // Return a simple Material-based form so the confirm button can be
        // placed in the header (right side) and content stays non-scrollable.
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: kToolbarHeight,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            initData == null ? "添加书签" : "编辑书签",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          if (!controller.validateMarkName()) {
                            return;
                          }
                          controller.markService.saveMark(
                            id: initData?.id,
                            name: controller.markNameController.text.trim(),
                            description:
                                controller.markDescriptionController.text
                                    .trim()
                                    .isEmpty
                                ? null
                                : controller.markDescriptionController.text
                                      .trim(),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),

                // content (non-scrollable)
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return TextField(
                            controller: controller.markNameController,
                            decoration: InputDecoration(
                              hintText: "请输入书签名称",
                              labelText: "书签名称",
                              prefixIcon: Icon(Icons.bookmark_outline),
                              errorText: controller.markNameError.value,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }),
                        TextField(
                          controller: controller.markDescriptionController,
                          decoration: InputDecoration(
                            hintText: "请输入书签描述（可选）",
                            labelText: "书签描述",
                            prefixIcon: Icon(Icons.description_outlined),
                            fillColor: Colors.transparent,
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
