import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/poi.dart';
import '../../core/providers/providers.dart';

class PoiListScreen extends ConsumerWidget {
  const PoiListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pois = ref.watch(visiblePoisProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('POIs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (v) =>
                  ref.read(poiSearchQueryProvider.notifier).state = v,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in PoiCategory.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(c.name),
                      selected: ref.watch(poiFiltersProvider).contains(c),
                      onSelected: (v) {
                        final filters = ref.read(poiFiltersProvider.notifier);
                        final set = {...filters.state};
                        if (v) {
                          set.add(c);
                        } else {
                          set.remove(c);
                        }
                        filters.state = set;
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pois.length,
              itemBuilder: (context, index) {
                final p = pois[index];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text(p.category.name),
                  onTap: () => Navigator.pop(context, p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
