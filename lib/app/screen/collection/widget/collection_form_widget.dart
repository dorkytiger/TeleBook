import 'package:flutter/material.dart';

class CollectionFormWidget extends StatefulWidget {
  final CollectionFormData? initialData;
  final Function(CollectionFormData) onConfirm;
  final ScrollController? scrollController;

  const CollectionFormWidget({
    super.key,
    this.initialData,
    required this.onConfirm,
    this.scrollController,
  });

  @override
  State<CollectionFormWidget> createState() => _CollectionFormWidgetState();
}

class _CollectionFormWidgetState extends State<CollectionFormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? nameErrorText;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      setState(() {
        nameController.text = widget.initialData!.name;
        descriptionController.text = widget.initialData!.description ?? "";
      });
    }
  }

  bool _validateName() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        nameErrorText = "收藏夹名称不能为空";
      });
      return false;
    }
    setState(() {
      nameErrorText = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Use a lightweight Material container instead of nested Scaffold to avoid
    // layout/hittest issues when this widget is shown inside a bottom sheet.
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header
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
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.initialData == null ? "新建收藏夹" : "编辑收藏夹",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // confirm button on the right of the header
                IconButton(
                  onPressed: () {
                    if (!_validateName()) {
                      return;
                    }
                    widget.onConfirm(
                      CollectionFormData(
                        id: widget.initialData?.id,
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                      ),
                    );
                  },
                  icon: Icon(Icons.check),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "收藏夹名称",
                      hintText: "请输入收藏夹名称",
                      errorText: nameErrorText,
                      prefixIcon: Icon(Icons.folder),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "收藏夹描述",
                      hintText: "请输入收藏夹描述（可选）",
                      prefixIcon: Icon(Icons.description),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
    );
  }
}

class CollectionFormData {
  final int? id;
  final String name;
  final String? description;

  CollectionFormData({this.id, required this.name, this.description});
}
