import 'package:flutter/cupertino.dart';

class TDCellImageIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color color;

  const TDCellImageIconWidget({
    super.key,
    required this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 32,
      width: 32,
      child: Icon(iconData, color: color, size: 24),
    );
  }
}
