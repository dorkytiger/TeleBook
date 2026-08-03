import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';

class FText {
static  Widget title(BuildContext context,String title){
    return Text(
      title,
      style: context.theme.typography.display.xl2.copyWith(
        fontWeight: .w600,
        color: context.theme.colors.foreground,
        height: 1.5,
      ),
    );
  }

  static Widget subTitle(BuildContext context, String subTitle) {
    return Text(
      subTitle,
      style: context.theme.typography.body.sm.copyWith(
        color: context.theme.colors.mutedForeground,
      ),
    );
  }
}