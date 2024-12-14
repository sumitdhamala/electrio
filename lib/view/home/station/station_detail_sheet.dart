import 'dart:convert';

import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/view/home/map.dart';
import 'package:electrio/view/home/reservation/reservation_screen.dart';
import 'package:electrio/view/home/station/station_feedback.dart';
import 'package:flutter/material.dart';
import 'package:electrio/model/station_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StationDetailSheet extends StatefulWidget {
  final Station station;

  const StationDetailSheet({super.key, required this.station});

  @override
  State<StationDetailSheet> createState() => _StationDetailSheetState();
}

class _StationDetailSheetState extends State<StationDetailSheet> {
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

  Future<List<StationFeedback>> _fetchStationFeedbacks(int stationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Authorization token is missing');
      }

      final response = await http.get(
        Uri.parse("$url/feedbacks/feedback/stations/$stationId/"),
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );

      print("Fetching feedbacks for station $stationId");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> feedbackList = jsonDecode(response.body);
        return feedbackList
            .map((feedback) => StationFeedback(
                  username: feedback['user_name'],
                  rating: feedback['rating'],
                  feedback: feedback['feedback'],
                ))
            .toList();
      } else {
        print('Server error: ${response.body}');
        throw Exception('Failed to load feedbacks');
      }
    } catch (e) {
      print('Error fetching feedbacks: $e');
      throw Exception('Error fetching feedbacks: $e');
    }
  }

  Future<double> _calculateAverageRating(int stationId) async {
    try {
      List<StationFeedback> feedbacks = await _fetchStationFeedbacks(stationId);
      if (feedbacks.isEmpty) return 0.0;

      double totalRating =
          feedbacks.fold(0.0, (sum, feedback) => sum + feedback.rating);
      return totalRating / feedbacks.length;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Station>(
      future: _fetchStationDetails(widget.station.id),
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
                  FutureBuilder<double>(
                    future: _calculateAverageRating(station.id),
                    builder: (context, avgSnapshot) {
                      if (avgSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text(
                          station.name,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        );
                      }

                      double averageRating = avgSnapshot.data ?? 0.0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            station.name,
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.green, size: 20),
                              SizedBox(width: 5),
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        List<StationFeedback> feedbacks =
                            await _fetchStationFeedbacks(station.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StationFeedbacksScreen(
                              stationName: station.name,
                              feedbacks: feedbacks,
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Error fetching feedbacks: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error loading feedbacks!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'View Feedbacks',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: Text('No data available'));
      },
    );
  }

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

  void _redirectToAppMapPage(BuildContext context, Station station) {
    final destination = LatLng(
      double.parse("${station.latitude}"),
      double.parse("${station.longitude}"),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeView(
          fallbackRouteDestination: destination,
        ),
      ),
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
            onPressed: () async {
              try {
                Position position = await Geolocator.getCurrentPosition(
                    locationSettings:
                        LocationSettings(accuracy: LocationAccuracy.high));

                final userLatitude = position.latitude;
                final userLongitude = position.longitude;
                final destinationLatitude =
                    double.parse("${widget.station.latitude}");
                final destinationLongitude =
                    double.parse("${widget.station.longitude}");

                final googleMapsUrl =
                    "https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$destinationLatitude,$destinationLongitude&travelmode=driving";

                if (await canLaunchUrlString(googleMapsUrl)) {
                  await launchUrlString(googleMapsUrl);
                } else {
                  throw "Could not launch Google Maps.";
                }
              } catch (e) {
                print('Error launching Google Maps: $e');
                _redirectToAppMapPage(context, widget.station);
              }
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReservationScreen(station: widget.station)));
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

class StationFeedback {
  final String username;
  final double rating;
  final String feedback;

  StationFeedback({
    required this.username,
    required this.rating,
    required this.feedback,
  });
}
