import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:electrio/component/constants/constants.dart';
import 'package:electrio/component/custom_station_tile.dart';
import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/model/station_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'station_detail_sheet.dart';

class StationsScreen extends StatefulWidget {
  @override
  _StationsScreenState createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  List<Station> stations = [];
  List<Station> filteredStations = [];
  List<String> notifications = []; // Store notifications
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';
  Position? userLocation;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchStations();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon'); // Add your app icon
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<Position?> _getUserLocation() async {
    try {
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      return await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
    } catch (e) {
      print('Error getting user location: $e');
      return null;
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c * 1.2;
  }

  Future<void> _showNearbyNotification(List<Station> nearbyStations) async {
    final notificationTitle = "Nearby Charging Stations";
    final notificationBody =
        "Found ${nearbyStations.length} station(s) within 5km.";
    notifications.add(notificationBody); // Store notification

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'nearby_stations_channel',
      'Nearby Stations',
      channelDescription: 'Notifications for nearby charging stations',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notificationTitle,
      notificationBody,
      platformDetails,
    );
  }

  Future<void> _fetchStations() async {
    try {
      userLocation = await _getUserLocation();
      print(
          "User Location: ${userLocation?.latitude}, ${userLocation?.longitude}");

      final response = await http.get(Uri.parse('$url/reserve/stations/'));

      if (response.statusCode == 200) {
        final List<dynamic> stationList = json.decode(response.body);

        List<Station> fetchedStations =
            stationList.map((data) => Station.fromJson(data)).toList();

        List<Station> nearbyStations = [];

        if (userLocation != null) {
          for (var station in fetchedStations) {
            if (station.latitude != null && station.longitude != null) {
              station.distance = _calculateDistance(
                userLocation!.latitude,
                userLocation!.longitude,
                station.latitude!,
                station.longitude!,
              );

              if (station.distance! <= 5) {
                nearbyStations.add(station);
              }
            } else {
              station.distance = double.infinity;
            }
          }
          fetchedStations.sort((a, b) => a.distance!.compareTo(b.distance!));
        }

        if (nearbyStations.isNotEmpty) {
          _showNearbyNotification(nearbyStations);
        }

        setState(() {
          stations = fetchedStations;
          filteredStations = fetchedStations;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load stations';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching stations: $e';
        isLoading = false;
      });
    }
  }

  void _filterStations(String query) {
    final filtered = stations
        .where((station) =>
            station.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      searchQuery = query;
      filteredStations = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: 'Stations',
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterStations,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by station name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = filteredStations[index];
                          return GestureDetector(
                            onTap: () => _showStationDetails(context, station),
                            child: CustomStationTile(
                              icon: Icons.ev_station_outlined,
                              title: station.name,
                              subtitle: station.location,
                              distance: station.distance,
                              status: station.status,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showStationDetails(BuildContext context, Station station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: StationDetailSheet(station: station),
            ),
          ),
        );
      },
    );
  }
}
