# TeleBook 3.0: Next-Generation Cross-Platform Book Management & Reading App

**TeleBook** is a powerful cross-platform book parsing, management, and reading application developed with **Flutter**. It supports multiple import methods, intelligent library management, and personalized reading experiences, making digital reading more convenient and comfortable than ever before.

![badge-android](http://img.shields.io/badge/platform-android-6EDB8D.svg?style=flat)
![badge-ios](http://img.shields.io/badge/platform-ios-CDCDCD.svg?style=flat)
![badge-mac](http://img.shields.io/badge/platform-macos-111111.svg?style=flat)
![badge-linux](http://img.shields.io/badge/platform-linux-2D3F6C.svg?style=flat)
![badge-windows](http://img.shields.io/badge/platform-windows-4D76CD.svg?style=flat)

_**Note: Version 3.0 is a major update with numerous new features and optimizations. It's recommended to backup your data before upgrading.**_

## ✨ Major Updates in Version 3.0

### 📚 Brand New Library Management System

- **🗂️ Folders Feature**: Create custom folders with icons and colors for intelligent book categorization
- **⭐ Star System**: Add colorful labels to books for quick identification and filtering
- **📊 Layout Switching**: Support for both list view and grid view display modes for personalized bookshelf experience
- **⚡ Batch Operations**: Batch select, move, delete, and export books for efficient management of large collections
- **🔍 Smart Filtering**: Quickly locate target books by folders, tags, and search keywords

### 📖 Personalized Reading Experience

- **📍 Reading Progress Tracking**: Automatically save reading position for each book with seamless bookmark resume
- **🔄 Multiple Reading Directions**: Support left-to-right, right-to-left (for manga), and top-to-bottom (long strip mode) reading
- **⚙️ Reading Settings**: Quick access to reading direction settings via settings button, with auto-save
- **📊 Smart Progress Bar**: Different progress indicator styles based on reading direction, showing percentage for vertical scrolling

### 📝 Enhanced Book Editing

- **✏️ Instant Renaming**: Quickly rename books in the edit page with immediate effect
- **🗑️ Smart Deletion**: Automatically clean up physical files and database records when deleting images to prevent storage waste
- **📄 Real-time Sync**: All editing operations sync to database immediately, ensuring data consistency

### 🎨 UI & Performance Optimizations

- **🌙 Dark Mode Adaptation**: Full support for system dark mode with eye-friendly night reading
- **⚡ Performance Optimization**: Improved memory usage, loading speed, and responsiveness
- **🐛 Bug Fixes**: Fixed known issues, enhanced app stability
- **💫 UI Beautification**: Interface detail optimizations with more modern design language

### 🌐 Versatile Content Import

#### WebView Web Parsing

- Built-in WebView browser for direct web content loading
- Intelligent extraction of all images from pages
- Support for Telegraph and other image-based websites
- Real-time preview with selective download

#### Single Archive Import

- Support for ZIP, CBZ, RAR, and other compressed formats
- Automatic extraction and image file recognition
- Quick library building
- Unified file naming (8-digit leading zero format)

#### Batch Archive Import

- Select folder and automatically scan all ZIP/CBZ files
- Parallel extraction with background processing that doesn't block UI
- Editable file list for each archive (sorting, deletion)
- Batch save and one-click import of multiple books

#### PDF File Import

- Direct import of PDF files and conversion to image format
- High-quality image rendering support
- Automatic pagination processing

#### Image Folder Import

- Direct import of folders containing images
- Support for single folder and batch folder import
- Automatic sorting by filename

### 📤 Powerful Export Feature

- **Single Book Export**: Export as standard ZIP archive
- **Batch Export**: Select multiple books for one-click export
- **Background Processing**: Using Isolate technology, export process doesn't affect UI smoothness
- **Smart Naming**: Automatically use book name as filename

## 📥 Download & Installation

### Method 1: Download Pre-compiled Version

Visit [GitHub Releases](https://github.com/dorkytiger/TeleBook/releases) to download the latest version

- **Android**: Download APK file and install directly
- **Windows**: Download ZIP file, extract and run
- **iOS**: Download IPA file (requires self-signing)

### Method 2: Manual Compilation

```bash
# Clone the project
git clone https://github.com/dorkytiger/TeleBook.git
cd TeleBook

# Install dependencies
flutter pub get

# Generate code (Drift database)
flutter pub run build_runner build --delete-conflicting-outputs

# Build
flutter build apk        # Android
flutter build ios        # iOS
flutter build windows    # Windows
flutter build macos      # macOS
flutter build linux      # Linux
```

## 🚀 Quick Start

### 📖 Import Your First Book

#### Method 1: Parse via Web Link

1. **Copy Book Link** - Find your desired book on Telegraph or other websites, copy the link
2. **Open Import Interface** - Click the ➕ icon in the top right corner
3. **Select Web Data Source** - Choose "Web", paste the link in the "URL" field
4. **Parse and Preview** - App automatically loads the page and extracts images with real-time preview
5. **Add to Download Queue** - Click "Save" button to add images to download queue
6. **Save Book** - After download completes, click "Save Book" to add to bookshelf

#### Method 2: Import via Archive

1. **Prepare Archive** - Package image files into ZIP, CBZ or other compressed formats
2. **Select Archive Data Source** - Click ➕, choose "Archive"
3. **Select File** - Click "Select File", choose archive from device
4. **Auto Extract** - App automatically extracts and recognizes images, click "Save" to add to bookshelf

#### Method 3: Batch Archive Import

1. **Prepare Folder** - Place multiple ZIP/CBZ files in the same folder
2. **Select Batch Data Source** - Choose "Batch Archive"
3. **Select Folder** - Choose the folder containing archives
4. **Edit File List** - Optionally edit file order for each archive
5. **Batch Import** - Click ✅ button to batch save all books

### 📚 Manage Your Library

#### Create Folders

1. **Enter Folder Management** - In the book list page, click the three-dot menu in top right → "Folder Management"
2. **Create New Folder** - Click ➕ button, enter name, select icon and color
3. **Add Books to Folder** - Long press book and select "Add to Folder", or use batch operations

#### Use Tag System

1. **Create Tags** - Create different colored tags in "Tag Management" page
2. **Add Tags to Books** - Select "Add Tag" in book operation menu
3. **Filter by Tags** - Use filter function in book list to view books by tag

#### Switch Display Layout

- In the book list page, click the filter button to switch between list view and grid view

### 📖 Personalized Reading Settings

#### Set Reading Direction

1. **Open Reading Settings** - Click the settings icon in top right corner of reading page
2. **Choose Reading Direction**:
    - **Left to Right**: Suitable for most books and comics
    - **Right to Left**: Suitable for Japanese manga
    - **Top to Bottom**: Suitable for long strip comics with continuous scrolling display
3. **Auto-save Settings** - Settings are saved immediately upon selection and automatically applied next time

#### Reading Progress Tracking

- App automatically records reading position for each book
- Automatically jumps to last reading position when reopening book
- Progress bars visible for each book in the book list

## 📖 Reading Experience

### 🎯 Smart Progress Display

- **Pagination Mode** (horizontal reading): Shows current page number and draggable progress slider
- **Scrolling Mode** (vertical reading): Shows percentage progress and linear progress bar
- **Real-time Sync**: Reading progress saved to local database in real-time

### 🔄 Diverse Reading Methods

- **Traditional Page Turning**: Swipe left/right to turn pages, suitable for comics and albums
- **Continuous Scrolling**: Swipe up/down with seamless image connection, suitable for long strip comics
- **Reverse Reading**: Right-to-left page turning, supports Japanese manga reading habits

### 🖼️ Enhanced Image Viewing

- **Zoom Support**: Pinch to zoom for detail viewing (0.5x - 4x)
- **Fullscreen Immersion**: Tap to toggle progress bar display
- **High-quality Rendering**: Maintains original image quality

## 🛠️ Tech Stack

- **Flutter 3.29.0** - Cross-platform UI framework
- **GetX** - State management and routing
- **Drift** - Local database (SQLite)
- **SharedPreferences** - Local settings storage
- **WebView** - Web parsing
- **Archive** - Archive processing
- **Background Downloader** - Background downloading
- **TDesign Flutter** - UI component library
- **Path Provider** - File path management
- **File Picker** - File selection

## ✅ Completed Features

### New in Version 3.0

- ✅ Folder feature (custom icons and colors)
- ✅ Star system (colorful labels)
- ✅ Layout switching (list/grid view)
- ✅ Batch operations
- ✅ Dark mode adaptation
- ✅ Reading progress tracking
- ✅ Multiple reading directions (left-right/right-left/top-bottom)
- ✅ Reading settings persistence
- ✅ Instant rename function
- ✅ Smart file deletion
- ✅ Real-time data sync
- ✅ Performance optimization

### Core Features

- ✅ WebView web parsing
- ✅ Archive import (ZIP/CBZ/RAR)
- ✅ Batch archive import
- ✅ PDF file import
- ✅ Image folder import
- ✅ Batch folder import
- ✅ Book export feature
- ✅ Background download management
- ✅ Local library management

## 📝 Future Development Plans

### Short-term Plans

- [ ] Enhanced bookmark feature (in-page bookmarks)
- [ ] Reading history
- [ ] Global search function
- [ ] Theme customization

### Long-term Vision

- [ ] Cloud sync feature
- [ ] Community sharing
- [ ] Plugin system
- [ ] AI smart recommendations

## 🌟 TeleBook 3.0 Feature Overview

| Feature Category          | Feature          | Description                                    |
|---------------------------|------------------|------------------------------------------------|
| 📚 **Content Import**     | WebView Parsing  | Direct parsing of Telegraph and image websites |
|                           | Archive Import   | Support for ZIP/CBZ/RAR and more               |
|                           | PDF Import       | High-quality PDF to image conversion           |
|                           | Folder Import    | Batch import of image folders                  |
| 🗂️ **Library Management** | Folder System    | Custom icon and color folders                  |
|                           | Star System      | Colorful labels for quick identification       |
|                           | Batch Operations | Multi-select edit, move, delete                |
|                           | Smart Filtering  | Multi-dimensional book filtering               |
| 📖 **Reading Experience** | Progress Tracking| Bookmark resume with auto-save position        |
|                           | Multi-direction  | Three reading modes: LTR/RTL/TTB               |
|                           | Smart Progress   | Adaptive display styles                        |
|                           | Zoom Viewing     | 0.5x-4x zoom support                          |
| 🎨 **UI Experience**      | Dark Mode        | Full system theme adaptation                   |
|                           | Dual Layout      | List/grid view switching                       |
|                           | Modern Design    | TDesign-style UI                              |
|                           | Performance      | Smooth responsive experience                   |

## 🤝 Contributing

Issues and Pull Requests are welcome!

### How to Contribute

1. Fork this project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

Thanks to all developers and users who have contributed to TeleBook!

---

**⭐ If TeleBook helps you, please give it a Star!**

**📱 Download Now: [GitHub Releases](https://github.com/dorkytiger/TeleBook/releases)**

