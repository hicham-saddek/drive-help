import 'package:flutter_test/flutter_test.dart';

import 'package:roadtrip_sidekick/core/utils/eta.dart';

void main() {
  test('haversineKm zero distance', () {
    final d = haversineKm(0, 0, 0, 0);
    expect(d, closeTo(0, 0.0001));
  });

  test('estimateEta uses current speed when available', () {
    final eta = estimateEta(km: 70, currentSpeedKmh: 100);
    expect(eta.inMinutes, 42);
  });

  test('estimateEta clamps avg speed and ignores slow current speed', () {
    final eta = estimateEta(km: 140, currentSpeedKmh: 3, avgSpeedKmh: 10);
    // avg speed clamped to 30 => 140/30 h = 4.666h = 280 min
    expect(eta.inMinutes, 280);
  });

  test('estimateEta returns zero for very short distance', () {
    final eta = estimateEta(km: 0.1, currentSpeedKmh: 80);
    expect(eta, Duration.zero);
  });
}

