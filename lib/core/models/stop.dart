enum StopStatus { upcoming, arrived, skipped }

class Stop {
  Stop({
    required this.id,
    required this.tripId,
    required this.name,
    required this.lat,
    required this.lon,
    this.willSleep = false,
    this.notes,
    this.status = StopStatus.upcoming,
  });

  final String id;
  final String tripId;
  final String name;
  final double lat;
  final double lon;
  final bool willSleep;
  final String? notes;
  final StopStatus status;

  factory Stop.fromMap(Map<String, dynamic> map) {
    return Stop(
      id: map['id'] as String,
      tripId: map['trip_id'] as String,
      name: map['name'] as String,
      lat: (map['lat'] as num).toDouble(),
      lon: (map['lon'] as num).toDouble(),
      willSleep: (map['will_sleep'] as int? ?? 0) == 1,
      notes: map['notes'] as String?,
      status: StopStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'upcoming'),
        orElse: () => StopStatus.upcoming,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'trip_id': tripId,
        'name': name,
        'lat': lat,
        'lon': lon,
        'will_sleep': willSleep ? 1 : 0,
        'notes': notes,
        'status': status.name,
      };
}

