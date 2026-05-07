import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/viewmodel/book_form_viewmodel.dart';

class BookFormView extends StatelessWidget {
  final BookTableData book;

  const BookFormView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookFormViewmodel(book, context.read()),
      child: _BookFormViewContent(),
    );
  }
}

class _BookFormViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookFormViewmodel>();
    return Scaffold(
      appBar: AppBar(title: Text("编辑书籍")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: vm.titleController,
              decoration: InputDecoration(labelText: "书籍名称"),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              onReorder: vm.reorderImages,
              itemCount: vm.imagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = vm.imagePaths[index];
                return Padding(
                  key: ObjectKey(imagePath),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: LocalImageWidget(imagePath: imagePath.fullPath),
                    title: Text("图片 ${index + 1}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            vm.deleteImage(imagePath);
                          },
                        ),
                        ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.drag_handle),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                vm.updateBook(context);
              },
              child: Text("保存"),
            ),
          ),
        ],
      ),
    );
  }
}
