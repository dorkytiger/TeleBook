import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dk_util/dk_util.dart';
import 'package:dk_util/state/dk_state_query_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tele_book/app/store/import_store.dart';

class ParseSingleArchiveController extends ChangeNotifier {
  final String filePath;
  final ImportStore importStore;

  DKStateQuery<void> extractArchiveState = DkStateQueryIdle();
  bool isImporting = false;
  List<File> archives = [];

  ParseSingleArchiveController({
    required this.filePath,
    required this.importStore,
  }) {
    unawaited(extractArchive());
  }

  Future<void> extractArchive() async {
    await DKStateQueryHelper.triggerQuery(
      onStateChange: (value) {
        extractArchiveState = value;
        notifyListeners();
      },
      query: () async {
        final bytes = await File(filePath).readAsBytes();
        final tmpDir = p.join(
          (await getTemporaryDirectory()).path,
          DateTime.now().microsecondsSinceEpoch.toString(),
        );
        final extractedFiles = await compute(
            _extractZipInBackground, _ExtractParams(bytes, tmpDir));
        archives = extractedFiles.map((path) => File(path)).toList();
      },
    );
  }

  static List<String> _extractZipInBackground(_ExtractParams params) {
    final archive = ZipDecoder().decodeBytes(params.bytes);
    final extractedPaths = <String>[];
    for (final entry in archive) {
      if (entry.isFile) {
        final fileBytes = entry.readBytes();
        final fp = p.join(params.tmpDir, entry.name);
        File(fp)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        extractedPaths.add(fp);
      }
    }
    return extractedPaths;
  }

  Future<void> importArchive() async {
    if (archives.isEmpty || isImporting) return;
    isImporting = true;
    notifyListeners();
    try {
      final name = p.basenameWithoutExtension(filePath);
      final group = await importStore.buildImportGroup(
        name: name,
        type: ImportType.zip,
        files: archives,
      );
      importStore.addImportGroup(group);
      await importStore.startImport(group);
    } finally {
      isImporting = false;
      notifyListeners();
    }
  }
}

class _ExtractParams {
  final Uint8List bytes;
  final String tmpDir;
  _ExtractParams(this.bytes, this.tmpDir);
}
