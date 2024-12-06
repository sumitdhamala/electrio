import 'dart:convert';

import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/view/reservation_screen.dart';
import 'package:flutter/material.dart';
import 'package:electrio/model/station_model.dart';
import 'package:http/http.dart' as http;

class StationDetailSheet extends StatelessWidget {
  final Station station;

  StationDetailSheet({required this.station});

  Future<Station> _fetchStationDetails(int stationId) async {
    try {
      final response =
          await http.get(Uri.parse("$url/reserve/stations/$stationId/"));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return Station.fromJson(jsonData);
      } else {
        throw Exception('Failed to load station details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Station>(
      future: _fetchStationDetails(station.id), // Pass station ID dynamically
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          Station station = snapshot.data!;
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
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
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Status: ${_getStatusText(station.status)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                  Text(
                    'Facilities:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildFacilities(station),
                  SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          );
        }

        return Center(child: Text('No data available'));
      },
    );
  }

  /// Map status codes to human-readable text
  String _getStatusText(String status) {
    switch (status) {
      case 'OP':
        return 'Open';
      case 'CL':
        return 'Closed';
      case 'UM':
        return 'Under Maintenance';
      default:
        return 'Unknown';
    }
  }

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

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              print('Get Directions');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Get Directions',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationScreen(station: station)));
              print('Book Now');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Book Now',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
