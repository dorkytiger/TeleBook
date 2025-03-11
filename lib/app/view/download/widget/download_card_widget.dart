import 'package:flutter/material.dart';
import 'package:wo_nas/app/model/entity/download/download_state_entity.dart';

import 'download_card_preview_widget.dart';

Widget downloadCardWidget(
    DownloadState state, Function refreshDownload, Function deleteDownload) {
  {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 4, 5, 4),
        child: Card(
          child: Row(
            children: [
              Expanded(
                child: downloadCardPreviewWidget(
                    state.page, state.state, state.preview),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "当前下载页数：${state.page}/${state.pageSize}",
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
                        Text("总进度:${(state.progress*100).toInt()}%"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.blue,
                            value: state.progress,
                          ),
                        ),
                        Text("当前页进度：${(state.proImg*100).toInt()}%"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.blue,
                            value: state.proImg,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
