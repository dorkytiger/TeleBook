import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class TDFormItemTitle extends StatelessWidget {
  final String label;
  final bool? required;

  const TDFormItemTitle({super.key, required this.label, this.required});

  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          required != null && required!
              ? TDText(
                  "*",
                  textColor: TDTheme.of(context).errorNormalColor,
                  font: TDTheme.of(context).fontBodyMedium,
                )
              : SizedBox.shrink(),
          TDText(label, font: TDTheme.of(context).fontBodyMedium),
        ],
    );
  }
}
