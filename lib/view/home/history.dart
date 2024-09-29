// history_screen.dart
import 'package:electrio/component/customclip_bar.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  // Sample data for the charging history
  final List<ChargingHistory> chargingHistoryList = [
    ChargingHistory(
      stationName: 'CG Motors Charging Station',
      date: '25 Sep 2024',
      price: 15.00,
      location: 'Baglung Highway',
    ),
    ChargingHistory(
      stationName: 'Sunrise EV Station',
      date: '24 Sep 2024',
      price: 10.50,
      location: 'Pokhara Lakeside',
    ),
    ChargingHistory(
      stationName: 'Green Energy Hub',
      date: '23 Sep 2024',
      price: 20.00,
      location: 'Kathmandu Ring Road',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomCurvedAppBar(title: "History", backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: chargingHistoryList.length,
          itemBuilder: (context, index) {
            final history = chargingHistoryList[index];
            return HistoryTile(history: history);
          },
        ),
      ),
    );
  }
}

// Model class for Charging History
class ChargingHistory {
  final String stationName;
  final String date;
  final double price;
  final String location;

  ChargingHistory({
    required this.stationName,
    required this.date,
    required this.price,
    required this.location,
  });
}

// Custom Tile to Display Each Charging History
class HistoryTile extends StatelessWidget {
  final ChargingHistory history;

  const HistoryTile({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Rounded corners for the card
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon representing charging history
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

            // Station details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.stationName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    history.location,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Price and Date information
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${history.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  history.date,
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
    );
  }
}
