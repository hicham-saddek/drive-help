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
      version: 1,
      onCreate: (db, version) async {
        // v1 has no tables yet
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 1) {
          // initial migration placeholder
        }
      },
    );
    return _database!;
  }
}
