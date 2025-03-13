import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CustomImageLoader extends StatefulWidget {
  final String url;

  const CustomImageLoader({super.key, required this.url});

  @override
  _CustomImageLoaderState createState() => _CustomImageLoaderState();
}

class _CustomImageLoaderState extends State<CustomImageLoader> {
  late String _url;

  @override
  void initState() {
    super.initState();
    _url = widget.url;
  }

  void _retryLoading() {
    setState(() {
      _url = ''; // Clear the URL to trigger a rebuild
    });
    Future.delayed(Duration.zero, () {
      setState(() {
        _url = widget.url; // Reset the URL to retry loading
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _retryLoading,
      child: Image.network(_url,
          loadingBuilder: (context, widget, loadingProgress) {
        if (loadingProgress == null) {
          return widget;
        }
        return const Center(
          child: TDLoading(size: TDLoadingSize.large),
        );
      }, errorBuilder: (context, error, stackTrace) {
        return const TDResult(
          theme: TDResultTheme.error,
          title: "加载失败",
          description: "点击重试",
        );
      }),
    );
  }
}
