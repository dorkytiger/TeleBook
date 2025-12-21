# Flutter 后台下载服务使用说明

## 依赖库：background_downloader

`background_downloader` 是 Flutter 最强大的后台下载插件之一，支持：

✅ **真正的后台下载**：应用在后台或关闭时也能继续下载
✅ **跨平台支持**：Android、iOS、Windows、macOS、Linux
✅ **暂停/恢复**：支持暂停和恢复下载
✅ **进度通知**：系统通知栏显示下载进度
✅ **批量下载**：支持同时下载多个文件
✅ **断点续传**：网络中断后可以继续下载
✅ **应用重启恢复**：应用重启后可以恢复之前的下载任务

---

## 初始化服务

在 `main.dart` 中初始化：

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化下载服务
  Get.put(DownloadService());
  
  runApp(MyApp());
}
```

---

## 基本使用

### 1. 开始下载单个文件

```dart
final taskId = await DownloadService.instance.download(
  url: 'https://example.com/image.jpg',
  filename: 'my_image.jpg',  // 可选，不指定则从 URL 提取
  subDirectory: 'images',     // 可选，子目录
);

if (taskId != null) {
  print('下载已开始，任务ID: $taskId');
}
```

### 2. 批量下载

```dart
final urls = [
  'https://example.com/image1.jpg',
  'https://example.com/image2.jpg',
  'https://example.com/image3.jpg',
];

final taskIds = await DownloadService.instance.downloadBatch(
  urls: urls,
  subDirectory: 'images',
);

print('开始下载 ${taskIds.length} 个文件');
```

### 3. 监听下载进度

```dart
final taskInfo = DownloadService.instance.getTaskInfo(taskId);

if (taskInfo != null) {
  // 监听进度
  ever(taskInfo.progress, (progress) {
    print('下载进度: ${(progress * 100).toStringAsFixed(1)}%');
  });
  
  // 监听状态
  ever(taskInfo.status, (status) {
    print('下载状态: $status');
    
    if (status == TaskStatus.complete) {
      print('下载完成！文件路径: ${taskInfo.savePath.value}');
    }
  });
}
```

### 4. 暂停/恢复下载

```dart
// 暂停
await DownloadService.instance.pause(taskId);

// 恢复
await DownloadService.instance.resume(taskId);
```

### 5. 取消下载

```dart
// 取消单个任务
await DownloadService.instance.cancel(taskId);

// 取消所有任务
await DownloadService.instance.cancelAll();
```

---

## 在 UI 中显示下载列表

### Controller 示例

```dart
class DownloadController extends GetxController {
  final downloadService = DownloadService.instance;
  
  // 获取所有任务
  List<DownloadTaskInfo> get allTasks => downloadService.getAllTasks();
  
  // 开始下载
  Future<void> startDownload(String url) async {
    final taskId = await downloadService.download(url: url);
    if (taskId != null) {
      ToastService.showSuccess('开始下载');
    } else {
      ToastService.showError('下载失败');
    }
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
}
```

### UI 示例

```dart
class DownloadListScreen extends GetView<DownloadController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('下载列表')),
      body: Obx(() {
        final tasks = controller.allTasks;
        
        if (tasks.isEmpty) {
          return Center(child: Text('暂无下载任务'));
        }
        
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskItem(task);
          },
        );
      }),
    );
  }
  
  Widget _buildTaskItem(DownloadTaskInfo task) {
    return Obx(() {
      final progress = task.progress.value;
      final status = task.status.value;
      
      return ListTile(
        title: Text(task.filename),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progress),
            SizedBox(height: 4),
            Text('${(progress * 100).toStringAsFixed(1)}% - ${_getStatusText(status)}'),
          ],
        ),
        trailing: _buildActionButton(task),
      );
    });
  }
  
  Widget _buildActionButton(DownloadTaskInfo task) {
    return Obx(() {
      final status = task.status.value;
      
      switch (status) {
        case TaskStatus.running:
          return IconButton(
            icon: Icon(Icons.pause),
            onPressed: () => controller.pauseDownload(task.taskId),
          );
        case TaskStatus.paused:
          return IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () => controller.resumeDownload(task.taskId),
          );
        case TaskStatus.complete:
          return Icon(Icons.check_circle, color: Colors.green);
        case TaskStatus.failed:
          return IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.resumeDownload(task.taskId),
          );
        default:
          return IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => controller.cancelDownload(task.taskId),
          );
      }
    });
  }
  
  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.enqueued:
        return '排队中';
      case TaskStatus.running:
        return '下载中';
      case TaskStatus.paused:
        return '已暂停';
      case TaskStatus.complete:
        return '已完成';
      case TaskStatus.failed:
        return '失败';
      case TaskStatus.canceled:
        return '已取消';
      default:
        return '未知';
    }
  }
}
```

---

## 获取下载文件路径

```dart
// 方法1：从 taskInfo 获取
final taskInfo = DownloadService.instance.getTaskInfo(taskId);
if (taskInfo != null && taskInfo.status.value == TaskStatus.complete) {
  final filePath = taskInfo.savePath.value;
  print('文件路径: $filePath');
}

// 方法2：直接查询
final filePath = await DownloadService.instance.getFilePath(taskId);
if (filePath != null) {
  print('文件路径: $filePath');
}

// 检查文件是否存在
final exists = await DownloadService.instance.fileExists(taskId);
```

---

## 权限配置

### Android

在 `android/app/src/main/AndroidManifest.xml` 中添加：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<!-- Android 13+ -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

### iOS

在 `ios/Runner/Info.plist` 中添加：

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

---

## 高级功能

### 1. 自定义通知

```dart
await FileDownloader().configureNotification(
  running: TaskNotification(
    '正在下载 {filename}',
    '进度: {progress}%',
  ),
  complete: TaskNotification(
    '下载完成',
    '{filename} 已保存',
  ),
  error: TaskNotification(
    '下载失败',
    '{filename} 下载出错',
  ),
);
```

### 2. 设置并发下载数

```dart
await FileDownloader().configure(
  globalConfig: (Config.numConcurrentTasks, '3'),  // 同时最多3个任务
);
```

### 3. 下载完成后自动打开文件

```dart
if (status == TaskStatus.complete) {
  final filePath = taskInfo.savePath.value;
  // 使用 open_file 或 share_plus 插件打开文件
}
```

---

## 注意事项

1. **文件保存位置**：默认保存在应用文档目录
2. **网络权限**：确保已申请网络和存储权限
3. **通知权限**：Android 13+ 需要申请通知权限
4. **后台限制**：iOS 后台下载有时间限制
5. **应用重启**：服务会自动恢复之前的下载任务

---

## 与你的项目集成示例

在 `DownloadFormController` 中使用：

```dart
class DownloadFormController extends GetxController {
  Future<void> downloadAllImages() async {
    ToastService.showLoading('准备下载...');
    
    final urls = images.toList();
    final taskIds = await DownloadService.instance.downloadBatch(
      urls: urls,
      subDirectory: 'books/${parseResult.title}',
    );
    
    ToastService.dismiss();
    ToastService.showSuccess('开始下载 ${taskIds.length} 张图片');
    
    // 跳转到下载列表页面
    Get.toNamed('/download-list');
  }
}
```

这样即使用户退出应用，下载也会在后台继续进行！

