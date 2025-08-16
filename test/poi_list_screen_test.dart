import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roadtrip_sidekick/core/models/poi.dart';
import 'package:roadtrip_sidekick/core/providers/providers.dart';
import 'package:roadtrip_sidekick/features/poi/poi_list_screen.dart';

void main() {
  testWidgets('filters by search query', (tester) async {
    final testPois = [
      Poi(id: '1', category: PoiCategory.gas, name: 'Gas One', lat: 0, lon: 0),
      Poi(
          id: '2',
          category: PoiCategory.water,
          name: 'Water Spot',
          lat: 0,
          lon: 0),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          poiListProvider.overrideWith((ref) async => testPois),
        ],
        child: const MaterialApp(home: PoiListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(2));
    await tester.enterText(find.byType(TextField), 'gas');
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsOneWidget);
  });
}
