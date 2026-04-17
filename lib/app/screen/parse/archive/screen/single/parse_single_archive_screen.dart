import 'package:flutter/material.dart';
import 'package:tele_book/app/screen/parse/archive/screen/single/parse_single_archive_controller.dart';
import 'package:tele_book/app/widget/custom_image_loader.dart';

class ParseSingleArchiveScreen extends StatelessWidget {
  const ParseSingleArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('解析归档'),
        actions: [
          IconButton(
            onPressed: () {
              controller.importArchive();
            },
            icon: Icon(Icons.save),
          ),
        ],
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: controller.extractArchiveState.displaySuccess(
        successBuilder: (data) {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final archive = controller.archives[index];
              return Column(
                children: [
                  Row(
                    children: [
                      CustomImageLoader(localUrl: archive.path),
                      Expanded(
                        child: ListTile(
                          title: Text(archive.path.split('/').last),
                          subtitle: Text(
                            '大小: ${(archive.lengthSync() / 1024).toStringAsFixed(2)} KB',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              );
            },
            itemCount: controller.archives.length,
          );
        },
      ),
    );
  }
}
