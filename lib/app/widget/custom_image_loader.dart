import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tele_book/app/widget/custom_error.dart';

class CustomImageLoader extends StatefulWidget {
  final String? networkUrl;
  final String? localUrl;
  final double width;
  final double height;

  const CustomImageLoader({
    super.key,
    this.networkUrl,
    this.localUrl,
    this.width = 80,
    this.height = 80,
  });

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
      return;
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
    if (widget.localUrl == null && widget.networkUrl == null) {
      return SizedBox.shrink();
    }

    if (widget.localUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Image.file(File(_url), fit: BoxFit.cover),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Image.network(
            _url,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, _) {
              if (frame == null) {
                return Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 20, // 明确指定正方形尺寸
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2, // 更细的线条适合小尺寸
                      ),
                    ),
                  ),
                );
              }
              return child;
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SizedBox.square(
                    dimension: 20, // 明确指定正方形尺寸
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2, // 更细的线条适合小尺寸
                    ),
                  ),
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
        ),
      );
    }
  }
}
