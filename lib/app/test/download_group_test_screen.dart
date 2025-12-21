import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/toast_service.dart';

class DownloadGroupTestController extends GetxController {
  final downloadService = DownloadService.instance;

  // 获取所有批次
  List<DownloadGroupInfo> get allGroups => downloadService.getAllGroups();

  // 测试批量下载
  Future<void> startBatchDownload(String groupName, List<String> urls) async {
    ToastService.showLoading('准备下载...');

    final groupInfo = await downloadService.downloadBatch(
      urls: urls,
      subDirectory: 'test_downloads',
      groupName: groupName,
    );

    ToastService.dismiss();
    ToastService.showSuccess('开始下载 ${urls.length} 个文件');

    // 监听批次完成
    ever(groupInfo.completedCount, (count) {
      if (count == groupInfo.totalCount.value) {
        ToastService.showSuccess('《$groupName》下载完成！');
      }
    });
  }

  // 快速测试：下载 5 张随机图片
  Future<void> quickTest1() async {
    final urls = List.generate(
      5,
      (i) => 'https://picsum.photos/seed/test1-$i/800/600',
    );
    await startBatchDownload('测试批次 1', urls);
  }

  // 快速测试：下载 3 张随机图片
  Future<void> quickTest2() async {
    final urls = List.generate(
      3,
      (i) => 'https://picsum.photos/seed/test2-$i/600/400',
    );
    await startBatchDownload('测试批次 2', urls);
  }

  // 暂停批次
  Future<void> pauseGroup(String groupId) async {
    final count = await downloadService.pauseGroup(groupId);
    ToastService.showText('已暂停 $count 个任务');
  }

  // 恢复批次
  Future<void> resumeGroup(String groupId) async {
    final count = await downloadService.resumeGroup(groupId);
    ToastService.showText('已恢复 $count 个任务');
  }

  // 取消批次
  Future<void> cancelGroup(String groupId) async {
    final count = await downloadService.cancelGroup(groupId);
    ToastService.showSuccess('已取消 $count 个任务');
  }

  // 删除批次
  Future<void> deleteGroup(String groupId) async {
    await downloadService.deleteGroup(groupId);
    ToastService.showSuccess('已删除批次及所有文件');
  }

  // 查看批次详情
  void showGroupDetails(String groupId) {
    Get.to(() => GroupTasksScreen(groupId: groupId));
  }
}

class DownloadGroupTestScreen extends GetView<DownloadGroupTestController> {
  const DownloadGroupTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('批量下载管理'),
      ),
      body: Column(
        children: [
          // 快速测试按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '快速测试',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.quickTest1,
                        icon: const Icon(Icons.download),
                        label: const Text('测试批次 1 (5张)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.quickTest2,
                        icon: const Icon(Icons.download),
                        label: const Text('测试批次 2 (3张)'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // 批次列表
          Expanded(
            child: Obx(() {
              final groups = controller.allGroups;

              if (groups.isEmpty) {
                return const Center(
                  child: Text(
                    '暂无下载批次\n\n点击上方按钮开始测试',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: groups.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return _buildGroupCard(group);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(DownloadGroupInfo group) {
    return Obx(() {
      final progress = group.groupProgress.value;
      final completed = group.completedCount.value;
      final total = group.totalCount.value;
      final failed = group.failedCount.value;
      final isCompleted = completed == total;

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 批次名称和状态
              Row(
                children: [
                  Expanded(
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '已完成',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // 进度条
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? Colors.green : Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 统计信息
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green[400],
                      ),
                      const SizedBox(width: 4),
                      Text('$completed/$total'),
                      if (failed > 0) ...[
                        const SizedBox(width: 16),
                        Icon(
                          Icons.error,
                          size: 16,
                          color: Colors.red[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$failed',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 操作按钮
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildActionChip(
                    label: '查看详情',
                    icon: Icons.list,
                    onTap: () => controller.showGroupDetails(group.groupId),
                  ),
                  if (!isCompleted) ...[
                    _buildActionChip(
                      label: '暂停',
                      icon: Icons.pause,
                      onTap: () => controller.pauseGroup(group.groupId),
                      color: Colors.orange,
                    ),
                    _buildActionChip(
                      label: '恢复',
                      icon: Icons.play_arrow,
                      onTap: () => controller.resumeGroup(group.groupId),
                      color: Colors.green,
                    ),
                  ],
                  _buildActionChip(
                    label: '取消',
                    icon: Icons.close,
                    onTap: () => controller.cancelGroup(group.groupId),
                    color: Colors.red,
                  ),
                  _buildActionChip(
                    label: '删除',
                    icon: Icons.delete,
                    onTap: () => controller.deleteGroup(group.groupId),
                    color: Colors.red[700]!,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (color ?? Colors.blue).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (color ?? Colors.blue).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color ?? Colors.blue),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color ?? Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 批次任务详情页面
class GroupTasksScreen extends StatelessWidget {
  final String groupId;

  const GroupTasksScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final tasks = DownloadService.instance.getTasksByGroup(groupId);
    final groupInfo = DownloadService.instance.getGroupInfo(groupId);

    return Scaffold(
      appBar: AppBar(
        title: Text(groupInfo?.name ?? '任务详情'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Obx(() => ListTile(
            leading: _buildStatusIcon(task.status.value),
            title: Text(
              task.filename,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                LinearProgressIndicator(value: task.progress.value),
                const SizedBox(height: 4),
                Text(
                  '${(task.progress.value * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            isThreeLine: true,
          ));
        },
      ),
    );
  }

  Widget _buildStatusIcon(TaskStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case TaskStatus.running:
        icon = Icons.downloading;
        color = Colors.blue;
        break;
      case TaskStatus.complete:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case TaskStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case TaskStatus.paused:
        icon = Icons.pause_circle;
        color = Colors.orange;
        break;
      default:
        icon = Icons.schedule;
        color = Colors.grey;
    }

    return Icon(icon, color: color);
  }
}

