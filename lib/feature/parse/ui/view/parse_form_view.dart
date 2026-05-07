import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/feature/parse/ui/viewmodel/parse_form_viewmodel.dart';

class ParseFormView extends StatelessWidget {
  const ParseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParseFormViewmodel(),
      child: const _ParseFormContent(),
    );
  }
}

class _ParseFormContent extends StatefulWidget {
  const _ParseFormContent();

  @override
  State<_ParseFormContent> createState() => _ParseFormContentState();
}

class _ParseFormContentState extends State<_ParseFormContent> {
  @override
  Widget build(BuildContext context) {
    // 读取 viewmodel，用 watch 会在 vm 调用 notifyListeners() 时重建本 Widget
    final vm = context.watch<ParseFormViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text("解析表单")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<ParseFormType>(
                  width: constraints.maxWidth,
                  initialSelection: vm.type,
                  decorationBuilder: (context, state) {
                    return const InputDecoration(
                      labelText: "选择解析来源",
                      prefixIcon: Icon(Icons.source),

                      border: OutlineInputBorder(),
                    );
                  },
                  menuStyle: MenuStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: ParseFormType.web,
                      label: "网页",
                      leadingIcon: Icon(Icons.web),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.archive,
                      label: "压缩包",
                      leadingIcon: Icon(Icons.archive),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.batchArchive,
                      label: "批量压缩包",
                      leadingIcon: Icon(Icons.batch_prediction),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.imageFolder,
                      label: "文件夹",
                      leadingIcon: Icon(Icons.photo_library),
                    ),
                    DropdownMenuEntry(
                      value: ParseFormType.batchImageFolder,
                      label: "批量文件夹",
                      leadingIcon: Icon(Icons.folder_copy),
                    ),
                  ],
                  onSelected: (value) {
                    vm.setType(value);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSubForm(context, vm.type), // 根据选择的类型显示不同的表单
            Spacer(),
            FilledButton(
              onPressed: () {
                vm.onParse(context);
              },
              child: const Text("解析"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubForm(BuildContext context, ParseFormType type) {
    switch (type) {
      case ParseFormType.web:
        return _buildWebForm(context, context.read<ParseFormViewmodel>());
      case ParseFormType.archive:
        return _buildArchiveForm(context, context.read<ParseFormViewmodel>());
      case ParseFormType.batchArchive:
        return _buildBatchArchiveForm(
          context,
          context.read<ParseFormViewmodel>(),
        );
      case ParseFormType.imageFolder:
        return _buildImageFolderForm(
          context,
          context.read<ParseFormViewmodel>(),
        );
      case ParseFormType.batchImageFolder:
        return _buildBatchImageFolderForm(
          context,
          context.read<ParseFormViewmodel>(),
        );
    }
  }

  Widget _buildWebForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.urlController,
      // 推荐把 controller 放到 vm 并在 dispose 里释放
      decoration: InputDecoration(
        labelText: "输入文本",
        prefixIcon: const Icon(Icons.web),
        suffixIcon: IconButton(
          onPressed: () {
            vm.getClipboardUrl();
          },
          icon: const Icon(Icons.paste),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildArchiveForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.archivePathController,
      // 推荐把 controller 放到 vm 并在 dispose 里释放
      decoration: InputDecoration(
        labelText: "请选择压缩包文件",
        prefixIcon: const Icon(Icons.archive),
        suffixIcon: IconButton(
          onPressed: () {
            vm.pickerArchive(context);
          },
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchArchiveForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.batchArchivePathController,
      // 推荐把 controller 放到 vm 并在 dispose 里释放
      decoration: InputDecoration(
        labelText: "请选择压缩包文件夹",
        prefixIcon: const Icon(Icons.folder),
        suffixIcon: IconButton(
          onPressed: () {
            vm.pickerBatchArchive(context);
          },
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImageFolderForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.imageFolderPathController,
      decoration: InputDecoration(
        labelText: "请选择图片文件夹",
        prefixIcon: const Icon(Icons.photo_library),
        suffixIcon: IconButton(
          onPressed: () {
            vm.pickerImageFolder(context);
          },
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBatchImageFolderForm(
    BuildContext context,
    ParseFormViewmodel vm,
  ) {
    return TextField(
      controller: vm.batchImageFolderPathController,
      decoration: InputDecoration(
        labelText: "请选择批量图片文件夹父目录",
        prefixIcon: const Icon(Icons.folder_copy),
        suffixIcon: IconButton(
          onPressed: () {
            vm.pickerBatchImageFolder(context);
          },
          icon: const Icon(Icons.folder_open),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
