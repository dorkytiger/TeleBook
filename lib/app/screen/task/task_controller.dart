import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskController extends GetxController with GetSingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
}