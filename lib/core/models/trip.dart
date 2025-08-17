class Trip {
  Trip({required this.id, required this.name});

  final String id;
  final String name;

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}

