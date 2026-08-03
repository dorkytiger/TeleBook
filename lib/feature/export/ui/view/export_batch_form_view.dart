import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/model/export_item.dart';
import 'package:tele_book/feature/export/ui/provider/export_batch_provider.dart';

class ExportBatchFormView extends ConsumerStatefulWidget {
  final List<BookTableData> books;


  const ExportBatchFormView({super.key, required this.books});

  @override
  ConsumerState<ExportBatchFormView> createState() =>
      _ExportBatchFormViewState();
}

class _ExportBatchFormViewState extends ConsumerState<ExportBatchFormView> {
  final _formKey = GlobalKey<FormState>();
  late final List<int> _bookIds;

  @override
  void initState() {
    super.initState();
    _bookIds = widget.books.map((b) => b.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      exportBatchProvider(_bookIds),
    );
    final notifier = ref.read(
      exportBatchProvider(_bookIds).notifier,
    );

    ref.listen(exportBatchProvider(_bookIds), (
      prev,
      next,
    ) {
      if (prev?.isDone == false && next.isDone) {
        showFToast(
          context: context,
          icon: const Icon(FLucideIcons.check),
          title: const Text('导出成功'),
          description: Text('全部 ${next.items.length} 本书已导出'),
          swipeToDismiss: const [.right],
          duration: const Duration(seconds: 3),
        );
        Navigator.of(context).pop();
      }
    });

    return FScaffold(
      header: FHeader.nested(
        title: Text('批量导出（${state.items.length} 本）'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // 顶部设置区
            Padding(
              padding: .all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 导出格式
                  FSelect<ExportFormat>.rich(
                    control: FSelectControl.managed(
                      onChange: (value) {
                        if (value != null) notifier.setFormat(value);
                      },
                      initial: state.format,
                    ),
                    label: Text("导出格式"),
                    hint: "请选择导出格式",
                    format: (s) => s.label,
                    children: [
                      for (final format in ExportFormat.values)
                        .item(title: Text(format.label), value: format),
                    ],
                    validator: (v) => (v == null) ? '请选择导出格式' : null,
                  ),
                  const SizedBox(height: 12),

                  // 导出路径
                  FTextFormField(
                    readOnly: true,
                    control: FTextFieldControl.managed(
                      controller: state.outputPathController,
                    ),
                    label: Text('导出路径'),
                    hint: '请选择导出目录',
                    suffixBuilder: (context, style, variants) {
                      return FButton.icon(
                        style: style.obscureButtonStyle,
                        onPress: state.isExporting
                            ? null
                            : () => notifier.pickOutputDir(),
                        child: Icon(FLucideIcons.folderOpen),
                      );
                    },
                    validator: (v) => (v?.isEmpty ?? true) ? '请选择路径' : null,
                    onTap: state.isExporting
                        ? null
                        : () => notifier.pickOutputDir(),
                  ),
                  // 进度条
                  if (state.isExporting) ...[
                    const SizedBox(height: 12),
                    FDeterminateProgress(
                      value: state.items.isNotEmpty
                          ? state.progress / state.items.length
                          : 0,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '正在导出 ${state.progress} / ${state.items.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),

            const Divider(height: 1),

            // 导出项列表
            Expanded(
              child: FItemGroup.builder(
                count: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return FItem(
                    prefix: LocalImageWidget(imagePath: item.coverPath),
                    title: Text(
                      item.book.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('${item.book.localSubPaths.length} 页'),
                    suffix: FButton.icon(
                      variant: .ghost,
                      onPress: () => _editFileName(context, item),
                      child: const Icon(FLucideIcons.pencil),
                    ),
                  );
                },
              ),
            ),

            // 底部导出按钮
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FButton(
                  onPress: state.isExporting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            notifier.doExport();
                          }
                        },
                  prefix: state.isExporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload),
                  child: Text(state.isExporting ? '导出中...' : '开始批量导出'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editFileName(BuildContext context, ExportItem item) {
    showFDialog(
      context: context,
      builder: (dialogContext, style, animate) => FDialog.adaptive(
        style: style,
        animation: animate,
        horizontalBuilder: (context, dStyle) => Padding(
          padding: .all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('编辑导出文件名', style: dStyle.titleTextStyle),
              const SizedBox(height: 12),
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: item.nameController,
                ),
                label: Text('导出文件名'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FButton(
                    variant: .outline,
                    onPress: () => Navigator.of(dialogContext).pop(),
                    child: Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  FButton(
                    onPress: () => Navigator.of(dialogContext).pop(),
                    child: Text('确定'),
                  ),
                ],
              ),
            ],
          ),
        ),
        verticalBuilder: (context, dStyle) => Padding(
          padding: .all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('编辑导出文件名', style: dStyle.titleTextStyle),
              const SizedBox(height: 12),
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: item.nameController,
                ),
                label: Text('导出文件名'),
              ),
              const SizedBox(height: 16),
              FButton(
                onPress: () => Navigator.of(dialogContext).pop(),
                child: Text('确定'),
              ),
              const SizedBox(height: 8),
              FButton(
                variant: .outline,
                onPress: () => Navigator.of(dialogContext).pop(),
                child: Text('取消'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
