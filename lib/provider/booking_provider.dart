import 'package:electrio/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners(); // Notify listeners to update the UI
  }
}
