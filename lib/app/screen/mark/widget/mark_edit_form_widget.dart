import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/constant/mark_constant.dart';
import 'package:tele_book/app/widget/td/td_form_item_title.dart';

class MarkEditFormWidget extends StatelessWidget {
  final Function onConfirm;
  final Function onCancel;
  final TextEditingController markNameController;
  final Color selectedColor;
  final Function(Color color) onColorSelected;

  const MarkEditFormWidget({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.markNameController,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TDPopupBottomConfirmPanel(
      rightClick: () {
        onConfirm();
      },
      leftClick: () {
        onCancel();
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            TDFormItemTitle(label: "标签名称", required: true),
            TDInput(controller: markNameController, hintText: "请输入标签名称"),
            TDFormItemTitle(label: "选择颜色", required: true),
            TDRadioGroup(
              cardMode: true,
              direction: Axis.horizontal,
              rowCount: 5,
              selectId: selectedColor.toARGB32().toString(),
              onRadioGroupChange: (id) {
                final color = MarkConstant.colorList.firstWhere(
                  (color) => color.toARGB32().toString() == id,
                );
                onColorSelected(color);
              },
              directionalTdRadios: [
                ...MarkConstant.colorList.map(
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
          ],
        ),
      ),
    );
  }
}
