// custom_station_tile.dart
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.1),
            child: Icon(
              icon,
              color: Colors.green,
              size: 28.0,
            ),
            radius: 24.0,
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
