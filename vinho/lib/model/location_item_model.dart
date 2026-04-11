class LocationItem {
  final String id; // VIANA_DO_CASTELO
  final String name; // Viana do Castelo
  final LocationType type; // district | municipality
  final String? parentId; // distrito (para município)

  const LocationItem({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
  });

  factory LocationItem.fromMap(Map<String, dynamic> map) {
    return LocationItem(
      id: map['id'],
      name: map['name'],
      type: LocationType.values.byName(map['type']),
      parentId: map['parentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'parentId': parentId,
    };
  }
}

enum LocationType {
  district,
  municipality,
}
