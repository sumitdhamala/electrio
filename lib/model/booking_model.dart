class Booking {
  final String stationName;
  final String date;
  final String time;
  final String portType;
  final double? price;
  final String? location;

  Booking({
    required this.stationName,
    required this.date,
    required this.time,
    required this.portType,
    this.price,
    this.location,
  });
}
