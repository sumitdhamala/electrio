class Station {
  final String name;
  final String location;
  final String status;
  final List<int> chargerTypes;
  final int totalSlots; // Added this field
  final bool hasHotels;
  final bool hasRestaurants;
  final bool hasWifi;
  final bool hasParking;
  final bool hasRestrooms;

  Station({
    required this.name,
    required this.location,
    required this.status,
    required this.chargerTypes,
    required this.totalSlots, // Include the new field in the constructor
    required this.hasHotels,
    required this.hasRestaurants,
    required this.hasWifi,
    required this.hasParking,
    required this.hasRestrooms,
  });

  // You can add a method to parse data if you are using JSON.
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['station_name'],
      location: json['station_location'],
      status: json['station_status'],
      chargerTypes: List<int>.from(json['charger_types']),
      totalSlots: json['total_slots'], // Parsing the totalSlots from JSON
      hasHotels: json['has_hotels'],
      hasRestaurants: json['has_restaurants'],
      hasWifi: json['has_wifi'],
      hasParking: json['has_parking'],
      hasRestrooms: json['has_restrooms'],
    );
  }

  // Optional: method to convert object back to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'station_name': name,
      'station_location': location,
      'station_status': status,
      'charger_types': chargerTypes,
      'total_slots': totalSlots, // Added totalSlots to the JSON output
      'has_hotels': hasHotels,
      'has_restaurants': hasRestaurants,
      'has_wifi': hasWifi,
      'has_parking': hasParking,
      'has_restrooms': hasRestrooms,
    };
  }
}
