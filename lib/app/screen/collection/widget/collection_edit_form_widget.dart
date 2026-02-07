import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class CollectionEditFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String? selectedIconId;
  final String? selectedColorId;
  final Function(IconData iconData) onIconSelected;
  final Function(Color color) onColorSelected;

  const CollectionEditFormWidget({
    super.key,
    required this.nameController,
    required this.onConfirm,
    required this.onCancel,
    this.selectedIconId,
    this.selectedColorId,
    required this.onIconSelected,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: TDTheme.of(context).bgColorContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              TDFormItemTitle(label: "收藏夹名称", required: true),
              TDInput(controller: nameController, hintText: "请输入收藏夹名称"),
              TDFormItemTitle(label: "选择图标", required: true),
              TDRadioGroup(
                cardMode: true,
                direction: Axis.horizontal,
                rowCount: 5,
                selectId: selectedIconId,
                onRadioGroupChange: (id) {
                  final iconData = CollectionConstant.iconList.firstWhere(
                    (icon) => icon.codePoint.toString() == id,
                  );
                  onIconSelected(iconData);
                },
                directionalTdRadios: [
                  ...CollectionConstant.iconList.map(
                    (iconData) => TDRadio(
                      id: iconData.codePoint.toString(),
                      cardMode: true,
                      backgroundColor: TDTheme.of(context).grayColor1,
                      customContentBuilder: (context, selected, text) {
                        return Icon(
                          iconData,
                          color: selected ? Colors.blue : Colors.grey,
                        );
                      },
                    ),
                  ),
                ],
              ),
              TDFormItemTitle(label: "选择颜色", required: true),
              TDRadioGroup(
                cardMode: true,
                direction: Axis.horizontal,
                rowCount: 5,
                selectId: selectedColorId,
                onRadioGroupChange: (id) {
                  final color = CollectionConstant.colorList.firstWhere(
                    (color) => color.toARGB32().toString() == id,
                  );
                  onColorSelected(color);
                },
                directionalTdRadios: [
                  ...CollectionConstant.colorList.map(
                    (color) => TDRadio(
                      id: color.toARGB32().toString(),
                      cardMode: true,
                      backgroundColor: color,
                      customContentBuilder: (context, selected, text) {
                        return selected
                            ? Icon(Icons.check, color: Colors.white)
                            : SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TDButton(
                      text: "取消",
                      theme: TDButtonTheme.defaultTheme,
                      onTap: onCancel,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TDButton(
                      text: "确认",
                      theme: TDButtonTheme.primary,
                      onTap: onConfirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
