import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wo_nas/app/modules/book/views/book_view.dart';
import 'package:wo_nas/app/modules/download/views/download_view.dart';
import 'package:wo_nas/app/modules/setting/setting_page_view.dart';

class HomeController extends GetxController {
  RxInt currentPageCount = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  final List<Widget> pages = const [
    BookView(),
    DownloadView(),
    SettingPageView(),
  ];

  setCurrentPage(index) {
    currentPageCount.value = index;
    update();
  }
}
