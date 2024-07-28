import 'package:flutter/cupertino.dart';

Widget actionButtonWidget({
  required String title,
  required IconData icon,
  required Color iconColor,
  required Color textColor,
  required Function() onPressed,
}) {
  return CupertinoButton(
    onPressed: onPressed,
    padding: const EdgeInsets.all(0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}
