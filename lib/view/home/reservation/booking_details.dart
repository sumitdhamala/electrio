import 'dart:convert';
import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/component/customclip_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _confirmBooking(BuildContext context) async {
    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Convert stationName to station ID (implement logic to fetch or map the ID)
      final stationId = int.tryParse(stationName) ??
          0; // Replace with actual ID retrieval logic

      // Convert time to ISO 8601 format (assumes date and time are provided)
      final startDateTime =
          DateTime.parse('$date ${time.split(' - ')[0]}:00').toIso8601String();
      final endDateTime =
          DateTime.parse('$date ${time.split(' - ')[1]}:00').toIso8601String();

      // Use the selected date as the booked_date (from the reservation screen)
      final bookedDate = DateTime.parse(date)
          .toIso8601String(); // Assuming date is in 'YYYY-MM-DD' format

      final payload = {
        "station": stationId, // Pass station ID
        "start_time": startDateTime,
        "end_time": endDateTime,
        "booked_date": bookedDate, // Use selected date as booked_date
      };

      final response = await http.post(
        Uri.parse('$url/reserve/reserve/'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        // Success: Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successfully completed!')),
        );
      } else {
        print('Failed to complete booking: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to complete booking: ${response.body}')),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(title: "Booking Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Confirmation',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Station Name:', stationName),
                const SizedBox(height: 12),
                _buildDetailRow('Date:', date),
                const SizedBox(height: 12),
                _buildDetailRow('Time:', time),
                const SizedBox(height: 12),
                _buildDetailRow('Charging Port Type:', portType),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _confirmBooking(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Back to Reservations',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          // Add your payment navigation logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Navigate to payment screen.')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: BorderSide(color: Colors.green),
                        ),
                        child: const Text(
                          'Make Payment',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
