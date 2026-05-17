class Place {
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final double? distance; // distance in meters from current location

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.distance,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Unknown Place',
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
      address: json['display_name'],
    );
  }
} 