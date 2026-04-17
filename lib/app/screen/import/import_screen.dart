import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tele_book/app/service/import_service.dart';
import 'package:tele_book/app/store/import_store.dart';
import 'package:tele_book/app/widget/custom_empty.dart';

import 'import_controller.dart';

/// ImportScreen - 使用 Provider 模式
class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 从 Provider 获取依赖
    final importService = context.read<ImportService>();
    final importStore = context.read<ImportStore>();

    return ChangeNotifierProvider(
      create: (_) => ImportController(
        importService: importService,
        importStore: importStore,
      ),
      child: const _ImportScreenContent(),
    );
  }
}

class _ImportScreenContent extends StatelessWidget {
  const _ImportScreenContent();

  @override
  Widget build(BuildContext context) {
    // 监听 ImportStore 的变化
    return Consumer2<ImportStore, ImportController>(
      builder: (context, importStore, controller, child) {
        if (importStore.groups.isEmpty) {
          return const Center(child: CustomEmpty(message: "暂无导入任务"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: importStore.groups.length,
          itemBuilder: (context, index) {
            final group = importStore.groups[index];
            return _ImportGroupItem(
              group: group,
              controller: controller,
            );
          },
        );
      },
    );
  }
}

class _ImportGroupItem extends StatelessWidget {
  final ImportGroup group;
  final ImportController controller;

  const _ImportGroupItem({
    required this.group,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 监听 group 的 tasks 和 status 变化
    return ValueListenableBuilder(
      valueListenable: group.tasks,
      builder: (context, tasks, child) {
        final firstTask = tasks.firstOrNull;

        return ValueListenableBuilder(
          valueListenable: group.status,
          builder: (context, status, child) {
            return Row(
              children: [
                // 封面
                _buildCover(context, firstTask, controller.appDocPath),
                const SizedBox(width: 12),
                // 信息区域
                Expanded(
                  child: _buildInfo(context, group),
                ),
                const SizedBox(width: 8),
                // 重试按钮
                IconButton(
                  onPressed: () => controller.restartImport(group.id),
                  icon: const Icon(Icons.refresh),
                  tooltip: '重新导入',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCover(BuildContext context, ImportTask? firstTask, String? appDocPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: firstTask != null
            ? ValueListenableBuilder(
                valueListenable: firstTask.distSubPath,
                builder: (context, distSubPath, child) {
                  if (distSubPath.isNotEmpty && appDocPath != null) {
                    return Image.file(
                      File("$appDocPath/$distSubPath"),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(context),
                    );
                  }
                  return _buildPlaceholder(context);
                },
              )
            : _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.insert_drive_file,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildInfo(BuildContext context, ImportGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          group.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '总数: ${group.totalCount}  完成数: ${group.completedCount}  失败数: ${group.failedCount}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7),
              ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: group.groupProgress,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
