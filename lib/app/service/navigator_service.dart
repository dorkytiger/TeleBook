import 'package:flutter/material.dart';

class NavigatorService {
  NavigatorService._();

  static final NavigatorService instance = NavigatorService._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static void pop() {
    return navigatorKey.currentState!.pop();
  }

  static BuildContext currentContext() {
    return navigatorKey.currentContext!;
  }
}
