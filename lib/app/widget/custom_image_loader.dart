import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tele_book/app/widget/custom_error.dart';

class CustomImageLoader extends StatefulWidget {
  final String? networkUrl;
  final String? localUrl;

  const CustomImageLoader({super.key, this.networkUrl, this.localUrl});

  @override
  _CustomImageLoaderState createState() => _CustomImageLoaderState();
}

class _CustomImageLoaderState extends State<CustomImageLoader> {
  late String _url;

  @override
  void initState() {
    super.initState();
    _setUrl();
  }

  @override
  void didUpdateWidget(CustomImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setUrl();
  }

  void _setUrl() {
    if (widget.networkUrl == null && widget.localUrl == null) {
      throw ArgumentError('Both networkUrl and localUrl cannot be null');
    }

    setState(() {
      if (widget.localUrl != null) {
        _url = widget.localUrl!;
      } else {
        _url = widget.networkUrl!;
      }
    });
  }

  void _retryLoading() {
    setState(() {
      _url = ''; // Clear the URL to trigger a rebuild
    });
    Future.delayed(Duration.zero, () {
      setState(() {
        if (widget.localUrl != null) {
          _url = widget.localUrl!;
        } else {
          _url = widget.networkUrl!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.localUrl != null) {
      return SizedBox(height: 100, width: 80, child: Image.file(File(_url)));
    }
    return SizedBox(
      height: 100,
      width: 80,
      child: Image.network(
        _url,
        loadingBuilder: (context, widget, loadingProgress) {
          if (loadingProgress == null) {
            return widget;
          }
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: CustomError(
              title: error.toString(),
              description: stackTrace.toString(),
            ),
          );
        },
      ),
    );
  }
}
