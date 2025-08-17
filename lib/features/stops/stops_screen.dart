import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/widgets/location_permission_banner.dart';

class StopsScreen extends ConsumerWidget {
  const StopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopsAsync = ref.watch(stopListProvider);
    final activeId = ref.watch(activeStopIdProvider);

    return Column(
      children: [
        const LocationPermissionBanner(),
        Expanded(
          child: stopsAsync.when(
            data: (stops) => ListView.builder(
              itemCount: stops.length,
              itemBuilder: (context, index) {
                final stop = stops[index];
                return ListTile(
                  title: Text(stop.name),
                  subtitle: Text('${stop.lat}, ${stop.lon}'),
                  trailing: IconButton(
                    icon: Icon(activeId == stop.id
                        ? Icons.flag
                        : Icons.outlined_flag),
                    onPressed: () {
                      ref
                          .read(stopRepositoryProvider)
                          .setActiveStop(stop.id);
                      ref
                          .read(activeStopIdProvider.notifier)
                          .state = stop.id;
                    },
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

