import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_event_get.dart';
import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/extend/rx_extend.dart';

class CollectionController extends GetxController {
  final collectionNameController = TextEditingController();
  final selectedCollectionId = Rx<int?>(null);
  final selectedCollectionIconData = Rx<IconData?>(null);
  final selectedCollectionColor = Rx<Color?>(null);
  final getCollectionState = Rx<DKStateQuery<List<CollectionTableData>>>(
    DkStateQueryIdle(),
  );
  final addCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final editCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final deleteCollectionState = Rx<DKStateEvent<void>>(DKStateEventIdle());
  final appDatabase = Get.find<AppDatabase>();

  @override
  void onInit() {
    super.onInit();
    addCollectionState.listenEventToast(
      onSuccess: (_) {
        collectionNameController.clear();
        getCollections();
        Get.back();
      },
    );
    editCollectionState.listenEventToast(
      onSuccess: (_) {
        collectionNameController.clear();
        getCollections();
        Get.back();
      },
    );
    deleteCollectionState.listenEventToast(
      onSuccess: (_) {
        getCollections();
        Get.back();
      },
    );

    getCollections();
  }

  void initFormData(CollectionTableData collection) {
    selectedCollectionId.value = collection.id;
    collectionNameController.text = collection.name;
    selectedCollectionColor.value =
        Color(collection.color);
    selectedCollectionIconData.value =
        IconData(collection.icon, fontFamily: 'MaterialIcons');
  }

  void clearFormData() {
    selectedCollectionId.value = null;
    collectionNameController.clear();
    selectedCollectionColor.value = null;
    selectedCollectionIconData.value = null;
  }

  Future<void> getCollections() async {
    await getCollectionState.triggerQuery(
      query: () async {
        final query = appDatabase.collectionTable.select()
          ..orderBy([
            (t) => OrderingTerm(expression: t.order, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]);
        final collections = await query.get();
        return collections;
      },
      isEmpty: (result) => result.isEmpty,
    );
  }

  Future<void> addCollection() async {
    await addCollectionState.triggerEvent(
      event: () async {
        if (selectedCollectionColor.value == null) {
          throw Exception("请选择颜色");
        }
        if (selectedCollectionIconData.value == null) {
          throw Exception("请选择图标");
        }

        await appDatabase
            .into(appDatabase.collectionTable)
            .insert(
              CollectionTableCompanion.insert(
                id: Value.absent(),
                name: collectionNameController.text,
                color: selectedCollectionColor.value!.toARGB32(),
                icon: selectedCollectionIconData.value!.codePoint,
                createdAt: Value(DateTime.now()),
              ),
            );
      },
    );
  }

  Future<void> editCollection() async {
    await editCollectionState.triggerEvent(
      event: () async {
        if (selectedCollectionId.value == null) {
          throw Exception("收藏夹ID不能为空");
        }
        if (selectedCollectionColor.value == null) {
          throw Exception("请选择颜色");
        }
        if (selectedCollectionIconData.value == null) {
          throw Exception("请选择图标");
        }

        await appDatabase
            .update(appDatabase.collectionTable)
            .replace(
              CollectionTableData(
                id: selectedCollectionId.value!,
                name: collectionNameController.text,
                color: selectedCollectionColor.value!.toARGB32(),
                icon: selectedCollectionIconData.value!.codePoint,
                order: 0,
                createdAt: DateTime.now(),
              ),
            );
      },
    );
  }

  Future<void> deleteCollection(int id) async {
    await deleteCollectionState.triggerEvent(
      event: () async {
        await (appDatabase.delete(
          appDatabase.collectionTable,
        )..where((tbl) => tbl.id.equals(id))).go();
        await (appDatabase.delete(
          appDatabase.collectionBookTable,
        )..where((tbl) => tbl.collectionId.equals(id))).go();
      },
    );
  }
}
