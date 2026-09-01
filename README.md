# TeleBook 3.0

<div align="center">

**Language / 语言**

[![中文](https://img.shields.io/badge/中文-README-blue?style=for-the-badge)](README_zh.md)
[![English](https://img.shields.io/badge/English-README-green?style=for-the-badge)](README_en.md)

---

**A powerful cross-platform book management & reading app**

**功能强大的跨平台图书管理与阅读应用**

![badge-android](http://img.shields.io/badge/platform-android-6EDB8D.svg?style=flat)
![badge-ios](http://img.shields.io/badge/platform-ios-CDCDCD.svg?style=flat)
![badge-windows](http://img.shields.io/badge/platform-windows-6EDB8D.svg?style=flat)
![badge-macos](http://img.shields.io/badge/platform-macos-6EDB8D.svg?style=flat)

</div>

---

## 📖 About / 关于

**TeleBook** is a powerful cross-platform book parsing, management, and reading application developed with **Flutter**. It supports multiple import methods, intelligent library management, and personalized reading experiences.

**TeleBook** 是一个使用 **Flutter** 开发的功能强大的跨平台图书解析、管理与阅读应用。支持多种导入方式、智能书库管理、个性化阅读体验。

---

## ✨ Key Features / 主要特性

### 📚 Library Management / 书库管理
- 🗂️ Custom folders with icons and colors / 自定义收藏夹（图标和颜色）
- ⭐ Colorful tag system / 彩色星标系统
- 📊 List & grid view switching / 列表与网格视图切换
- ⚡ Batch operations / 批量操作

### 📖 Reading Experience / 阅读体验
- 📍 Auto-save reading progress / 自动保存阅读进度
- 🔄 Multiple reading directions (LTR/RTL/TTB) / 多种阅读方向
- 🎚️ Slider pagination / 滑块分页（可拖拽进度滑块）
- ⚙️ Customizable reading settings / 可自定义阅读设置

### 🌐 Content Import / 内容导入
- 🌐 WebView web parsing / 网页解析
- 📦 Archive import (ZIP/CBZ/RAR) / 压缩包导入
- 📄 PDF file import / PDF文件导入
- 📁 Folder import / 文件夹导入

### 📥 Download Management / 下载管理
- 🔄 Group retry & delete / 下载组重试与删除
- ✅ Auto-save as book status / 自动保存为书籍状态标识

### 🔄 Multi-Device Sync / 多设备同步
- 🌐 Local-first sync (offline-ready) / 本地优先同步（离线可用）
- 📤 Push/pull event stream / 事件流推送与拉取
- 📸 Image file sync via MinIO / 图片文件同步（MinIO 分片上传）
- 📚 Full-library snapshot history & restore / 整库快照历史与恢复
- ⚡ Reading progress sync / 阅读进度同步
- 🛡️ Conflict detection & resolution / 冲突检测与解决

### 📤 Export / 导出
- 📤 Single & batch export / 单个与批量导出
- ⚡ Background processing / 后台处理
- 🎯 Smart naming / 智能命名

---

## 📥 Download / 下载

**[GitHub Releases](https://github.com/dorkytiger/TeleBook/releases)**

- **Android**: APK
- **iOS**: IPA (requires self-signing / 需自签名)
- **Windows**: ZIP (requires WebView2 Runtime / 需 WebView2 运行时)
- **macOS**: ZIP (unsigned, requires manual approval on first launch / 未签名，首次打开需手动允许)

> **Note**: The desktop version is now built with Flutter and released in this repository.
>
> **注意**：桌面版已基于 Flutter 构建，与本仓库一同发布。

---

## 📚 Documentation / 文档

For detailed documentation, please refer to:

详细文档请参考：

- **[中文文档 (Chinese)](README_zh.md)**
- **[English Documentation](README_en.md)**

---

## 🛠️ Tech Stack / 技术栈

- **Flutter 3.47+**
- **Riverpod** - State management / 状态管理
- **Drift** - Local database / 本地数据库
- **ForUI** - UI components / UI组件库
- **webview_all** - Cross-platform WebView / 跨平台网页视图
- **Go + PostgreSQL + MinIO** - Sync backend / 同步后端（[TelebookServer](https://github.com/dorkytiger/TelebookServer)）

## 🔄 Multi-Device Sync Setup / 多设备同步配置

1. 部署同步后端（[TelebookServer](https://github.com/dorkytiger/TelebookServer)，Docker Compose 一键启动）
2. 手机 A：设置 → 同步服务器 → 填写地址与连接密钥 → 保存并连接（自动同步书库与图片）
3. 手机 B：同样连接，自动下载全部书籍与图片
4. 任一侧导入 / 修改 / 删除 / 阅读，另一侧自动同步；离线操作不阻塞，联网自动补齐

---

## 🤝 Contributing / 贡献

Issues and Pull Requests are welcome!

欢迎提交 Issue 和 Pull Request！

---

## 📄 License / 许可证

MIT License

---

**⭐ If TeleBook helps you, please give it a Star!**

**⭐ 如果 TeleBook 对你有帮助，请点个 Star 支持一下！**
