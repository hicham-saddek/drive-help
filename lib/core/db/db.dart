import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

class Db {
  Db._();
  static final DatabaseService _service = DatabaseService();

  static Future<Database> getDatabase() => _service.getDatabase();
}
