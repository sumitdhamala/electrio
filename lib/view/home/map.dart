import 'package:electrio/component/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class HomeView extends StatefulWidget {
   final LatLng? fallbackRouteDestination; // Add fallback route parameter

  const HomeView({super.key, this.fallbackRouteDestination});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(28.2096, 83.9856); // Default location
  List<Map<String, dynamic>> _chargingStations = [];
  LatLng? _selectedStationLocation;
  String? _routeSummary;
  List<LatLng> _routePoints = [];
  Timer? _statusRefreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchChargingStations();
    _startStatusRefreshTimer();
    _getUserLocation();

    // Trigger route calculation if fallback destination is provided
    if (widget.fallbackRouteDestination != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getRouteToStation(widget.fallbackRouteDestination!);
      });
    }
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchChargingStations() async {
    try {
      final response = await http.get(Uri.parse('$url/reserve/stations/'));
      if (response.statusCode == 200) {
        setState(() {
          _chargingStations =
              List<Map<String, dynamic>>.from(json.decode(response.body))
                  .map((station) {
            // Parse charger types independently
            station['charger_types'] = (station['charger_types'] as List)
                .map((type) => type['name'].toString()) // Extract type names
                .toList();
            return station;
          }).toList();
        });
      } else {
        throw Exception('Failed to fetch charging stations');
      }
    } catch (e) {
      print('Error fetching charging stations: $e');
    }
  }

  void _startStatusRefreshTimer() {
    _statusRefreshTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchChargingStations();
    });
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    // Updated: Use LocationSettings instead of deprecated desiredAccuracy
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy location
      distanceFilter: 10, // Minimum distance in meters to notify
    );

    // Get the current position of the user
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    print("Current Location: $_currentLocation");
  }

  Future<void> _getRouteToStation(LatLng destination) async {
    final url = 'https://router.project-osrm.org/route/v1/driving/'
        '${_currentLocation.longitude},${_currentLocation.latitude};'
        '${destination.longitude},${destination.latitude}?geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];
        setState(() {
          _routePoints = decodePolyline(route['geometry']['coordinates']);
          _routeSummary =
              '${(route['distance'] / 1000).toStringAsFixed(2)} km, '
              '${(route['duration'] / 60).toStringAsFixed(0)} min';
        });
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> decodePolyline(List<dynamic> coordinates) {
    return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
  }

  Widget _buildPopupContent(Map<String, dynamic> station) {
    print("Current Location: $_currentLocation");

    final chargerTypes = station['charger_types'] != null
        ? (station['charger_types'] as List<dynamic>)
            .map((type) => type.toString())
            .join(", ")
        : "N/A";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          station['station_name'],
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        SizedBox(height: 8),
        Text(
          'Location: ${station['station_location']}',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Chip(
              label: Text('Slots: ${station['total_slots']}'),
              backgroundColor: Colors.green.shade100,
              avatar: Icon(Icons.battery_charging_full, size: 16),
            ),
            SizedBox(width: 8),
            Chip(
              label: Text('Types: $chargerTypes'),
              backgroundColor: Colors.green.shade100,
              avatar: Icon(Icons.power, size: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            if (station['has_wifi'])
              Chip(
                label: Text('Wi-Fi'),
                avatar: Icon(Icons.wifi, size: 16),
                backgroundColor: Colors.green.shade100,
              ),
            if (station['has_parking'])
              Chip(
                label: Text('Parking'),
                avatar: Icon(Icons.local_parking, size: 16),
                backgroundColor: Colors.green.shade100,
              ),
            if (station['has_restrooms'])
              Chip(
                label: Text('Restrooms'),
                avatar: Icon(Icons.wc, size: 16),
                backgroundColor: Colors.green.shade100,
              ),
            if (station['has_restaurants'])
              Chip(
                label: Text('Restaurant'),
                avatar: Icon(Icons.restaurant, size: 16),
                backgroundColor: Colors.green.shade100,
              ),
          ],
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            final destination = LatLng(
              double.parse(station['station_latitude']),
              double.parse(station['station_longitude']),
            );
            _getRouteToStation(destination);

            setState(() {
              _selectedStationLocation = null;
            });
          },
          icon: Icon(Icons.directions),
          label: Text('Get Directions'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        if (_routeSummary != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Route: $_routeSummary',
                style: TextStyle(color: Colors.grey)),
          ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedStationLocation = null; // Dismiss the popup
            });
          },
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Charging Stations'), backgroundColor: Colors.green),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 13.0,
              onTap: (_, __) => setState(() => _selectedStationLocation = null),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: _currentLocation,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  ..._chargingStations.map((station) {
                    final stationLocation = LatLng(
                      double.parse(station['station_latitude']),
                      double.parse(station['station_longitude']),
                    );
                    return Marker(
                      width: 80,
                      height: 80,
                      point: stationLocation,
                      child: GestureDetector(
                        onTap: () => setState(
                            () => _selectedStationLocation = stationLocation),
                        child: Icon(Icons.ev_station,
                            color: Colors.green, size: 40),
                      ),
                    );
                  }).toList(),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    strokeWidth: 4.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
          if (_selectedStationLocation != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: EdgeInsets.all(16.0),
                color: Colors.grey.shade100,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 350),
                  padding: EdgeInsets.all(16.0),
                  child: _buildPopupContent(
                      _chargingStations.firstWhere((station) =>
                          LatLng(
                            double.parse(station['station_latitude']),
                            double.parse(station['station_longitude']),
                          ) ==
                          _selectedStationLocation)),
                ),
              ),
            ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () => _mapController.move(_currentLocation, 13.0),
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
