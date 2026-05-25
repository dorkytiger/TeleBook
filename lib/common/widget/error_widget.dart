import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    Key? key,
    this.errorMessage,
    this.stackTrace,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('发生错误: $errorMessage'),
          SizedBox(height: 8),
          if (stackTrace != null)
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('错误详情'),
                    content: SingleChildScrollView(
                      child: Text(stackTrace.toString()),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('关闭'),
                      ),
                    ],
                  ),
                );
              },
              child: Text("查看详情"),
            ),
          SizedBox(height: 8),
          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: Text('重试')),
        ],
      ),
    );
  }
}
