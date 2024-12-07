class Station {
  final int id;
  final String name;
  final String location;
  final String status;
  final List<String> chargerTypes; // List of charger types
  final int totalSlots;
  final bool hasHotels;
  final bool hasRestaurants;
  final bool hasWifi;
  final bool hasParking;
  final bool hasRestrooms;
  // final double latitude; // Added latitude
  // final double longitude; // Added longitude

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.chargerTypes,
    required this.totalSlots,
    required this.hasHotels,
    required this.hasRestaurants,
    required this.hasWifi,
    required this.hasParking,
    required this.hasRestrooms,
    // required this.latitude, // Required latitude
    // required this.longitude, // Required longitude
  });

  // Updated fromJson method to include latitude and longitude
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['station_name'],
      location: json['station_location'],
      status: json['station_status'],
      chargerTypes: (json['charger_types'] as List<dynamic>)
          .map((e) => e['name'] as String)
          .toList(),
      totalSlots: json['total_slots'],
      hasHotels: json['has_hotels'],
      hasRestaurants: json['has_restaurants'],
      hasWifi: json['has_wifi'],
      hasParking: json['has_parking'],
      hasRestrooms: json['has_restrooms'],
      // latitude: json['station_latitude'], // Directly assign as double
      // longitude: json['station_longitude'], // Directly assign as double
    );
  }
}
