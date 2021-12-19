class UserLocation {
  final double lat;
  final double long;
  UserLocation({
    required this.lat,
    required this.long,
  });

  factory UserLocation.fromMap(Map<String, dynamic> json) {
    return UserLocation(lat: json['lat'], long: json['long']);
  }
}
