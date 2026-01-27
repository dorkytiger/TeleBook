import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mark_controller.dart';

class MarkScreen extends GetView<MarkController> {
  const MarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Mark Screen')));
  }
}
