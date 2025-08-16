import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../models/poi.dart';
import '../providers/database_provider.dart';

class PoiRepository {
  PoiRepository(this.ref);
  final Ref ref;

  Future<Database> get _db => ref.read(databaseProvider.future);

  Future<List<Poi>> getAll() async {
    final db = await _db;
    final maps = await db.query('pois');
    return maps.map(Poi.fromMap).toList();
  }

  Future<void> insert(Poi poi) async {
    final db = await _db;
    await db.insert('pois', poi.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Poi poi) async {
    final db = await _db;
    await db.update('pois', poi.toMap(), where: 'id = ?', whereArgs: [poi.id]);
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete('pois', where: 'id = ?', whereArgs: [id]);
  }
}
