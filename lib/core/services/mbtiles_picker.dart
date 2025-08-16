import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Picks an MBTiles file and copies it into the application's documents
/// directory under `tiles/`.
///
/// Returns the absolute path to the copied file or `null` if the user
/// cancels the picker.
Future<String?> pickAndPersistMbtilesPath() async {
  final res = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mbtiles'],
    withData: false,
  );
  if (res == null || res.files.isEmpty) return null;

  final file = res.files.single;
  final filename = file.name;
  if (file.path != null) {
    return _copyToAppDocs(File(file.path!), filename);
  }
  // When the picker returns a content URI the path is null; use the XFile
  // stream to copy the bytes into the app's documents directory.
  return _copyStreamToAppDocs(file.xFile.openRead(), filename);
}

Future<String> _copyToAppDocs(File source, String filename) async {
  return _copyStreamToAppDocs(source.openRead(), filename);
}

Future<String> _copyStreamToAppDocs(
  Stream<List<int>> src,
  String filename,
) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final tilesDir = Directory(p.join(docsDir.path, 'tiles'));
  if (!await tilesDir.exists()) {
    await tilesDir.create(recursive: true);
  }
  final destPath = p.join(tilesDir.path, filename);
  final destFile = File(destPath);
  final sink = destFile.openWrite();
  const chunkSize = 64 * 1024;
  await for (final chunk in src) {
    var offset = 0;
    while (offset < chunk.length) {
      final end = (offset + chunkSize < chunk.length)
          ? offset + chunkSize
          : chunk.length;
      sink.add(chunk.sublist(offset, end));
      offset = end;
    }
  }
  await sink.close();
  return destPath;
}

/// Exposed for testing only.
///
/// Copies [source] into the application documents directory under [filename].
/// This simply forwards to the private helper.
Future<String> copyToAppDocsForTest(File source, String filename) {
  return _copyToAppDocs(source, filename);
}
