// stations.dart
import 'package:electrio/component/customclip_bar.dart';
import 'package:flutter/material.dart';

class StationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCurvedAppBar(
        title: 'Stations',
        backgroundColor: Colors.green, // Customize the AppBar background color
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
            title: 'Sunrise EV Station',
            subtitle: 'Pokhara Lakeside',
            status: 'Closed',
          ),
          CustomStationTile(
            icon: Icons.ev_station_outlined,
            title: 'Green Energy Hub',
            subtitle: 'Kathmandu Ring Road',
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
      padding: const EdgeInsets.symmetric(
          vertical: 6.0), // Adjusted padding for spacing
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              16.0), // Increased radius for more rounded corners
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.all(12.0), // Added padding inside the tile
          leading: CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.1),
            child: Icon(
              icon,
              color: Colors.green,
              size: 28.0,
            ),
            radius: 24.0, // Circular avatar size
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[600],
                size: 14.0,
              ),
              SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: _buildStatusIndicator(status),
        ),
      ),
    );
  }

  // Method to build status indicator with color-coded text and icons
  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    IconData statusIcon;

    if (status.toLowerCase() == 'open') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          statusIcon,
          color: statusColor,
          size: 20,
        ),
        const SizedBox(height: 4.0),
        Text(
          status,
          style: TextStyle(
            fontSize: 12.0,
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
