import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
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

    return FScaffold(
      header: FHeader.nested(
        title: Text("编辑书籍"),
        prefixes: [
          FHeaderAction.back(
            onPress: () {
              context.pop();
            },
          ),
        ],
      ),
      child: formState.when(
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

          return Padding(
            padding: .all(16),

            child: Column(
              crossAxisAlignment: .start,
              children: [
                FTextFormField(
                  control: FTextFieldControl.managed(
                    controller: formNotifier.titleController,
                  ),
                  label: Text("书籍名称"),
                  hint: "请输入书籍名称",
                ),
                const SizedBox(height: 16),
                Text(
                  "图片排序",
                  style: context.theme.typography.body.xs.copyWith(
                    fontWeight: .w500,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ReorderableListView.builder(
                    onReorderItem: formNotifier.reorderImages,
                    itemCount: formState.imagePaths.length,
                    itemBuilder: (context, index) {
                      final imagePath = formState.imagePaths[index];
                      return Padding(
                        key: ObjectKey(imagePath),
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: FItem(
                          prefix: LocalImageWidget(
                            imagePath: imagePath.fullPath,
                          ),
                          title: Text("图片 ${index + 1}"),
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FButton.icon(
                                variant: .ghost,
                                onPress: () {
                                  formNotifier.deleteImage(imagePath);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: context.theme.colors.destructive,
                                ),
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),

                  child: FButton(
                    onPress: isSubmitting
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
            ),
          );
        },
      ),
    );
  }
}
