import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final List<Map<String, String>> notifications;

  NotificationScreen({super.key, required this.notifications});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Method to delete a notification by index
  void deleteNotification(int index) {
    setState(() {
      widget.notifications
          .removeAt(index); // Remove the notification at the given index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.green,
      ),
      body: widget.notifications.isEmpty
          ? const Center(child: Text('No notifications available.'))
          : ListView.builder(
              itemCount: widget.notifications.length,
              itemBuilder: (context, index) {
                var notification = widget.notifications[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.ev_station,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                    title: Text(
                      notification['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      notification['message'] ?? 'No message available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteNotification(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
