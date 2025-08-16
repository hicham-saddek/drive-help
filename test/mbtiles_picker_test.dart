import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:roadtrip_sidekick/core/services/mbtiles_picker.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);
  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  test('copies file into app docs', () async {
    final tmpDir = await Directory.systemTemp.createTemp('src');
    final srcFile = File('${tmpDir.path}/test.mbtiles');
    final data = List<int>.generate(1024 * 1024, (_) => Random().nextInt(256));
    await srcFile.writeAsBytes(data);

    final docsDir = await Directory.systemTemp.createTemp('docs');
    PathProviderPlatform.instance = _FakePathProvider(docsDir.path);

    final destPath = await copyToAppDocsForTest(srcFile, 'copy.mbtiles');
    final destFile = File(destPath);

    expect(destFile.existsSync(), isTrue);
    expect(await destFile.length(), data.length);
  });
}
