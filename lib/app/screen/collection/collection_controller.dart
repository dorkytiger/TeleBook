import 'package:get/get.dart' hide Value;
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/route/app_route.dart';
import 'package:tele_book/app/service/collection_servcie.dart';

class CollectionController extends GetxController {
  final collectionService = Get.find<CollectionService>();
  final isEditMode = false.obs;

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void showCollectionBooks(CollectionTableData collection) {
    Get.toNamed(
      AppRoute.bookFilter,
      arguments: {'collectionId': collection.id},
    );
  }
}
