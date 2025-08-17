import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geolocator/geolocator.dart';

import '../models/poi.dart';
import '../models/stop.dart';
import '../repositories/poi_repository.dart';
import '../repositories/stop_repository.dart';
import '../utils/eta.dart';

final poiRepositoryProvider = Provider<PoiRepository>((ref) {
  return PoiRepository(ref);
});

final poiListProvider = FutureProvider<List<Poi>>((ref) {
  return ref.watch(poiRepositoryProvider).getAll();
});

final poiFiltersProvider = StateProvider<Set<PoiCategory>>((ref) {
  return PoiCategory.values.toSet();
});

final poiSearchQueryProvider = StateProvider<String>((ref) => '');

final visiblePoisProvider = Provider<List<Poi>>((ref) {
  final filters = ref.watch(poiFiltersProvider);
  final query = ref.watch(poiSearchQueryProvider).toLowerCase();
  final poisAsync = ref.watch(poiListProvider);
  return poisAsync.maybeWhen(
    data: (list) => list
        .where((p) =>
            filters.contains(p.category) &&
            p.name.toLowerCase().contains(query))
        .toList(),
    orElse: () => [],
  );
});

// Stops

final stopRepositoryProvider = Provider<StopRepository>((ref) {
  return StopRepository(ref);
});

final activeStopIdProvider = StateProvider<String?>((ref) => null);

final activeStopProvider = FutureProvider<Stop?>((ref) async {
  final id = ref.watch(activeStopIdProvider);
  if (id == null) return null;
  return ref.watch(stopRepositoryProvider).get(id);
});

final positionStreamProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: const LocationSettings(distanceFilter: 25),
  );
});

final etaProvider = Provider<Duration?>((ref) {
  final stopAsync = ref.watch(activeStopProvider);
  final posAsync = ref.watch(positionStreamProvider);
  return stopAsync.maybeWhen(
    data: (stop) {
      if (stop == null) return null;
      return posAsync.maybeWhen(
        data: (pos) {
          final dist = haversineKm(
              pos.latitude, pos.longitude, stop.lat, stop.lon);
          final speedKmh = pos.speed * 3.6;
          return estimateEta(
              km: dist, currentSpeedKmh: speedKmh);
        },
        orElse: () => null,
      );
    },
    orElse: () => null,
  );
});

final stopListProvider = FutureProvider<List<Stop>>((ref) {
  return ref.watch(stopRepositoryProvider).listByTrip('default');
});
