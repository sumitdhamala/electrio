import 'dart:convert';
import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/view/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingDetailsScreen extends StatefulWidget {
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
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Map<String, dynamic>? bookingDetails; // Holds API response data

  Future<void> _confirmBooking(BuildContext context) async {
    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Convert stationName to station ID
      final stationId = await getStationIdByName(widget.stationName);
      if (stationId == null) {
        throw Exception("Invalid station: ${widget.stationName}");
      }

      // Parse the date string into a proper DateTime format
      final parsedDate = DateFormat.yMMMd().parse(widget.date);

      // Prepare payload
      final payload = {
        "station": stationId.toString(),
        "booked_date": DateFormat('yyyy-MM-dd').format(parsedDate),
        "start_time": widget.time.split(' - ')[0],
        "end_time": widget.time.split(' - ')[1],
      };

      // Make POST request
      final response = await http.post(
        Uri.parse('$url/reserve/reserve/'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Update the state with booking details
        setState(() {
          bookingDetails = responseData;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successfully completed!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete booking: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // Function to fetch station ID by name
  Future<int?> getStationIdByName(String stationName) async {
    try {
      final response = await http.get(Uri.parse('$url/reserve/stations/'));
      if (response.statusCode == 200) {
        final List<dynamic> stationList = jsonDecode(response.body);

        // Perform case-insensitive and trimmed matching
        final station = stationList.firstWhere(
          (station) =>
              station['station_name'].toString().toLowerCase().trim() ==
              stationName.toLowerCase().trim(),
          orElse: () => null,
        );

        return station != null ? station['id'] as int : null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
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
                _buildDetailRow('Station Name:', widget.stationName),
                const SizedBox(height: 12),
                _buildDetailRow('Date:', widget.date),
                const SizedBox(height: 12),
                _buildDetailRow('Time:', widget.time),
                const SizedBox(height: 12),
                _buildDetailRow('Charging Port Type:', widget.portType),
                if (bookingDetails != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(
                      'Total Cost:', '\Rs.${bookingDetails!['total_cost']}'),
                  const SizedBox(height: 12),

                  _buildDetailRow('Booking ID:', '${bookingDetails!['id']}'),
                  // _buildDetailRow('Status:', '${bookingDetails!['status']}'),
                ],
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KhaltiPaymentScreen()));
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
