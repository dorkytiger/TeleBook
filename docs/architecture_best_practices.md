# 架构最佳实践 - Service vs Controller 数据组装

## 🎯 设计原则

### Service 层职责
- ✅ 管理**单一数据源**的基础数据
- ✅ 提供基础的 CRUD 操作
- ✅ 监听数据库变化并更新缓存
- ❌ **不应该**组装复杂的 VO 数据
- ❌ **不应该**关心 UI 需要什么数据

### Controller 层职责
- ✅ 根据 UI 需要**按需组装** VO 数据
- ✅ 处理用户交互逻辑
- ✅ 管理页面状态
- ✅ 协调多个 Service

## 📊 数据流向

```
Database → Service (基础数据) → Controller (组装 VO) → UI (展示)
```

## 💡 为什么 Controller 按需组装更好？

### 1. 性能优化
```dart
// ❌ 错误：Service 总是组装全部数据
class BookService {
  final books = Rx<List<BookVO>>([]);
  
  Future<void> getBooks() async {
    // 每次都查询 marks、collection，即使 UI 不需要
    books.value = await _assembleBookVOs();
  }
}

// ✅ 正确：Controller 按需组装
class BookController {
  final bookService = Get.find<BookService>();
  
  Future<void> fetchBooks() async {
    // 只在需要时才查询关联数据
    final books = bookService.books;
    if (needMarks) {
      // 按需查询 marks
    }
  }
}
```

### 2. 灵活性
不同页面对数据的需求不同：
- **列表页**：只需要 Book 基本信息
- **详情页**：需要 Book + Marks + Collection
- **统计页**：只需要 Book 数量

### 3. 可维护性
```dart
// Service 保持简单，只管理基础数据
class BookService {
  final books = <BookTableData>[].obs;
  
  Future<void> getBooks() async {
    books.value = await db.bookTable.select().get();
  }
}

// Controller 根据需要组装不同的 VO
class BookListController {
  List<BookSimpleVO> get simpleBooks => 
    bookService.books.map((b) => BookSimpleVO(b)).toList();
}

class BookDetailController {
  Future<BookDetailVO> getDetail(int id) async {
    // 组装详细的 VO
  }
}
```

## 🚀 推荐实现方式

### 方式一：Controller 直接组装（当前推荐）
```dart
class BookController extends GetxController {
  final bookService = Get.find<BookService>();
  final markService = Get.find<MarkService>();
  final collectionService = Get.find<CollectionService>();

  Future<void> fetchBooks() async {
    await getBookState.triggerQuery(
      query: () async {
        // 1. 获取基础数据
        final books = bookService.books;
        final marks = markService.marks;
        final collections = collectionService.collections;
        
        // 2. 在内存中组装 VO
        return books.map((book) {
          final bookMarks = marks.where((m) => m.bookId == book.id);
          final bookCollection = collections.firstWhereOrNull(
            (c) => c.id == book.collectionId,
          );
          return BookVO(
            book: book,
            marks: bookMarks,
            collection: bookCollection,
          );
        }).toList();
      },
    );
  }
}
```

### 方式二：使用 computed（响应式自动组装）
```dart
class BookController extends GetxController {
  final bookService = Get.find<BookService>();
  final markService = Get.find<MarkService>();
  
  // 自动响应 Service 数据变化
  List<BookVO> get bookVOs {
    return bookService.books.map((book) {
      final bookMarks = markService.marks
        .where((m) => m.bookId == book.id)
        .toList();
      return BookVO(book: book, marks: bookMarks);
    }).toList();
  }
}

// UI 中使用
Obx(() => ListView.builder(
  itemCount: controller.bookVOs.length,
  itemBuilder: (context, index) {
    final bookVO = controller.bookVOs[index];
    return BookListItem(bookVO);
  },
))
```

## 📝 最佳实践总结

1. **Service 只管理基础数据**
   - 每个 Service 负责一张表或一组相关表
   - 数据以最原始的形式存储（TableData）
   - 提供简单的查询方法

2. **Controller 按需组装 VO**
   - 根据页面需求决定组装哪些数据
   - 可以使用多个 Service
   - 在内存中组装，避免多次查询数据库

3. **VO 只在 Controller 和 UI 之间传递**
   - Service 不应该知道 VO 的存在
   - VO 包含 UI 展示所需的所有数据

4. **监听和刷新**
   - Service 监听数据库变化
   - Controller 监听 Service 数据变化
   - UI 监听 Controller 的 VO 数据

## 🔍 性能对比

| 场景 | Service 组装 VO | Controller 组装 VO |
|------|-----------------|---------------------|
| 列表页（不需要关联数据） | 浪费：查询了不需要的数据 | ✅ 高效：只查询需要的 |
| 详情页（需要全部数据） | ✅ 可以 | ✅ 可以 |
| 多个页面不同需求 | ❌ 难以适配 | ✅ 灵活按需 |
| 内存占用 | ❌ 高（存储完整 VO） | ✅ 低（只存储基础数据） |

## 💻 代码示例对比

### ❌ 反模式：Service 组装所有数据
```dart
// Service 做了太多事情
class BookService {
  final books = Rx<List<BookVO>>([]);
  
  Future<void> getBooks() async {
    final bookList = await db.bookTable.select().get();
    
    // Service 查询了所有关联数据
    final vos = await Future.wait(
      bookList.map((book) async {
        final marks = await getMarks(book.id);
        final collection = await getCollection(book.id);
        return BookVO(book: book, marks: marks, collection: collection);
      }),
    );
    
    books.value = vos;
  }
}
```

### ✅ 推荐：Controller 按需组装
```dart
// Service 只管基础数据
class BookService {
  final books = <BookTableData>[].obs;
  
  Future<void> getBooks() async {
    books.value = await db.bookTable.select().get();
  }
}

// Controller 按需组装
class BookController {
  Future<List<BookVO>> fetchBooksWithDetails() async {
    final books = bookService.books;
    
    // 批量查询关联数据（一次查询，而不是 N+1）
    final bookIds = books.map((b) => b.id).toList();
    final markRelations = await db.markBookTable
      .select()
      .where((t) => t.bookId.isIn(bookIds))
      .get();
    
    // 在内存中组装
    return books.map((book) {
      final marks = markRelations
        .where((r) => r.bookId == book.id)
        .toList();
      return BookVO(book: book, marks: marks);
    }).toList();
  }
}
```

## 🎓 结论

**Controller 按需组装 VO 是更好的选择**，因为：
- ✅ 性能更好（按需查询）
- ✅ 更灵活（不同页面不同需求）
- ✅ 更容易维护（Service 保持简单）
- ✅ 更符合单一职责原则

