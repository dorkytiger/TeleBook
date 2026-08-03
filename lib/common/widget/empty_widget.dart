import 'package:flutter/cupertino.dart';

class CustomEmptyWidget extends StatelessWidget {
  final IconData? icon;
  final String? text;

  const CustomEmptyWidget({super.key, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Icon(
          icon ?? CupertinoIcons.infinite,
          size: 60,
          color: CupertinoColors.systemGrey,
        ),
        SizedBox(height: 20),
        Text(
          text ?? "暂无数据",
          style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
        ),
      ],
    );
  }
}
