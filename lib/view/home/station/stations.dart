import 'dart:convert';
import 'package:electrio/component/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:electrio/model/station_model.dart';
import 'package:electrio/component/custom_station_tile.dart';
import 'package:electrio/component/customclip_bar.dart';
import 'station_detail_sheet.dart';

class StationsScreen extends StatefulWidget {
  @override
  _StationsScreenState createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  List<Station> stations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStations();
  }

  Future<void> _fetchStations() async {
    try {
      final response = await http.get(Uri.parse('$url/reserve/stations/'));

      if (response.statusCode == 200) {
        final List<dynamic> stationList = json.decode(response.body);

        setState(() {
          stations = stationList.map((data) => Station.fromJson(data)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: 'Stations',
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    return GestureDetector(
                      onTap: () => _showStationDetails(context, station),
                      child: CustomStationTile(
                        icon: Icons.ev_station_outlined,
                        title: station.name,
                        subtitle: station.location,
                        status: station.status,
                      ),
                    );
                  },
                ),
    );
  }

  void _showStationDetails(BuildContext context, Station station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StationDetailSheet(station: station),
    );
  }
}
