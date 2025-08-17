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
        await db.execute('''
          CREATE TABLE trips(
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE stops(
            id TEXT PRIMARY KEY,
            trip_id TEXT,
            name TEXT,
            lat REAL,
            lon REAL,
            will_sleep INTEGER,
            notes TEXT,
            status TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY,
            offline_tiles_path TEXT,
            active_stop_id TEXT
          )
        ''');
        await db.insert('settings', {
          'id': 1,
          'offline_tiles_path': null,
          'active_stop_id': null,
        });
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
          await db.execute('''
            CREATE TABLE trips(
              id TEXT PRIMARY KEY,
              name TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE stops(
              id TEXT PRIMARY KEY,
              trip_id TEXT,
              name TEXT,
              lat REAL,
              lon REAL,
              will_sleep INTEGER,
              notes TEXT,
              status TEXT
            )
          ''');
          await db.execute(
              'CREATE TABLE settings(id INTEGER PRIMARY KEY, offline_tiles_path TEXT, active_stop_id TEXT)');
          await db.insert('settings', {
            'id': 1,
            'offline_tiles_path': null,
            'active_stop_id': null,
          });
        } else {
          // ensure settings table has active_stop_id column
          await db.execute('ALTER TABLE settings ADD COLUMN active_stop_id TEXT');
        }
      },
    );
    return _database!;
  }
}
