import 'dart:convert';
import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/view/payment/payment.dart';
import 'package:electrio/view/settings/feedback.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:electrio/component/customclip_bar.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token == null || token.isEmpty) {
      setState(() {
        errorMessage = 'User not authenticated';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$url/reserve/reserve/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          bookings = data
              .map((booking) => {
                    'stationName': booking['station_details']['station_name'],
                    'stationLocation': booking['station_details']
                        ['station_location'],
                    'date': booking['booked_date'],
                    'time': "${booking['start_time']} - ${booking['end_time']}",
                    'price': double.tryParse(booking['total_cost']) ?? 0.0,
                    'stationid': booking['station'],
                    'user': booking['user']
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch bookings');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: "My Bookings",
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : bookings.isEmpty
                  ? Center(child: Text('No bookings available.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return HistoryTile(booking: booking);
                      },
                    ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final Map<String, dynamic> booking;

  const HistoryTile({Key? key, required this.booking}) : super(key: key);

  String formatTime(String time) {
    // Parse the time string
    final parsedTime = DateFormat("HH:mm:ss").parse(time);
    // Format to hh:mm
    return DateFormat("HH:mm").format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Station Details Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.ev_station,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['stationName'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text(
                            booking['stationLocation'],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            booking['date'],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${formatTime(booking['time'].split(' - ')[0])} - ${formatTime(booking['time'].split(' - ')[1])}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '₹${booking['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KhaltiPaymentScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text("Make Payment"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FeedbackScreen(stationId: booking['stationid']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text("Give Feedback"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
