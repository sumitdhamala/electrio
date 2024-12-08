// BookingResponse Model (Represents data coming from the booking endpoint)
class BookingResponse {
  final int station;
  final String bookedDate;
  final String startTime;
  final String endTime;
  final String totalCost;

  BookingResponse({
    required this.station,
    required this.bookedDate,
    required this.startTime,
    required this.endTime,
    required this.totalCost,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      station: json['station'],
      bookedDate: json['booked_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalCost: json['total_cost'],
    );
  }
}

// StationDetails Model (Represents data coming from the station endpoint)
class StationDetails {
  final String name;
  final String portType;
  final String location;

  StationDetails({
    required this.name,
    required this.portType,
    required this.location,
  });

  factory StationDetails.fromJson(Map<String, dynamic> json) {
    return StationDetails(
      name: json['name'],
      portType: json['port_type'],
      location: json['location'],
    );
  }
}
