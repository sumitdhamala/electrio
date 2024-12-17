import 'package:electrio/view/home/station/station_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:electrio/component/customclip_bar.dart';

class StationFeedbacksScreen extends StatelessWidget {
  final String stationName;
  final List<StationFeedback> feedbacks; // Use StationFeedback here

  const StationFeedbacksScreen({
    Key? key,
    required this.stationName,
    required this.feedbacks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: "Feedbacks",
        backgroundColor: Colors.green,
      ),
      body: feedbacks.isEmpty
          ? Center(
              child: Text(
                'No feedbacks available for this station.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder( 
              padding: const EdgeInsets.all(8.0),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("${feedback.username}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  "($stationName)",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  Icons.star,
                                  color: starIndex < feedback.rating.toInt()
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 16,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feedback.feedback,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
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
