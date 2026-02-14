import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class CollectionFormWidget extends StatefulWidget {
  final ScrollController scrollController;
  final CollectionFormData? initialData;
  final Function(CollectionFormData) onConfirm;

  const CollectionFormWidget({
    super.key,
    required this.scrollController,
    this.initialData,
    required this.onConfirm,
  });

  @override
  State<CollectionFormWidget> createState() => _CollectionFormWidgetState();
}

class _CollectionFormWidgetState extends State<CollectionFormWidget> {
  final TextEditingController nameController = TextEditingController();
  Color selectedColor = CollectionConstant.colorList.first;
  IconData selectedIcon = CollectionConstant.iconList.first;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final initIcon = CollectionConstant.iconList.firstWhere(
        (iconData) => iconData.codePoint == widget.initialData!.iconData,
        orElse: () => CollectionConstant.iconList.first,
      );
      final initColor = CollectionConstant.colorList.firstWhere(
        (color) => color.toARGB32() == widget.initialData!.color,
        orElse: () => CollectionConstant.colorList.first,
      );
      setState(() {
        nameController.text = widget.initialData!.name;
        selectedIcon = initIcon;
        selectedColor = initColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text("收藏夹名称"),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "请输入收藏夹名称",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Text("收藏夹颜色"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<Color>(
                  onSelectionChanged: (color) {
                    setState(() {
                      selectedColor = color.first;
                    });
                  },
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return selectedColor;
                      }
                      return Colors.transparent;
                    }),
                  ),
                  segments: [
                    ...CollectionConstant.colorList.map(
                      (color) => ButtonSegment(
                        value: color,
                        label: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selectedColor != color
                                ? color
                                : Theme.of(context).colorScheme.onPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                  selected: {selectedColor},
                ),
              ),
              Text("收藏夹图标"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SegmentedButton<IconData>(
                  showSelectedIcon: false,
                  onSelectionChanged: (iconData) {
                    setState(() {
                      selectedIcon = iconData.first;
                    });
                  },
                  segments: [
                    ...CollectionConstant.iconList.map(
                      (iconData) =>
                          ButtonSegment(value: iconData, label: Icon(iconData)),
                    ),
                  ],
                  selected: {selectedIcon},
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: () {
            widget.onConfirm(
              CollectionFormData(
                id: widget.initialData?.id,
                name: nameController.text,
                color: selectedColor.toARGB32(),
                iconData: selectedIcon.codePoint,
              ),
            );
          },
          label: Text("确认"),
          icon: Icon(Icons.check),
        ),
      ),
    );
  }
}

class CollectionFormData {
  final int? id;
  final String name;
  final int iconData;
  final int color;

  CollectionFormData({
    this.id,
    required this.name,
    required this.iconData,
    required this.color,
  });
}
