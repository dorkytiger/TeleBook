import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../book/book_home_view.dart';
import '../../download/views/download_view.dart';


class HomeController extends GetxController {
  RxInt currentPageCount = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  final List<Widget> pages = const [
    BookHomeView(),
    DownloadView(),
    // SettingPageView(),
  ];

  setCurrentPage(index) {
    currentPageCount.value = index;
    pageController.jumpToPage(index);
    update();
  }
}
