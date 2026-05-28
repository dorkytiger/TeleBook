import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadFormBottomSheetWidget extends ConsumerStatefulWidget {
  const DownloadFormBottomSheetWidget({super.key});

  @override
  ConsumerState<DownloadFormBottomSheetWidget> createState() => _DownloadFormBottomSheetState();
}

class _DownloadFormBottomSheetState extends ConsumerState<DownloadFormBottomSheetWidget> {
  // 将控制器绑定到 State 的生命周期中
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    // 规范：在此处安全销毁，当 BottomSheet 彻底消失在屏幕上时触发
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 处理键盘避让
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "添加下载任务",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "下载链接",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
                suffixIcon: IconButton(
                  onPressed: () async {
                    final clipData = await Clipboard.getData(Clipboard.kTextPlain);
                    if (clipData != null && clipData.text != null) {
                      _urlController.text = clipData.text!;
                    }
                  },
                  icon: const Icon(Icons.paste),
                ),
              ),
              keyboardType: TextInputType.url,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final inputUrl = _urlController.text.trim();
                  // 规范：直接使用当前组件的 context 返回数据
                  Navigator.of(context).pop(inputUrl);
                },
                child: const Text("添加"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
