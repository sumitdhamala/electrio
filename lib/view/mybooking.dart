import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/provider/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(title: "My Bookings"),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.bookings.isEmpty) {
            return Center(child: Text('No bookings available.'));
          }

          return ListView.builder(
            itemCount: bookingProvider.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingProvider.bookings[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(booking.stationName),
                  subtitle: Text(
                    'Date: ${booking.date}\nTime: ${booking.time}\nPort Type: ${booking.portType}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
