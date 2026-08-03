import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,

                children: [
                  Text('发生错误',style: context.theme.typography.body.xl2.copyWith(
                    fontWeight: .w600,
                    color: context.theme.colors.error,
                    height: 1.5
                  ),),
                  SizedBox(height: 8),
                  Text('$errorMessage',style: context.theme.typography.body.sm.copyWith(
                    color: context.theme.colors.destructive
                  ),),
                  SizedBox(height: 8),
                  if (stackTrace != null)
                    FButton(
                      onPress: () {
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
                ],
              ),
            ),
          ),

          SizedBox(height: 8),
          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: Text('重试')),
        ],
      ),
    );
  }
}
