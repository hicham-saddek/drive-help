import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../providers/database_provider.dart';

class SettingsRepository {
  SettingsRepository(this.ref);
  final Ref ref;

  Future<Database> get _db => ref.read(databaseProvider.future);

  Future<String?> getOfflineTilesPath() async {
    final db = await _db;
    final maps = await db.query('settings', where: 'id = 1');
    if (maps.isEmpty) return null;
    return maps.first['offline_tiles_path'] as String?;
  }

  Future<void> setOfflineTilesPath(String path) async {
    final db = await _db;
    await db.insert('settings', {'id': 1, 'offline_tiles_path': path},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref);
});
