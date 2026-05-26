import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tele_book/common/widget/error_widget.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/book/ui/provider/book_form_provider.dart';

class BookFormView extends ConsumerWidget {
  final BookTableData book;

  const BookFormView({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(bookFormProvider(book.id));
    final submitState = ref.watch(bookFormSubmitProvider);

    ref.listen(bookFormSubmitProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (next.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("保存失败: ${next.error}")));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("保存成功")));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("编辑书籍")),
      body: formState.when(
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            errorMessage: error.toString(),
            stackTrace: stack,
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        data: (formState) {
          final formNotifier = ref.read(bookFormProvider(book.id).notifier);
          final isSubmitting = submitState.isLoading;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: formNotifier.titleController,
                  decoration: InputDecoration(labelText: "书籍名称"),
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  onReorder: formNotifier.reorderImages,
                  itemCount: formState.imagePaths.length,
                  itemBuilder: (context, index) {
                    final imagePath = formState.imagePaths[index];
                    return Padding(
                      key: ObjectKey(imagePath),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: LocalImageWidget(
                          imagePath: imagePath.fullPath,
                        ),
                        title: Text("图片 ${index + 1}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                formNotifier.deleteImage(imagePath);
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
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final success = await ref
                              .read(bookFormSubmitProvider.notifier)
                              .submit(
                                bookId: book.id,
                                title: formState.title,
                                imagePaths: formState.imagePaths,
                              );
                          if (success && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                  child: isSubmitting
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text("保存"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
