# ToastService 使用说明

自定义的 Toast 服务，基于弹出新页面实现，不依赖 Overlay，使用 NavigatorService 的全局 context。

## 功能特性

- ✅ 四种类型：文本、加载中、成功、失败
- ✅ 支持自动关闭和手动关闭
- ✅ 基于 showGeneralDialog 实现，不依赖 Overlay
- ✅ 使用全局 NavigatorKey，无需传递 context
- ✅ 带渐变和缩放动画效果
- ✅ 加载状态不可点击关闭，其他状态可点击关闭

## 使用方法

### 1. 显示文本提示

```dart
ToastService.showText('这是一条文本提示');

// 自定义持续时间
ToastService.showText('这是一条文本提示', duration: Duration(seconds: 3));
```

### 2. 显示加载中

```dart
ToastService.showLoading(); // 默认显示 "加载中..."

// 自定义文本
ToastService.showLoading('正在处理...');

// 加载完成后需要手动关闭
ToastService.dismiss();
```

### 3. 显示成功提示

```dart
ToastService.showSuccess('操作成功');

// 自定义持续时间
ToastService.showSuccess('操作成功', duration: Duration(seconds: 3));
```

### 4. 显示失败提示

```dart
ToastService.showError('操作失败');

// 自定义持续时间
ToastService.showError('操作失败', duration: Duration(seconds: 3));
```

### 5. 手动关闭

```dart
ToastService.dismiss();
```

## 使用示例

### 异步操作示例

```dart
Future<void> loadData() async {
  ToastService.showLoading('加载中...');
  
  try {
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 2));
    
    ToastService.dismiss(); // 先关闭 loading
    ToastService.showSuccess('加载成功');
  } catch (e) {
    ToastService.dismiss(); // 先关闭 loading
    ToastService.showError('加载失败: $e');
  }
}
```

### 在 GetX Controller 中使用

```dart
class MyController extends GetxController {
  final state = Rx<RequestState>(Idle());

  @override
  void onInit() {
    super.onInit();
    
    ever(state, (s) {
      ToastService.dismiss(); // 先关闭之前的 toast
      
      if (s.isLoading()) {
        ToastService.showLoading('处理中...');
      } else if (s.isSuccess()) {
        ToastService.showSuccess('操作成功');
      } else if (s.isError()) {
        ToastService.showError('操作失败');
      }
    });
  }

  Future<void> doSomething() async {
    state.value = Loading();
    
    try {
      // 执行操作
      await Future.delayed(Duration(seconds: 2));
      state.value = Success(null);
    } catch (e) {
      state.value = Error(e.toString());
    }
  }
}
```

## 配置要求

确保在 `main.dart` 中配置了 `NavigatorService.navigatorKey`：

```dart
void main() {
  runApp(
    GetMaterialApp(
      navigatorKey: NavigatorService.navigatorKey,
      // ... 其他配置
    ),
  );
}
```

## 自定义样式

如果需要自定义样式，可以修改 `toast_service.dart` 中的 `_ToastWidget` 类：

- 修改容器背景色、圆角、内边距
- 修改文字样式、颜色、大小
- 修改图标样式、颜色、大小
- 修改动画效果、持续时间

## 注意事项

1. **加载状态不会自动关闭**：使用 `showLoading()` 后必须手动调用 `dismiss()` 关闭
2. **自动去重**：如果已有 Toast 在显示，新的 Toast 会先关闭旧的再显示
3. **点击关闭**：除了加载状态外，其他类型的 Toast 可以点击关闭
4. **全局单例**：整个应用只会同时显示一个 Toast

