import 'package:uuid/uuid.dart';

enum PoiCategory { gas, camp, water, grocery, laundry, custom }

class Poi {
  Poi({
    String? id,
    required this.category,
    required this.name,
    required this.lat,
    required this.lon,
    this.costHint,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final PoiCategory category;
  final String name;
  final double lat;
  final double lon;
  final String? costHint;
  final String? notes;

  Poi copyWith({
    String? id,
    PoiCategory? category,
    String? name,
    double? lat,
    double? lon,
    String? costHint,
    String? notes,
  }) {
    return Poi(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      costHint: costHint ?? this.costHint,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category.name,
        'name': name,
        'lat': lat,
        'lon': lon,
        'cost_hint': costHint,
        'notes': notes,
      };

  factory Poi.fromMap(Map<String, dynamic> map) {
    return Poi(
      id: map['id'] as String,
      category: PoiCategory.values.firstWhere((e) => e.name == map['category'],
          orElse: () => PoiCategory.custom),
      name: map['name'] as String,
      lat: (map['lat'] as num).toDouble(),
      lon: (map['lon'] as num).toDouble(),
      costHint: map['cost_hint'] as String?,
      notes: map['notes'] as String?,
    );
  }
}
