import 'package:flutter/material.dart';
import 'package:tele_book/app/constant/mark_constant.dart';

class MarkEditFormWidget extends StatelessWidget {
  final Function onConfirm;
  final Function onCancel;
  final TextEditingController markNameController;
  final Color selectedColor;
  final Function(Color color) onColorSelected;
  final ScrollController scrollController;

  const MarkEditFormWidget({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.markNameController,
    required this.selectedColor,
    required this.onColorSelected,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text("标签名称"),
            TextField(
              controller: markNameController,
              decoration: InputDecoration(
                hintText: "请输入标签名称",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Text("标签颜色"),
            // TDRadioGroup(
            //   cardMode: true,
            //   direction: Axis.horizontal,
            //   rowCount: 5,
            //   selectId: selectedColor.toARGB32().toString(),
            //   onRadioGroupChange: (id) {
            //     final color = MarkConstant.colorList.firstWhere(
            //       (color) => color.toARGB32().toString() == id,
            //     );
            //     onColorSelected(color);
            //   },
            //   directionalTdRadios: [
            //     ...MarkConstant.colorList.map(
            //       (color) => TDRadio(
            //         id: color.toARGB32().toString(),
            //         cardMode: true,
            //         backgroundColor: color,
            //         customContentBuilder: (context, selected, text) {
            //           return selected
            //               ? Icon(Icons.check, color: Colors.white)
            //               : SizedBox.shrink();
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(

                onPressed: () {
                  onConfirm();
                  Navigator.of(context).pop();
                },
                label: Text("确认"),
                icon: Icon(Icons.check),
              ),
            )
          ],
        ),
      ),
    );
  }
}
