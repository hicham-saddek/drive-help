import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../models/stop.dart';
import '../providers/database_provider.dart';

class StopRepository {
  StopRepository(this.ref);
  final Ref ref;

  Future<Database> get _db => ref.read(databaseProvider.future);

  Future<void> insert(Stop stop) async {
    final db = await _db;
    await db.insert('stops', stop.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Stop stop) async {
    final db = await _db;
    await db.update('stops', stop.toMap(),
        where: 'id = ?', whereArgs: [stop.id]);
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete('stops', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Stop>> listByTrip(String tripId) async {
    final db = await _db;
    final maps = await db.query('stops', where: 'trip_id = ?', whereArgs: [tripId]);
    return maps.map(Stop.fromMap).toList();
  }

  Future<Stop?> get(String id) async {
    final db = await _db;
    final maps = await db.query('stops', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Stop.fromMap(maps.first);
  }

  Future<void> setActiveStop(String? id) async {
    final db = await _db;
    await db.update('settings', {'active_stop_id': id}, where: 'id = 1');
  }

  Future<String?> getActiveStopId() async {
    final db = await _db;
    final maps = await db.query('settings', where: 'id = 1');
    if (maps.isEmpty) return null;
    return maps.first['active_stop_id'] as String?;
  }
}

