import 'package:dk_util/state/dk_state_query_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'mark_controller.dart';

class MarkScreen extends GetView<MarkController> {
  const MarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: "书签管理"),
      body: controller.getMarkListState.display(
        emptyBuilder: () {
          return TDEmpty();
        },
        loadingBuilder: () => const Center(child: CircularProgressIndicator()),
        successBuilder: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final mark = data[index];
            return ListTile(
              title: Text(mark.name),
              subtitle: Text('ID: ${mark.id}'),
            );
          },
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
