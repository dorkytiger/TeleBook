import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../setting_controller.dart';

class SettingCellWidget extends GetView<SettingController> {
  final bool showArrow;
  final String title;
  final Widget? child;
  final Function()? onTap;

  const SettingCellWidget({
    Key? key,
    this.showArrow = false,
    this.title = '',
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
          child ??
              const SizedBox(
                width: 0,
              ),
          showArrow
              ? const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
