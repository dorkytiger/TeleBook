import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class TdCellGroupTitleWidget extends StatelessWidget {
  final String title;

  const TdCellGroupTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return TDText(
      title,
      font: TDTheme.of(context).fontBodyMedium,
      textColor: TDTheme.of(context).fontGyColor3,
    );
  }
}
