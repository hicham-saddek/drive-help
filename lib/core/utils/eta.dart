import 'dart:math';

double haversineKm(
    double lat1, double lon1, double lat2, double lon2) {
  const r = 6371.0; // Earth radius in km
  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return r * c;
}

double _degToRad(double deg) => deg * pi / 180.0;

Duration estimateEta({
  required double km,
  double? currentSpeedKmh,
  double avgSpeedKmh = 70,
}) {
  if (km < 0.2) return Duration.zero;
  var speed =
      (currentSpeedKmh != null && currentSpeedKmh >= 5) ? currentSpeedKmh : avgSpeedKmh;
  speed = speed.clamp(30, 120);
  final hours = km / speed;
  return Duration(seconds: (hours * 3600).round());
}

