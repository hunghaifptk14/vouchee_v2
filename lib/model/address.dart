class Address {
  final String id;
  final String name;
  final double lon;
  final double lat;
  final double distance;

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
      lon: (json['lon'] ?? 0).toDouble(),
      lat: (json['lat'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
    );
  }
}
