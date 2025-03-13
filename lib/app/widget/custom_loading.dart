import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});


  @override
  Widget build(BuildContext context) {
    return  const Center(child: TDLoading(size: TDLoadingSize.large));
  }
}
