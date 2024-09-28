// stations.dart
import 'package:electrio/component/customclip_bar.dart';
import 'package:flutter/material.dart';

class StationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: 'Stations',
        backgroundColor: Colors.green, // You can change the color if needed
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          CustomStationTile(
            icon: Icons.ev_station_outlined,
            title: 'CG Motors Charging Station',
            subtitle: 'Baglung Highway',
            status: 'Open',
          ),
          CustomStationTile(
            icon: Icons.ev_station_outlined,
            title: 'CG Motors Charging Station',
            subtitle: 'Baglung Highway',
            status: 'Open',
          ),
          CustomStationTile(
            icon: Icons.ev_station_outlined,
            title: 'CG Motors Charging Station',
            subtitle: 'Baglung Highway',
            status: 'Open',
          ),
        ],
      ),
    );
  }
}

class CustomStationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  const CustomStationTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        tileColor: Colors.white,
        leading: Icon(
          icon,
          color: Colors.green,
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
