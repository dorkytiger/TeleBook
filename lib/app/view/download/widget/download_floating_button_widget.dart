import 'package:flutter/material.dart';

class DownloadFloatingButtonWidget extends StatelessWidget {
  final TextEditingController urlController;

  final void Function() onConfirm;

  const DownloadFloatingButtonWidget(
      {super.key, required this.urlController, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        urlController.clear();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  '请输入链接',
                  style: TextStyle(color: Colors.black54),
                ),
                content: SizedBox(
                  child: TextField(
                      controller: urlController,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: '输入',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        isDense: true,
                      )),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      '取消',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      '确定',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop(); // 关闭对话框并返回输入的文本
                    },
                  ),
                ],
              );
            });
      },
      tooltip: 'Increment',
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
