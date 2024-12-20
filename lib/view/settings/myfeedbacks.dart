import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/component/customclip_bar.dart';
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
      appBar: CustomCurvedAppBar(title: "My Feedbacks"),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = _feedbacks[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Row with Station Name and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              feedback['station_details']['station_name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            _buildRatingStars(feedback['rating']),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        // Station Location below the name
                        Text(
                          feedback['station_details']['station_location'] ??
                              'Location not available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Feedback Text
                        Text(
                          feedback['feedback'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8.0),
                        // Feedback Date
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
