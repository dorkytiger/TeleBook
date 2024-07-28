import 'package:flutter/material.dart';
import 'package:path/path.dart';

Widget deleteButtonWidget(BuildContext context, Function onDelete) {
  return TextButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('确认删除'),
              content: const Text(
                '确定要删除选中的项吗？',
                style: TextStyle(color: Colors.black54),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '取消',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '确定',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          });
    },
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.delete,
          color: Colors.red,
        ),
        Text(
          "删除",
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    ),
  );
}