import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/constant/mark_constant.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/service/mark_service.dart';

class MarkController extends GetxController {
  final db = Get.find<AppDatabase>();
  final markService = Get.find<MarkService>();
  final markNameController = TextEditingController();
  final selectedMarkColor = Rx<Color>(MarkConstant.colorList.first);


  @override
  void onInit() {
    super.onInit();
  }
}

class MarkFormData{
  final int? id;
  final String name;
  final int color;

  MarkFormData({
    this.id,
    required this.name,
    required this.color,
  });
}