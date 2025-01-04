class Address {
  final String id;
  final String name;
  final num lon;
  final num lat;
  final num distance;

  Address({
    required this.id,
    required this.name,
    required this.lon,
    required this.lat,
    required this.distance,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lon': lon,
      'lat': lat,
      'distance': distance,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '', // Provide a default value if null
      name: json['name'] ?? '', // Provide a default value if null
      lon: (json['lon'] ?? 0).tonum(),
      lat: (json['lat'] ?? 0).tonum(),
      distance: (json['distance'] ?? 0).tonum(),
    );
  }
}
