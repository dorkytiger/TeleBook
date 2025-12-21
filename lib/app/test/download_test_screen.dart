import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:tele_book/app/service/download_service.dart';
import 'package:tele_book/app/service/toast_service.dart';

class DownloadTestController extends GetxController {
  final downloadService = DownloadService.instance;

  final urlController = TextEditingController();

  // 获取所有任务
  List<DownloadTaskInfo> get allTasks => downloadService.getAllTasks();

  @override
  void onClose() {
    urlController.dispose();
    super.onClose();
  }

  // 开始下载
  Future<void> startDownload() async {
    final url = urlController.text.trim();
    if (url.isEmpty) {
      ToastService.showError('请输入下载地址');
      return;
    }

    ToastService.showLoading('开始下载...');
    final taskId = await downloadService.download(url: url);
    ToastService.dismiss();

    if (taskId != null) {
      ToastService.showSuccess('下载已开始');
      urlController.clear();
    } else {
      ToastService.showError('下载失败');
    }
  }

  // 批量下载测试
  Future<void> startBatchDownload() async {
    final urls = [
      'https://picsum.photos/200/300',
      'https://picsum.photos/200/301',
      'https://picsum.photos/200/302',
    ];

    ToastService.showLoading('开始批量下载...');
    final taskIds = await downloadService.downloadBatch(urls: urls);
    ToastService.dismiss();

    ToastService.showSuccess('已开始下载 ${taskIds.totalCount} 个文件');
  }

  // 暂停下载
  Future<void> pauseDownload(String taskId) async {
    final success = await downloadService.pause(taskId);
    if (success) {
      ToastService.showText('已暂停');
    }
  }

  // 恢复下载
  Future<void> resumeDownload(String taskId) async {
    final success = await downloadService.resume(taskId);
    if (success) {
      ToastService.showText('已恢复');
    }
  }

  // 取消下载
  Future<void> cancelDownload(String taskId) async {
    final success = await downloadService.cancel(taskId);
    if (success) {
      ToastService.showText('已取消');
    }
  }

  // 取消所有下载
  Future<void> cancelAllDownloads() async {
    await downloadService.cancelAll();
    ToastService.showText('已取消所有下载');
  }
}

class DownloadTestScreen extends GetView<DownloadTestController> {
  const DownloadTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('后台下载测试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: controller.cancelAllDownloads,
            tooltip: '取消所有下载',
          ),
        ],
      ),
      body: Column(
        children: [
          // 输入区域
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: controller.urlController,
                  decoration: const InputDecoration(
                    labelText: '下载地址',
                    hintText: '输入文件 URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.startDownload,
                        icon: const Icon(Icons.download),
                        label: const Text('开始下载'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.startBatchDownload,
                        icon: const Icon(Icons.download_for_offline),
                        label: const Text('批量下载测试'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // 下载列表
          Expanded(
            child: Obx(() {
              final tasks = controller.allTasks;

              if (tasks.isEmpty) {
                return const Center(
                  child: Text(
                    '暂无下载任务\n\n输入 URL 开始下载',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskItem(task);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(DownloadTaskInfo task) {
    return Obx(() {
      final progress = task.progress.value;
      final status = task.status.value;

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文件名和状态
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.filename,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),

              const SizedBox(height: 8),

              // 进度条
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
              ),

              const SizedBox(height: 8),

              // 进度百分比和操作按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  _buildActionButtons(task),
                ],
              ),

              // 文件路径（下载完成后显示）
              if (status == TaskStatus.complete && task.savePath.value.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '保存位置: ${task.savePath.value}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    String text;

    switch (status) {
      case TaskStatus.enqueued:
        color = Colors.orange;
        text = '排队中';
        break;
      case TaskStatus.running:
        color = Colors.blue;
        text = '下载中';
        break;
      case TaskStatus.paused:
        color = Colors.amber;
        text = '已暂停';
        break;
      case TaskStatus.complete:
        color = Colors.green;
        text = '已完成';
        break;
      case TaskStatus.failed:
        color = Colors.red;
        text = '失败';
        break;
      case TaskStatus.canceled:
        color = Colors.grey;
        text = '已取消';
        break;
      default:
        color = Colors.grey;
        text = '未知';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(DownloadTaskInfo task) {
    return Obx(() {
      final status = task.status.value;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == TaskStatus.running)
            IconButton(
              icon: const Icon(Icons.pause, size: 20),
              onPressed: () => controller.pauseDownload(task.taskId),
              tooltip: '暂停',
            ),

          if (status == TaskStatus.paused)
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 20),
              onPressed: () => controller.resumeDownload(task.taskId),
              tooltip: '恢复',
            ),

          if (status == TaskStatus.failed)
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () => controller.resumeDownload(task.taskId),
              tooltip: '重试',
            ),

          if (status != TaskStatus.complete && status != TaskStatus.canceled)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => controller.cancelDownload(task.taskId),
              tooltip: '取消',
            ),
        ],
      );
    });
  }
}

