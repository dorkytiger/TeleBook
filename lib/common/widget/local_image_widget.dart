import 'dart:io';

import 'package:flutter/material.dart';

class LocalImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const LocalImageWidget({
    super.key,
    required this.imagePath,
    this.width = 64,
    this.height = 64,
  });


  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = (width * dpr).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheWidth: cacheW,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
