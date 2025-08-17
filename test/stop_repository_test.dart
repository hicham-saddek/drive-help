import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadtrip_sidekick/core/models/stop.dart';
import 'package:roadtrip_sidekick/core/providers/database_provider.dart';
import 'package:roadtrip_sidekick/core/providers/providers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  test('CRUD and active stop persistence', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE trips(id TEXT PRIMARY KEY, name TEXT);
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
              );
            ''');
            await db.execute('''
              CREATE TABLE settings(
                id INTEGER PRIMARY KEY,
                offline_tiles_path TEXT,
                active_stop_id TEXT
              );
            ''');
            await db.insert('settings', {
              'id': 1,
              'offline_tiles_path': null,
              'active_stop_id': null
            });
          },
        ));

    final container = ProviderContainer(overrides: [
      databaseProvider.overrideWith((ref) => Future.value(db)),
    ]);
    addTearDown(container.dispose);
    final repo = container.read(stopRepositoryProvider);

    final stop = Stop(
        id: '1',
        tripId: 'default',
        name: 'Test',
        lat: 1,
        lon: 2);
    await repo.insert(stop);
    expect((await repo.listByTrip('default')).length, 1);

    await repo.setActiveStop('1');
    expect(await repo.getActiveStopId(), '1');

    await repo.delete('1');
    expect((await repo.listByTrip('default')).length, 0);
  });
}

