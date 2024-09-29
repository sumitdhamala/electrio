import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String stationName;
  final String date;
  final String time;
  final String portType;

  const BookingDetailsScreen({
    Key? key,
    required this.stationName,
    required this.date,
    required this.time,
    required this.portType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.green, // Green AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Station Name: $stationName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: $time',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Charging Port Type: $portType',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the reservation screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green button
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                ),
                child: const Text('Back to Reservations'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
