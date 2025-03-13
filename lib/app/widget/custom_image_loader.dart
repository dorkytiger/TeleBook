import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:wo_nas/app/widget/custom_error.dart';

class CustomImageLoader extends StatefulWidget {
  final bool isLocal;
  final String networkUrl;
  final String localUrl;

  const CustomImageLoader({
    super.key,
    required this.isLocal,
    required this.networkUrl,
    required this.localUrl,
  });

  @override
  _CustomImageLoaderState createState() => _CustomImageLoaderState();
}

class _CustomImageLoaderState extends State<CustomImageLoader> {
  late String _url;

  @override
  void initState() {
    super.initState();
    _url = widget.isLocal ? widget.localUrl : widget.networkUrl;
  }

  void _retryLoading() {
    setState(() {
      _url = ''; // Clear the URL to trigger a rebuild
    });
    Future.delayed(Duration.zero, () {
      setState(() {
        _url = widget.isLocal
            ? widget.localUrl
            : widget.networkUrl; // Reset the URL to retry loading
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLocal
        ? Image.file(File(_url))
        : Image.network(_url,
            loadingBuilder: (context, widget, loadingProgress) {
            if (loadingProgress == null) {
              return widget;
            }
            return const Center(
              child: TDLoading(size: TDLoadingSize.small),
            );
          }, errorBuilder: (context, error, stackTrace) {
            return TDLoading(
              size: TDLoadingSize.small,
              text: '加载失败',
              refreshWidget: GestureDetector(
                onTap: _retryLoading,
                child: TDText(
                  '刷新',
                  font: TDTheme.of(context).fontBodySmall,
                  textColor: TDTheme.of(context).brandNormalColor,
                ),
              ),
            );
          });
  }
}
