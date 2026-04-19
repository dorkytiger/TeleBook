import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tele_book/app/widget/custom_error.dart';

class CustomImageLoader extends StatefulWidget {
  final String? networkUrl;
  final String? localUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const CustomImageLoader({
    super.key,
    this.networkUrl,
    this.localUrl,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.cover,
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

    final dpr = MediaQuery.devicePixelRatioOf(context);
    // 只传 cacheWidth，高度由 Flutter 按原始比例自动计算，避免拉伸
    final cacheW = widget.width.isInfinite ? null : (widget.width * dpr).toInt();

    if (widget.localUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Image.file(File(_url), fit: widget.fit, cacheWidth: cacheW),
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
            fit: widget.fit,
            cacheWidth: cacheW,
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
                child: Column(
                  children: [
                    Icon(
                      Icons.broken_image,
                      size: 24,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '加载失败',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: _retryLoading,
                      child: Text('重试'),
                    ),
                  ],
                )
              );
            },
          ),
        ),
      );
    }
  }
}
