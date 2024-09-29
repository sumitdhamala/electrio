import 'package:electrio/view/booking_details.dart';
import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  // Sample booking data
  final List<Map<String, String>> bookings = [
    {
      'stationName': 'CG Motors Charging Station',
      'date': 'October 5, 2024',
      'time': '10:00 AM',
      'portType': 'CCS2',
    },
    {
      'stationName': 'Sunrise EV Station',
      'date': 'October 7, 2024',
      'time': '2:30 PM',
      'portType': 'CHAdeMO',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.green, // Green AppBar
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(booking['stationName']!),
              subtitle: Text(
                'Date: ${booking['date']!}\nTime: ${booking['time']!}\nPort Type: ${booking['portType']!}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // Navigate to BookingDetailsScreen with booking details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsScreen(
                        stationName: booking['stationName']!,
                        date: booking['date']!,
                        time: booking['time']!,
                        portType: booking['portType']!,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
