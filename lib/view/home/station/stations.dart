// stations.dart
import 'package:electrio/component/custom_station_tile.dart';
import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/model/station_model.dart';
import 'package:flutter/material.dart';
import 'station_detail_sheet.dart';

class StationsScreen extends StatelessWidget {
  final List<Station> stations = [
    Station(
      name: 'CG Motors Charging Station',
      address: 'Baglung Highway, Nepal',
      status: 'Open',
    ),
    Station(
      name: 'Sunrise EV Station',
      address: 'Pokhara Lakeside, Nepal',
      status: 'Closed',
    ),
    Station(
      name: 'Green Energy Hub',
      address: 'Kathmandu Ring Road, Nepal',
      status: 'Open',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: 'Stations',
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];
          return GestureDetector(
            onTap: () => _showStationDetails(context, station),
            child: CustomStationTile(
              icon: Icons.ev_station_outlined,
              title: station.name,
              subtitle: station.address,
              status: station.status,
            ),
          );
        },
      ),
    );
  }

  // Function to show the bottom sliding sheet
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
