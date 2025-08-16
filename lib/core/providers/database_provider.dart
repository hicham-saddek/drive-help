import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../db/db.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  return Db.getDatabase();
});
