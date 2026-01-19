import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tele_book/app/db/app_database.dart';
import 'package:tele_book/app/screen/collection/screen/book/collection_book_controller.dart';
import 'package:tele_book/app/util/request_state.dart';

class CollectionBookScreen extends GetView<CollectionBookController> {
  const CollectionBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: "收藏书籍"),
      body: Obx(
        () => DisplayResult(
          state: controller.getCollectionBooksState.value,
          onSuccess: (data) {
            return _buildBooksGrid(data);
          },
        ),
      ),
    );
  }

  Widget _buildBooksGrid(List<BookTableData> data) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final book = data[index];
        return Image.file(
          File("${controller.appDirectory}/${book.localPaths.first}"),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
