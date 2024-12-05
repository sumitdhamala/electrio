import 'package:flutter/material.dart';
import 'package:electrio/model/station_model.dart';

class StationDetailSheet extends StatelessWidget {
  final Station station;

  StationDetailSheet({required this.station});

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder if the data is coming asynchronously
    return FutureBuilder<Station>(
      future:
          _fetchStationDetails(), // Replace with the function to fetch station details
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Handle successful state
        if (snapshot.hasData) {
          Station station = snapshot.data!; // Get the station data
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station Name
                  Text(
                    station.name,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          station.location,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Status
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Status: ${station.status == 'OP' ? 'Open' : 'Closed'}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Charger Types
                  Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Charger Types: ${station.chargerTypes.length}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Total Slots Section
                  Row(
                    children: [
                      Icon(Icons.local_parking, color: Colors.blueGrey),
                      SizedBox(width: 8),
                      Text(
                        'Total Slots: ${station.totalSlots}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Facilities Section
                  Text(
                    'Facilities:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildFacilities(station),
                ],
              ),
            ),
          );
        }

        // If no data
        return Center(child: Text('No data available'));
      },
    );
  }

  // Function to fetch station details (just an example)
  Future<Station> _fetchStationDetails() async {
    // Simulate fetching data from an API or database
    await Future.delayed(Duration(seconds: 2)); // simulate delay

    // Return a mock station for the example
    return Station(
      name: 'Pokhara Station',
      location: 'Pokhara123',
      status: 'OP',
      chargerTypes: [1],
      totalSlots: 1,
      hasHotels: true,
      hasRestaurants: true,
      hasWifi: false,
      hasParking: false,
      hasRestrooms: false,
    );
  }

  // Widget to build the facilities list
  Widget _buildFacilities(Station station) {
    List<Widget> facilities = [];

    if (station.hasHotels) {
      facilities.add(_buildFacilityChip('Hotels', Icons.hotel, Colors.blue));
    }
    if (station.hasRestaurants) {
      facilities.add(
          _buildFacilityChip('Restaurants', Icons.restaurant, Colors.orange));
    }
    if (station.hasWifi) {
      facilities.add(_buildFacilityChip('Wi-Fi', Icons.wifi, Colors.green));
    }
    if (station.hasParking) {
      facilities
          .add(_buildFacilityChip('Parking', Icons.local_parking, Colors.red));
    }
    if (station.hasRestrooms) {
      facilities.add(_buildFacilityChip('Restrooms', Icons.wc, Colors.purple));
    }

    return Wrap(
      spacing: 8.0,
      children: facilities,
    );
  }

  Widget _buildFacilityChip(String label, IconData icon, Color color) {
    return Chip(
      label: Row(
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}
