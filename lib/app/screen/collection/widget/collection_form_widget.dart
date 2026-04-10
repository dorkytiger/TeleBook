import 'package:flutter/material.dart';
import 'package:tele_book/app/constant/collection_constant.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header
          Container(
            height: kToolbarHeight,
            padding: EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
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
                      style: Theme.of(context).textTheme.titleLarge,
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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("收藏夹名称"),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "请输入收藏夹名称",
                      errorText: nameErrorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Text("收藏夹描述"),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "请输入收藏夹描述（可选）",
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
    );
  }
}

class CollectionFormData {
  final int? id;
  final String name;
  final String? description;

  CollectionFormData({this.id, required this.name, this.description});
}
