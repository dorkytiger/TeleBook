import 'package:flutter/material.dart';
import 'package:tele_book/app/store/mark_store.dart';

class MarkController extends ChangeNotifier {
  final MarkStore markStore;

  final markNameController = TextEditingController();
  final markDescriptionController = TextEditingController();
  String? markNameError;

  MarkController({required this.markStore}) {
    markStore.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => notifyListeners();

  bool validateMarkName() {
    final name = markNameController.text.trim();
    if (name.isEmpty) {
      markNameError = '标签名称不能为空';
      notifyListeners();
      return false;
    }
    markNameError = null;
    notifyListeners();
    return true;
  }

  void resetMarkForm() {
    markNameController.clear();
    markDescriptionController.clear();
    markNameError = null;
    notifyListeners();
  }

  Future<void> saveMark({int? id, required String name, String? description}) {
    return markStore.saveMark(id: id, name: name, description: description);
  }

  Future<void> deleteMark(int id) {
    return markStore.deleteMark(id);
  }

  @override
  void dispose() {
    markStore.removeListener(_onStoreChanged);
    markNameController.dispose();
    markDescriptionController.dispose();
    super.dispose();
  }
}

class MarkFormData {
  final int? id;
  final String name;
  final String? description;

  MarkFormData({this.id, required this.name, this.description});
}
