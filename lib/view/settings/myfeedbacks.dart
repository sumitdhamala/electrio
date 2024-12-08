import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class UserFeedbacksScreen extends StatefulWidget {
  @override
  _UserFeedbacksScreenState createState() => _UserFeedbacksScreenState();
}

class _UserFeedbacksScreenState extends State<UserFeedbacksScreen> {
  List<Map<String, dynamic>> _feedbacks = [];
  Map<int, String> _stationNames = {}; // Cache station names
  bool _isLoading = true;

  Future<void> _fetchFeedbacks() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication required. Please log in again.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$url/feedbacks/feedbacks/'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _feedbacks =
              data.map((item) => item as Map<String, dynamic>).toList();
          _isLoading = false;
        });

        // Fetch station names for all unique station IDs
        final stationIds = _feedbacks.map((f) => f['station']).toSet();
        for (final id in stationIds) {
          await _fetchStationName(id, token);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch feedbacks.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _fetchStationName(int stationId, String token) async {
    if (_stationNames.containsKey(stationId)) return;

    try {
      final response = await http.get(
        Uri.parse('$url/stations/$stationId/'), // Make sure this URL is correct
        headers: {
          'Authorization': 'Token $token',
        },
      );

      print("Response Status: ${response.statusCode}");
      print(
          "Response Body: ${response.body}"); // Log the full response for inspection

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Station data: $data'); // Log the response data for inspection

        if (data.containsKey('name')) {
          setState(() {
            _stationNames[stationId] = data['name'] ?? "Unknown Station";
          });
        } else {
          setState(() {
            _stationNames[stationId] = "Name Not Available";
          });
        }
      } else {
        print(
            'Failed to fetch station name. Status Code: ${response.statusCode}');
        setState(() {
          _stationNames[stationId] = "Error Fetching Name";
        });
      }
    } catch (e) {
      print("Error fetching station name: $e");
      setState(() {
        _stationNames[stationId] = "Error Fetching Name";
      });
    }
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          color: index < rating ? Colors.green : Colors.grey,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Feedbacks'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = _feedbacks[index];
                final stationName =
                    _stationNames[feedback['station']] ?? "Loading...";

                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          stationName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          feedback['feedback'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8.0),
                        _buildRatingStars(feedback['rating']),
                        SizedBox(height: 8.0),
                        Text(
                          'Date: ${feedback['feedback_time'].substring(0, 10)}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
