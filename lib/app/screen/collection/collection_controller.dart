import 'package:dk_util/dk_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/store/collection_store.dart';

class CollectionController extends ChangeNotifier {
  final CollectionStore collectionStore;
  bool isEditMode = false;
  DKStateEvent<void> saveState = DKStateEventIdle();
  DKStateEvent<void> deleteState = DKStateEventIdle();

  List<CollectionTableData> get collections => collectionStore.collections;

  CollectionController({required this.collectionStore}) {
    collectionStore.addListener(_onCollectionStoreChanged);
  }

  void _onCollectionStoreChanged() {
    notifyListeners();
  }

  void toggleEditMode() {
    isEditMode = !isEditMode;
    notifyListeners();
  }

  void showCollectionBooks(CollectionTableData collection,
      BuildContext context,) {
    context.pushNamed(
      AppRoute.bookFilter,
      pathParameters: {'collectionId': collection.id.toString()},
    );
  }

  Future<void> saveCollection(BuildContext context,
      int? id,
      String name,
      String? description,) async {
    await DKStateEventHelper.triggerEvent(
        onStateChange: (value) {
          saveState = value;
          notifyListeners();
        }, event: () =>
        collectionStore.saveCollection(
          name: name,
          description: description,
          id: id,
        ));
  }

  Future<void> deleteCollection(BuildContext context, int id) async {
    await DKStateEventHelper.triggerEvent(
        onStateChange: (value) {
          deleteState = value;
          notifyListeners();
        }, event: () =>
        collectionStore.deleteCollection(id));
  }
}
