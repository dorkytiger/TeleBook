import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class TDActionSheetItemIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color? bgColor;
  final Color? iconColor;

  const TDActionSheetItemIconWidget({
    super.key,
    required this.iconData,
    this.bgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = this.bgColor ?? TDTheme.of(context).brandNormalColor;
    final iconColor = this.iconColor ?? TDTheme.of(context).whiteColor1;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      padding: EdgeInsets.all(8),
      child: Icon(iconData, color: iconColor),
    );
  }
}
