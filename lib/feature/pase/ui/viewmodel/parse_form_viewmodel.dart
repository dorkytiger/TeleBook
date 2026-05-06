import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/core/route/app_route.dart';

class ParseFormViewmodel extends ChangeNotifier {
  ParseFormType type = ParseFormType.web;
  final TextEditingController urlController = TextEditingController();

  void setType(ParseFormType? newType) {
    if (newType != null) {
      type = newType;
      notifyListeners();
    }
  }

  void onParse(BuildContext context) {
    switch (type) {
      case ParseFormType.web:
        context.push(AppRoute.parseWeb, extra: urlController.text);
        break;
      default:
        break;
    }
  }
}

enum ParseFormType { web, archive, batchArchive }
