import 'dart:convert';
import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/model/booking_model.dart';
import 'package:electrio/model/bookingresponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

 

  // Fetch bookings from the API
  Future<void> fetchBookings() async {
    final response = await http.get(Uri.parse('$url/reserve/reserve/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      print(
          'Fetched bookings: $data'); // Debug print to check if data is fetched

      _bookings = await Future.wait(
        data.map((bookingData) async {
          final bookingResponse = BookingResponse.fromJson(bookingData);

          // Fetch station details based on the station ID from the booking response
          final stationDetails =
              await _fetchStationDetails(bookingResponse.station);

          // Return mapped booking data
          return _mapBookingResponseToBooking(bookingResponse, stationDetails);
        }),
      );
      print(
          'Mapped bookings: $_bookings'); // Debug print to check the mapped bookings

      notifyListeners();
    } else {
      print('Failed to load bookings with status code: ${response.statusCode}');
      throw Exception('Failed to load bookings');
    }
  }

  // Fetch station details using stationId
  Future<StationDetails> _fetchStationDetails(int stationId) async {
    final response =
        await http.get(Uri.parse('$url/reserve/stations/$stationId'));

    if (response.statusCode == 200) {
      final stationData = json.decode(response.body);
      return StationDetails.fromJson(stationData);
    } else {
      throw Exception('Failed to load station details');
    }
  }

  // Map BookingResponse and StationDetails to Booking
  Booking _mapBookingResponseToBooking(
    BookingResponse bookingResponse,
    StationDetails stationDetails,
  ) {
    return Booking(
      stationName: stationDetails.name,
      portType: stationDetails.portType,
      location: stationDetails.location,
      date: bookingResponse.bookedDate,
      time: "${bookingResponse.startTime} - ${bookingResponse.endTime}",
      price: double.tryParse(bookingResponse.totalCost) ?? 0.0, // Price field
    );
  }
}
