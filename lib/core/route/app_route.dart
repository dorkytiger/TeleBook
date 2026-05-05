import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tele_book/feature/book/ui/view/list/book_list_view.dart';
import 'package:tele_book/feature/home/ui/view/home/home_view.dart';

class AppRoute {
  // ══════════════════════════════════════════════════════════════════════════
  // 路由常量定义
  // ══════════════════════════════════════════════════════════════════════════

  // 主页面
  static const home = '/home';
  static const book = '/book';
  static const export = '/export';
  static const collection = '/collection';
  static const mark = '/mark';

  // 书籍相关
  static const bookEdit = '/book/edit';
  static const bookPage = '/book/page';
  static const bookFilter = '/book/filter';

  // 下载
  static const download = '/download';
  static const downloadTask = '/download/task';

  // 解析
  static const parseForm = '/parse/form';
  static const parseWeb = '/parse/web';
  static const parsePdf = '/parse/pdf';
  static const parseImageFolder = '/parse/image_folder';
  static const parseBatchImageFolder = '/parse/batch_image_folder';
  static const parseArchiveSingle = '/parse/archive/single';
  static const parseArchiveBatch = '/parse/archive/batch';
  static const parseArchiveBatchEdit = '/parse/archive/batch/edit';

  // Build a GoRouter instance. We still call Get Bindings when building each page
  // to keep existing dependency registration behavior.
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        pageBuilder: (context, state) {
          return MaterialPage(child: HomeView());
        },
      ),
      GoRoute(
        path: book,
        pageBuilder: (context, state) {
          return MaterialPage(child: BookListView());
        },
      ),
    ],
  );
}

// 专门处理导航失败（如缺少参数的页面）
class ErrorRoutePage extends StatelessWidget {
  final String message;

  const ErrorRoutePage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("导航错误"),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Text(message, style: TextStyle(fontSize: 18, color: Colors.red)),
      ),
    );
  }
}
