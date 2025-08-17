import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/eta.dart';
import '../map/map_screen.dart';
import '../stops/stops_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(poiListProvider).maybeWhen(
          data: (list) => list.length,
          orElse: () => 0,
        );
    final activeStopAsync = ref.watch(activeStopProvider);
    final positionAsync = ref.watch(positionStreamProvider);
    final eta = ref.watch(etaProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: Text('POIs: $count'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                );
              },
              child: const Text('Open Map'),
            ),
          ),
        ),
        Card(
          child: activeStopAsync.when(
            data: (stop) {
              if (stop == null) {
                return const ListTile(title: Text('No active stop'));
              }
              final pos = positionAsync.asData?.value;
              String distanceStr = '--';
              if (pos != null) {
                final d = haversineKm(
                    pos.latitude, pos.longitude, stop.lat, stop.lon);
                distanceStr = '${d.toStringAsFixed(1)} km';
              }
              final etaStr = eta == null
                  ? '—'
                  : '${eta.inHours}:${(eta.inMinutes % 60).toString().padLeft(2, '0')}';
              return ListTile(
                title: Text('${stop.name} • $distanceStr • ETA $etaStr'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const StopsScreen()),
                    );
                  },
                  child: const Text('Open Stops'),
                ),
              );
            },
            loading: () => const ListTile(title: Text('Loading active stop...')),
            error: (e, st) => ListTile(title: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
