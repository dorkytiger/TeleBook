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
  final getMarkListState = Rx<DKStateQuery<List<MarkTableData>>>(
    DkStateQueryIdle(),
  );
  final addMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final updateMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final deleteMarkState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final markNameController = TextEditingController();
  final selectedMarkColor = Rx<Color>(MarkConstant.colorList.first);
  final db = Get.find<AppDatabase>();
  final markService = Get.find<MarkService>();

  @override
  void onInit() {
    super.onInit();
    addMarkState.listenEvent(
      onSuccess: (_) {
        getMarkList();
        markNameController.clear();
        Get.back();
      },
    );
    updateMarkState.listenEvent(
      onSuccess: (_) {
        getMarkList();
        markNameController.clear();
        Get.back();
      },
    );
    deleteMarkState.listenEvent(
      onSuccess: (_) {
        getMarkList();
        Get.back();
      },
    );
    getMarkList();
  }

  Future<void> getMarkList() async {
    getMarkListState.triggerQuery(
      query: () async {
        return db.markTable.select().get();
      },
      isEmpty: (data) => data.isEmpty,
    );
  }

  Future<void> addMark() async {
    await addMarkState.triggerEvent(
      event: () async {
        final markCompanion = MarkTableCompanion(
          name: Value(markNameController.text),
          color: Value(selectedMarkColor.value.value),
        );
        await db.markTable.insertOnConflictUpdate(markCompanion);
      },
    );
  }

  Future<void> updateMark(int markId) async {
    await updateMarkState.triggerEvent(
      event: () async {
        final markCompanion = MarkTableCompanion(
          id: Value(markId),
          name: Value(markNameController.text),
          color: Value(selectedMarkColor.value.value),
        );
        await db.markTable.insertOnConflictUpdate(markCompanion);
      },
    );
  }

  Future<void> deleteMark(int markId) async {
    await deleteMarkState.triggerEvent(
      event: () async {
        await (db.markTable.delete()..where((tbl) => tbl.id.equals(markId)))
            .go();
        await (db.markBookTable.delete()
              ..where((tbl) => tbl.markId.equals(markId)))
            .go();
      },
    );
  }

  void initFormData(MarkTableData mark) {
    markNameController.text = mark.name;
    selectedMarkColor.value = Color(mark.color);
  }

  void clearFormData() {
    markNameController.clear();
    selectedMarkColor.value = MarkConstant.colorList.first;
  }
}
