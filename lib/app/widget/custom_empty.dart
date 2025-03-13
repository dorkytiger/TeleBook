import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CustomEmpty extends StatelessWidget {
  const CustomEmpty({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return TDEmpty(
        emptyText: message,
    );
  }
}