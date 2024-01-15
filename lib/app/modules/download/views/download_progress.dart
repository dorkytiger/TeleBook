import 'package:flutter/material.dart';
import 'package:wo_nas/app/modules/download/controllers/download_controller.dart';

class DownloadProgress extends StatefulWidget {
  const DownloadProgress({super.key, required this.url});

  final String url;

  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress>
    with SingleTickerProviderStateMixin {
  DownloadController controller = DownloadController();
  final images = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  late double _progress;

  @override
  void initState() async {
    super.initState();
    startDownload();
  }

  Future<void> startDownload() async {
    var count = 0;
    for (var element in images) {
      await Future.delayed(const Duration(seconds: 2));
      count++;
      setState(() {
        _progress =
            (count / images.length).toDouble(); // Use '=' instead of '=='
      });
      if (count == images.length) {
        controller.currentDownLink.remove(widget.url);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              value: _progress??0.0,
            ),
          )
        ],
      ),
    );
  }
}
