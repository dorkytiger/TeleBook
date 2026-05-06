import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/feature/pase/ui/viewmodel/parse_form_viewmodel.dart';

class ParseFormView extends StatelessWidget {
  const ParseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    // 页面级 provider：ParseFormViewmodel 生命周期与页面绑定（页面 pop 时会自动 dispose）
    return ChangeNotifierProvider(
      create: (_) => ParseFormViewmodel(),
      child: const _ParseFormContent(), // 子 Widget 为 provider 的 descendant
    );
  }
}

// 子 Widget：真正的 UI，且可以在 initState 中安全地读取 provider
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
      appBar: AppBar(title: const Text("解析表单"),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownMenu<ParseFormType>(
              width: double.infinity,
              decorationBuilder: (context, state) {
                return InputDecoration(
                  labelText: "选择解析来源",
                  prefixIcon: const Icon(Icons.source),
                  border: OutlineInputBorder(),
                );
              },
              menuStyle: MenuStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: ParseFormType.web, label: "网页"),
                DropdownMenuEntry(value: ParseFormType.archive, label: "压缩包"),
                DropdownMenuEntry(
                  value: ParseFormType.batchArchive,
                  label: "批量压缩包",
                ),
              ],
              // 当你想把选中值保存到 vm 时，使用 onSelected 或类似回调
              onSelected: (value) {
                vm.setType(value);
              },
            ),
            const SizedBox(height: 16),
            _buildSubForm(context, vm.type), // 根据选择的类型显示不同的表单
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                vm.onParse(context);
              },
              child: const Text("解析"),
            ),
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
        return const Text("压缩包表单");
      case ParseFormType.batchArchive:
        return const Text("批量压缩包表单");
    }
  }

  Widget _buildWebForm(BuildContext context, ParseFormViewmodel vm) {
    return TextField(
      controller: vm.urlController,
      // 推荐把 controller 放到 vm 并在 dispose 里释放
      decoration: const InputDecoration(
        labelText: "输入文本",
        prefixIcon: Icon(Icons.web),
        border: OutlineInputBorder(),
      ),
    );
  }
}
