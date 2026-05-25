import 'package:tele_book/core/db/app_database.dart';

class CollectionListItemVo {
  final CollectionTableData collection;
  final int count;

  CollectionListItemVo({
    required this.collection,
    required this.count,
  });
}