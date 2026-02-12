import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'import_controller.dart';

class ImportScreen extends GetView<ImportController> {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
          body: Center(child: Text('Import Screen')),
          );
  }
}