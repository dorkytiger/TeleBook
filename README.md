# TeleBook 2.0.2：强大的图书解析与管理工具

**TeleBook** 是一个使用 **Flutter** 开发的跨平台图书解析与管理应用。支持通过 **WebView 网页解析**、**单个压缩包导入**和**批量压缩包导入**三种方式快速获取书籍内容，已保存在 app 的图书也可以单个/批量导出，让阅读和管理图书变得更加便捷。

![badge-android](http://img.shields.io/badge/platform-android-6EDB8D.svg?style=flat)
![badge-ios](http://img.shields.io/badge/platform-ios-CDCDCD.svg?style=flat)
![badge-mac](http://img.shields.io/badge/platform-macos-111111.svg?style=flat)
![badge-linux](http://img.shields.io/badge/platform-linux-2D3F6C.svg?style=flat)
![badge-windows](http://img.shields.io/badge/platform-windows-4D76CD.svg?style=flat)

## ✨ 2.0.2 版本新特性

### 🌐 WebView 网页解析

- 内置 WebView 浏览器，直接加载网页内容
- 智能提取页面中的所有图片
- 支持 Telegraph 及其他图片类网页
- 实时预览，选择性下载

### 📦 单个压缩包导入

- 支持 ZIP、CBZ 等压缩格式
- 自动解压并识别图片文件
- 快速建立书库
- 统一文件命名（8位数字前导零格式）

### 📦 批量压缩包导入 🆕

- 选择文件夹，自动扫描所有 ZIP/CBZ 文件
- 并行解压，后台处理不阻塞 UI
- 可编辑每个压缩包的文件列表（排序、删除）
- 批量保存，一键导入多本书籍

### 📤 书籍导出功能 🆕

- 单个书籍导出为 ZIP 压缩包
- 批量导出多本书籍
- 使用后台 Isolate 处理，不影响界面流畅度

### 📚 其他功能

- 后台下载管理，支持批量下载和断点续传
- 本地书库管理，流畅的阅读体验
- 启动时自动清理临时文件

## 📥 下载安装

### 方式一：下载已编译版本

访问 [GitHub Releases](https://github.com/dorkytiger/TeleBook/releases) 下载最新版本

- **Android**: 下载 APK 文件直接安装
- **Windows**: 下载 ZIP 文件解压运行
- **iOS**: 下载 IPA 文件（需自签名）

### 方式二：手动编译

```bash
# 克隆项目
git clone https://github.com/dorkytiger/TeleBook.git
cd TeleBook

# 安装依赖
flutter pub get

# 生成代码（Drift 数据库）
flutter pub run build_runner build --delete-conflicting-outputs

# 编译
flutter build apk        # Android
flutter build ios        # iOS
flutter build windows    # Windows
flutter build macos      # macOS
flutter build linux      # Linux
```

## 🚀 快速开始

### 方式一：通过网页链接解析

1. **复制书籍链接**  
   在 Telegraph 或其他网页找到想要的书籍，复制其链接地址

2. **打开 TeleBook**  
   点击右上角的 ➕ 号

3. **选择"网页"数据源**  
   在弹出的窗口中选择"数据源"选择”网页“，然后粘贴刚才复制的链接到”网址“

4. **解析并预览**  
   应用会自动加载网页并提取所有图片，实时预览，可以收到去除链接失效的图片或者不需要的图片

5. **添加到下载队列**  
   点击右上角的"保存"按钮，图片将被添加到下载队列

6. **查看下载进度**  
   进入下载页面查看下载进度，下载完成后图片将保存在本地

7. **保存书籍**
   下载完成后，点击"保存书籍"按钮，书籍将被添加到书架

### 方式二：通过压缩包导入

1. **准备压缩包**  
   将图片文件（JPG、PNG 等）打包成 ZIP 或其他压缩格式

2. **打开 TeleBook**  
   点击右上角的 ➕ 号

3. **选择"压缩包"数据源**  
   在弹出的窗口中选择"压缩包"

4. **选择文件**  
   点击"选择文件"按钮，从设备中选择压缩包文件

5. **自动解压与导入**  
   应用会自动解压并识别图片，点击"保存"即可添加到书架

### 方式三：通过批量压缩包导入 🆕

1. **准备文件夹**  
   将多个 ZIP/CBZ 压缩包放在同一个文件夹中

2. **打开 TeleBook**  
   点击右上角的 ➕ 号

3. **选择"批量压缩包"数据源**  
   在弹出的窗口中选择"批量压缩包"

4. **选择文件夹**  
   点击"选择文件夹"按钮，选择包含多个压缩包的文件夹

5. **自动扫描并解压**  
   应用会自动扫描文件夹中的所有 ZIP/CBZ 文件并在后台解压

6. **编辑文件列表（可选）**  
   点击任意压缩包可以进入编辑页面：
   - 拖拽或使用上下按钮调整文件顺序
   - 左滑删除不需要的文件
   - 点击右上角 ✅ 保存修改

7. **批量导入**  
   返回列表页面，点击右上角 ✅ 按钮，批量保存所有书籍到书架

## 📖 阅读体验

- **流畅翻页**：支持左右滑动翻页，底部显示阅读进度
- **图片查看**：点击图片可全屏查看
- **本地存储**：所有书籍保存在本地，随时离线阅读

## 🛠️ 技术栈

- **Flutter 3.29.0** - 跨平台 UI 框架
- **GetX** - 状态管理与路由
- **Drift** - 本地数据库（SQLite）
- **WebView** - 网页解析
- **Archive** - 压缩包处理
- **Background Downloader** - 后台下载

## 📝 开发计划

- [ ] 添加书籍分类和标签功能
- [ ] 支持书签和阅读历史
- [ ] 优化大文件下载性能
- [ ] 添加深色模式

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

---

**如果觉得有用，请给个 ⭐️ Star 支持一下！**
