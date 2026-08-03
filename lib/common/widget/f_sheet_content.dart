import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class FSheetContent extends StatelessWidget {
  final FLayout side;
  final Widget child;

  const FSheetContent({super.key, required this.side, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: side.vertical
            ? .symmetric(
                horizontal: BorderSide(color: context.theme.colors.border),
              )
            : .symmetric(
                vertical: BorderSide(color: context.theme.colors.border),
              ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 15, vertical: 8.0),
        child: child,
      ),
    );
  }

  static Widget drag() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  static Widget title(BuildContext context, String title) {
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
