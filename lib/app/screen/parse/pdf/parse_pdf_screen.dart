import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tele_book/app/extend/rx_extend.dart';
import 'package:tele_book/app/screen/parse/pdf/parse_pdf_controller.dart';
import 'package:tele_book/app/widget/custom_loading.dart';

/// 离屏超过此页数时释放内存
const _kReleaseThreshold = 5;

class ParsePdfScreen extends GetView<ParsePdfController> {
  const ParsePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF解析"), leading: const BackButton()),
      body: controller.initState.displaySuccess(
        loadingBuilder: () => const Center(child: CustomLoading()),
        successBuilder: (totalPages) {
          return Column(
            children: [
              // 页数提示
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '共 $totalPages 页，滚动时按需加载',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: totalPages,
                  cacheExtent: 800,
                  itemBuilder: (context, index) {
                    return _PageTile(index: index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => FilledButton.icon(
                      onPressed: controller.importState.value.isLoading
                          ? null
                          : () => controller.importPDF(),
                      icon: controller.importState.value.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        controller.importState.value.isLoading
                            ? "导入中…"
                            : "导入PDF",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 单页 tile，进入可见区域时触发渲染，离屏时释放
class _PageTile extends GetView<ParsePdfController> {
  const _PageTile({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetectorTile(
      index: index,
      onVisible: () => controller.renderPage(index),
      onInvisible: () {
        // 超出阈值范围的页面释放内存
        final visibleItems = _VisibilityTracker.instance.visibleIndices;
        if (visibleItems.isEmpty) return;
        final minVisible = visibleItems.reduce((a, b) => a < b ? a : b);
        final maxVisible = visibleItems.reduce((a, b) => a > b ? a : b);
        if (index < minVisible - _kReleaseThreshold ||
            index > maxVisible + _kReleaseThreshold) {
          controller.releasePage(index);
        }
      },
      child: Obx(() {
        final image = controller.pageImages.length > index
            ? controller.pageImages[index]
            : null;
        final loading = controller.pageLoading.length > index
            ? controller.pageLoading[index]
            : false;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text("第 ${index + 1} 页"),
          leading: SizedBox(
            width: 60,
            height: 80,
            child: image != null
                ? Image.memory(image, fit: BoxFit.cover)
                : loading
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.image_outlined, size: 36),
          ),
          subtitle: image != null
              ? Text(
                  "大小: ${(image.lengthInBytes / 1024).toStringAsFixed(1)} KB",
                )
              : loading
              ? const Text("渲染中…")
              : const Text("待渲染"),
        );
      }),
    );
  }
}

// ─── 简易可见性检测 ──────────────────────────────────────────────

/// 全局追踪当前可见的 index 集合（用于释放判断）
class _VisibilityTracker {
  _VisibilityTracker._();

  static final instance = _VisibilityTracker._();
  final visibleIndices = <int>{};
}

/// 用 StatefulWidget + didChangeDependencies 配合 ScrollNotification 来判断可见性
class VisibilityDetectorTile extends StatefulWidget {
  const VisibilityDetectorTile({
    super.key,
    required this.index,
    required this.onVisible,
    required this.onInvisible,
    required this.child,
  });

  final int index;
  final VoidCallback onVisible;
  final VoidCallback onInvisible;
  final Widget child;

  @override
  State<VisibilityDetectorTile> createState() => _VisibilityDetectorTileState();
}

class _VisibilityDetectorTileState extends State<VisibilityDetectorTile> {
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    // 首次 build 后触发渲染
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _VisibilityTracker.instance.visibleIndices.remove(widget.index);
    if (_wasVisible) widget.onInvisible();
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject == null) return;

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) {
      // 不在 viewport 中，直接触发（第一屏）
      _setVisible(true);
      return;
    }

    final reveal = viewport.getOffsetToReveal(renderObject, 0.0);
    final offset = Scrollable.maybeOf(context)?.position.pixels ?? 0;
    final viewportDim =
        Scrollable.maybeOf(context)?.position.viewportDimension ?? 0;
    final itemTop = reveal.offset - offset;
    final itemBox = renderObject as RenderBox;
    final itemBottom = itemTop + itemBox.size.height;

    final isVisible = itemBottom > 0 && itemTop < viewportDim;
    _setVisible(isVisible);
  }

  void _setVisible(bool visible) {
    if (visible == _wasVisible) return;
    _wasVisible = visible;
    if (visible) {
      _VisibilityTracker.instance.visibleIndices.add(widget.index);
      widget.onVisible();
    } else {
      _VisibilityTracker.instance.visibleIndices.remove(widget.index);
      widget.onInvisible();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 每次 build 后重新检测（应对滚动触发的重建）
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    return widget.child;
  }
}
