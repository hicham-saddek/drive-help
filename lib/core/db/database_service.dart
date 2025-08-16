import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/roadtrip_sidekick.db';
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pois(
            id TEXT PRIMARY KEY,
            category TEXT,
            name TEXT,
            lat REAL,
            lon REAL,
            cost_hint TEXT,
            notes TEXT
          )
        ''');
        await db.execute(
            'CREATE TABLE settings(id INTEGER PRIMARY KEY, offline_tiles_path TEXT)');
        await db.insert('settings', {'id': 1, 'offline_tiles_path': null});
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 1) {
          await db.execute('''
            CREATE TABLE pois(
              id TEXT PRIMARY KEY,
              category TEXT,
              name TEXT,
              lat REAL,
              lon REAL,
              cost_hint TEXT,
              notes TEXT
            )
          ''');
        }
        if (oldVersion < 2) {
          await db.execute(
              'CREATE TABLE settings(id INTEGER PRIMARY KEY, offline_tiles_path TEXT)');
          await db.insert('settings', {'id': 1, 'offline_tiles_path': null});
        }
      },
    );
    return _database!;
  }
}
