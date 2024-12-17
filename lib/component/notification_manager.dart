import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';

class NotificationManager {
  static final List<Map<String, String>> _notifications = [];

  // Add notification
  static void addNotification(String title, String message) {
    _notifications.add({
      'title': title,
      'message': message,
    });
    showOverlayNotification((context) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.grey[900],
        child: ListTile(
          leading: Icon(Icons.ev_station, color: Colors.greenAccent),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            message,
            style: TextStyle(color: Colors.white70),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              OverlaySupportEntry.of(context)?.dismiss();
            },
          ),
        ),
      );
    }, duration: Duration(seconds: 5));
  }

  // Get all notifications (titles + messages)
  static List<Map<String, String>> getNotifications() {
    return _notifications;
  }

  // Clear notifications
  static void clearNotifications() {
    _notifications.clear();
  }
}
