# DownloadService 批量下载分组功能说明

## 🎯 新增功能：按批次管理下载

现在 `DownloadService` 支持通过 `groupId` 来管理一批下载任务，非常适合批量下载场景。

---

## 核心概念

### 1. **DownloadTaskInfo** (任务信息)
每个下载任务现在包含：
- `taskId`: 任务唯一 ID
- **`groupId`**: 所属批次 ID（新增）
- `url`: 下载地址
- `filename`: 文件名
- `status`: 下载状态
- `progress`: 下载进度
- `savePath`: 保存路径

### 2. **DownloadGroupInfo** (批次信息)
下载组统计信息：
- `groupId`: 批次唯一 ID
- `name`: 批次名称
- `totalCount`: 总任务数
- `completedCount`: 已完成数
- `failedCount`: 失败数
- `groupProgress`: 整体进度
- `createTime`: 创建时间

---

## 使用方法

### 1. 批量下载（推荐）

```dart
// 自动生成 groupId 和名称
final groupInfo = await DownloadService.instance.downloadBatch(
  urls: [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
  ],
  subDirectory: 'books/my_book',
);

print('批次 ID: ${groupInfo.groupId}');
print('批次名称: ${groupInfo.name}');
```

### 2. 批量下载（自定义批次信息）

```dart
final groupInfo = await DownloadService.instance.downloadBatch(
  urls: urls,
  subDirectory: 'books/${bookTitle}',
  groupId: 'book_${bookId}', // 自定义批次 ID
  groupName: bookTitle,        // 自定义批次名称
);
```

### 3. 单个下载（指定批次）

```dart
await DownloadService.instance.download(
  url: 'https://example.com/image.jpg',
  groupId: 'book_123', // 加入指定批次
);
```

---

## 按批次管理

### 1. 获取批次信息

```dart
// 获取所有批次
final groups = DownloadService.instance.getAllGroups();

// 获取指定批次信息
final groupInfo = DownloadService.instance.getGroupInfo('book_123');

print('总数: ${groupInfo.totalCount.value}');
print('已完成: ${groupInfo.completedCount.value}');
print('失败数: ${groupInfo.failedCount.value}');
print('整体进度: ${(groupInfo.groupProgress.value * 100).toStringAsFixed(1)}%');
```

### 2. 获取批次内的任务

```dart
// 获取指定批次的所有任务
final tasks = DownloadService.instance.getTasksByGroup('book_123');

print('该批次共有 ${tasks.length} 个任务');
```

### 3. 批量操作

```dart
// 暂停整个批次
final pausedCount = await DownloadService.instance.pauseGroup('book_123');
print('已暂停 $pausedCount 个任务');

// 恢复整个批次
final resumedCount = await DownloadService.instance.resumeGroup('book_123');
print('已恢复 $resumedCount 个任务');

// 取消整个批次
final canceledCount = await DownloadService.instance.cancelGroup('book_123');
print('已取消 $canceledCount 个任务');

// 删除整个批次（包括已下载的文件）
await DownloadService.instance.deleteGroup('book_123');
```

---

## 实时监听批次进度

```dart
class BookDownloadController extends GetxController {
  String? currentGroupId;
  
  Future<void> downloadBook(BookTableData book) async {
    // 开始批量下载
    final groupInfo = await DownloadService.instance.downloadBatch(
      urls: book.imageUrls,
      subDirectory: 'books/${book.name}',
      groupId: 'book_${book.id}',
      groupName: book.name,
    );
    
    currentGroupId = groupInfo.groupId;
    
    // 监听整体进度
    ever(groupInfo.groupProgress, (progress) {
      print('《${book.name}》下载进度: ${(progress * 100).toStringAsFixed(1)}%');
    });
    
    // 监听完成数
    ever(groupInfo.completedCount, (count) {
      print('已完成: $count/${groupInfo.totalCount.value}');
      
      if (count == groupInfo.totalCount.value) {
        ToastService.showSuccess('《${book.name}》下载完成！');
      }
    });
    
    // 监听失败数
    ever(groupInfo.failedCount, (count) {
      if (count > 0) {
        print('失败: $count 个');
      }
    });
  }
  
  // 暂停下载
  Future<void> pauseDownload() async {
    if (currentGroupId != null) {
      await DownloadService.instance.pauseGroup(currentGroupId!);
    }
  }
  
  // 恢复下载
  Future<void> resumeDownload() async {
    if (currentGroupId != null) {
      await DownloadService.instance.resumeGroup(currentGroupId!);
    }
  }
}
```

---

## UI 展示示例

### 按批次显示下载列表

```dart
class DownloadGroupListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('下载管理')),
      body: Obx(() {
        final groups = DownloadService.instance.getAllGroups();
        
        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _buildGroupCard(group);
          },
        );
      }),
    );
  }
  
  Widget _buildGroupCard(DownloadGroupInfo group) {
    return Obx(() {
      final progress = group.groupProgress.value;
      final completed = group.completedCount.value;
      final total = group.totalCount.value;
      final failed = group.failedCount.value;
      
      return Card(
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 批次名称
              Text(
                group.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              
              // 进度条
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
              SizedBox(height: 8),
              
              // 统计信息
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${(progress * 100).toStringAsFixed(1)}%'),
                  Text('$completed/$total 已完成'),
                  if (failed > 0)
                    Text(
                      '$failed 失败',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 12),
              
              // 操作按钮
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showGroupTasks(group.groupId),
                    icon: Icon(Icons.list, size: 16),
                    label: Text('查看任务'),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _pauseGroup(group.groupId),
                    icon: Icon(Icons.pause, size: 16),
                    label: Text('暂停'),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _cancelGroup(group.groupId),
                    icon: Icon(Icons.close, size: 16),
                    label: Text('取消'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
  
  void _showGroupTasks(String groupId) {
    final tasks = DownloadService.instance.getTasksByGroup(groupId);
    // 显示该批次的详细任务列表
    Get.to(() => GroupTasksScreen(groupId: groupId));
  }
  
  Future<void> _pauseGroup(String groupId) async {
    await DownloadService.instance.pauseGroup(groupId);
    ToastService.showText('已暂停');
  }
  
  Future<void> _cancelGroup(String groupId) async {
    await DownloadService.instance.cancelGroup(groupId);
    ToastService.showText('已取消');
  }
}
```

---

## 与 BookController 集成示例

```dart
class BookController extends GetxController {
  Future<void> downloadBook(BookTableData book) async {
    try {
      // 使用书籍 ID 作为 groupId
      final groupInfo = await DownloadService.instance.downloadBatch(
        urls: book.imageUrls,
        subDirectory: 'books/${book.name}',
        groupId: 'book_${book.id}',
        groupName: book.name,
      );
      
      ToastService.showSuccess('开始下载《${book.name}》');
      
      // 监听下载完成
      ever(groupInfo.completedCount, (count) {
        if (count == groupInfo.totalCount.value) {
          _onDownloadComplete(book, groupInfo.groupId);
        }
      });
      
      // 跳转到下载页面
      Get.find<NavController>().setIndex(1);
    } catch (e) {
      ToastService.showError('下载失败: $e');
    }
  }
  
  Future<void> _onDownloadComplete(BookTableData book, String groupId) async {
    // 获取所有下载文件的路径
    final tasks = DownloadService.instance.getTasksByGroup(groupId);
    final localPaths = <String>[];
    
    for (final task in tasks) {
      if (task.status.value == TaskStatus.complete) {
        localPaths.add(task.savePath.value);
      }
    }
    
    // 更新数据库
    final updatedBook = book.copyWith(
      localPaths: localPaths,
      isDownload: true,
    );
    await appDatabase.update(appDatabase.bookTable).replace(updatedBook);
    
    ToastService.showSuccess('《${book.name}》下载完成！');
    getBookList();
  }
}
```

---

## 优势

✅ **批次管理**：可以按书籍、章节等维度组织下载
✅ **统一操作**：一键暂停/恢复/取消整个批次
✅ **实时统计**：自动计算批次的完成数、失败数、整体进度
✅ **响应式更新**：所有状态都是响应式的，UI 自动更新
✅ **灵活查询**：可以按批次查询任务，方便管理
✅ **自动持久化**：应用重启后自动恢复批次信息

---

## 注意事项

1. **groupId 唯一性**：确保每个批次的 groupId 唯一
2. **自动生成 ID**：如果不指定 groupId，会自动生成（格式：`group_时间戳`）
3. **metaData 存储**：groupId 存储在任务的 metaData 中，应用重启后可恢复
4. **批次删除**：`deleteGroup` 会删除所有下载的文件，谨慎使用

---

现在你可以轻松管理批量下载任务了！🎉

