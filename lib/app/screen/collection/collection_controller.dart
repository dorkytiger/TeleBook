import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/constant/collection_constant.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/collection_servcie.dart';

class CollectionController extends GetxController {
  final collectionService = Get.find<CollectionService>();
  final isEditMode = false.obs;

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void showCollectionBooks(CollectionTableData collection) {
    Get.toNamed(AppRoute.book, arguments: {'collectionId': collection.id});
  }
}
