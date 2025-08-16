import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/poi.dart';
import '../repositories/poi_repository.dart';

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
