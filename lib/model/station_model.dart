class Station {
  final int id;
  final String name;
  final String location;
  final String status;
  final List<int> chargerTypes;
  final int totalSlots;
  final bool hasHotels;
  final bool hasRestaurants;
  final bool hasWifi;
  final bool hasParking;
  final bool hasRestrooms;

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
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['station_name'],
      location: json['station_location'],
      status: json['station_status'],
      chargerTypes: List<int>.from(json['charger_types']),
      totalSlots: json['total_slots'],
      hasHotels: json['has_hotels'],
      hasRestaurants: json['has_restaurants'],
      hasWifi: json['has_wifi'],
      hasParking: json['has_parking'],
      hasRestrooms: json['has_restrooms'],
    );
  }
}
