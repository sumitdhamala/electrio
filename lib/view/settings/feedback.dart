import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  final int stationId; // Pass the station ID as a parameter

  FeedbackScreen({required this.stationId});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  int? _selectedRating; // Use `int?` to allow `null` for unselected ratings

  Future<void> _submitFeedback() async {
    if (_selectedRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a rating before submitting.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide feedback.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Get the token from UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Authentication required. Please log in again.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Prepare data to send
    final payload = {
      "station": widget.stationId.toString(),
      "feedback": feedback,
      "rating": _selectedRating.toString(), // Safely convert rating to string
    };

    print("Payload: $payload"); // Log payload for debugging

    try {
      final response = await http.post(
        Uri.parse('$url/feedbacks/feedbacks/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // Include the auth token
        },
        body: jsonEncode(payload),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ));

        // Clear the inputs after submission
        setState(() {
          _selectedRating = null; // Reset rating to null
          _feedbackController.clear();
        });
      } else {
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to submit feedback: ${responseBody['error'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
      ));
      print("Error: $e");
    }
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            Icons.star,
            color: starIndex <= (_selectedRating ?? 0)
                ? Colors.green
                : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _selectedRating = starIndex;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'We value your feedback!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'How would you rate your experience?',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            _buildRatingStars(),
            SizedBox(height: 16.0),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
