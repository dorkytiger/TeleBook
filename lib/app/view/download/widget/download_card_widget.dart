import 'package:flutter/material.dart';

import 'download_card_preview_widget.dart';

Widget downloadCardWidget(
    int page,
    int pageSize,
    double progress,
    double progressImg,
    String preview,
    int state,
    Function refreshDownload,
    Function deleteDownload) {
  {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: 150,
            child: downloadCardPreviewWidget(page, state, preview),
          )),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "当前下载页数：$page/$pageSize",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Expanded(
                      child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            refreshDownload();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.blue,
                          )),
                    ),
                    Expanded(
                      child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            deleteDownload();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.blue,
                          )),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text("总进度"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: LinearProgressIndicator(
                        color: Colors.blue,
                        value: progress,
                      ),
                    ),
                    const Text("当前页进度"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                      child: LinearProgressIndicator(
                        color: Colors.blue,
                        value: progressImg,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
