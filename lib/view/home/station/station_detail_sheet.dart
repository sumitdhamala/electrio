import 'package:electrio/model/station_model.dart';
import 'package:electrio/view/reservation_screen.dart';
import 'package:flutter/material.dart';

class StationDetailSheet extends StatelessWidget {
  final Station station;

  const StationDetailSheet({Key? key, required this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://via.placeholder.com/100', // Replace with actual image URL
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      station.address,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // Add contact functionality here
                      },
                      child: Row(
                        children: [
                          Icon(Icons.phone,
                              color: Colors.green.shade600), // Changed to green
                          const SizedBox(width: 4),
                          Text(
                            'Contact Station',
                            style: TextStyle(
                                color:
                                    Colors.green.shade600), // Changed to green
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.favorite_border,
                color: Colors.redAccent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plugs',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.power_outlined,
                          color: Colors.green), // Changed to green
                      const SizedBox(width: 4),
                      const Text('CCS2 - 7.2Kw AC'),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amenities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_parking,
                          color: Colors.green), // Changed to green
                      const SizedBox(width: 8),
                      Icon(Icons.wc, color: Colors.green), // Changed to green
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add get direction functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Changed to green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Get Direction',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationScreen(station: station),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: BorderSide(color: Colors.green), // Changed to green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Book Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
