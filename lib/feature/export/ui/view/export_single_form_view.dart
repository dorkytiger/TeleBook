import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/common/config/global_config.dart';
import 'package:tele_book/common/widget/local_image_widget.dart';
import 'package:tele_book/core/db/app_database.dart';
import 'package:tele_book/feature/export/enum/export_format.dart';
import 'package:tele_book/feature/export/ui/provider/export_single_provider.dart';

class ExportSingleFormView extends ConsumerStatefulWidget {
  final BookTableData book;

  const ExportSingleFormView({super.key, required this.book});

  @override
  ConsumerState<ExportSingleFormView> createState() =>
      _ExportSingleFormViewState();
}

class _ExportSingleFormViewState extends ConsumerState<ExportSingleFormView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bookId = widget.book.id;
    final state = ref.watch(exportSingleProvider(bookId));
    final notifier = ref.read(exportSingleProvider(bookId).notifier);

    ref.listen(exportSingleProvider(bookId), (prev, next) {
      if (prev?.isDone == false && next.isDone) {
        showFToast(
          context: context,
          icon: const Icon(FLucideIcons.check),
          title: const Text('导出成功'),
          description: Text('${state.book.name} 已导出'),
          swipeToDismiss: const [.right],
          duration: const Duration(seconds: 3),
        );
        Navigator.of(context).pop();
      }
    });

    return FScaffold(
      header: FHeader.nested(
        title: const Text('导出书籍'),
        prefixes: [FHeaderAction.back(onPress: () => context.pop())],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FLabel(
                layout: .horizontalTrailing,
                label: Text(state.book.name),
                description: Text('共 ${state.book.localSubPaths.length} 页'),
                child: LocalImageWidget(
                  imagePath: GlobalConfig.resolveBookPath(
                    state.book.coverSubPath!,
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),

              // 导出格式
              FSelect<ExportFormat>.rich(
                control: FSelectControl.managed(
                  onChange: (value) {
                    if (value != null) notifier.setFormat(value);
                  },
                ),
                label: Text("导出格式"),
                hint: "请选择导出格式",
                format: (s) => s.label,
                children: [
                  for (final format in ExportFormat.values)
                    .item(title: Text(format.label), value: format),
                ],
              ),
              const SizedBox(height: 16),

              // 导出路径
              FTextFormField(
                readOnly: true,
                control: FTextFieldControl.managed(
                  controller: state.outputPathCrl,
                ),
                validator: (v) => (v == null || v.isEmpty) ? '请选择导出目录' : null,
                label: Text('导出路径'),
                hint: '请选择导出目录',
                suffixBuilder: (context, style, variants) {
                  return FButton.icon(
                    style: style.obscureButtonStyle,
                    onPress: () => notifier.pickOutputDir(),
                    child: Icon(FLucideIcons.fileOutput),
                  );
                },
                onTap: () => notifier.pickOutputDir(),
              ),
              const SizedBox(height: 16),

              // 导出文件名
              FTextFormField(
                control: FTextFieldControl.managed(
                  controller: state.fileNameCrl,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '请输入文件名' : null,
                enabled: !state.isExporting,
                label: Text('导出文件名'),
                hint: "请输入导出文件名",
              ),
              const SizedBox(height: 8),

              const Spacer(),

              // 导出按钮
              FButton(
                onPress: () {
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
                child: Text(state.isExporting ? '导出中...' : '开始导出'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
