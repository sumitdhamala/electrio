import 'package:flutter/material.dart';

class CustomStationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final double? distance;

  const CustomStationTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.distance,
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
                  "$subtitle (${distance != null && distance! < double.infinity ? '${distance!.toStringAsFixed(1)} km' : 'N/A'})",
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
    String statusText;

    switch (status.toUpperCase()) {
      case 'OP':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Open';
        break;
      case 'CL':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Closed';
        break;
      case 'BK':
        statusColor = Colors.blue;
        statusIcon = Icons.bookmark;
        statusText = 'Booked';
        break;
      case 'UM':
        statusColor = Colors.orange;
        statusIcon = Icons.build;
        statusText = 'Under Maintenance';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = 'Unknown';
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
          statusText,
          style: TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );
  }
}
