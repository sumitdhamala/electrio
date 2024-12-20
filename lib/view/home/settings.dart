import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/view/home/reservation/booking_details.dart';
import 'package:electrio/view/settings/change_password.dart';
import 'package:electrio/view/settings/feedback.dart';
import 'package:electrio/view/settings/mybooking.dart';
import 'package:electrio/view/settings/myfeedbacks.dart';
import 'package:electrio/view/settings/myvehicles.dart';
import 'package:electrio/view/settings/profile_sscreen.dart';
import 'package:electrio/view/signup/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomCurvedAppBar(title: "Settings", backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Profile Option
          ListTile(
            leading: Icon(Icons.person, color: Colors.green),
            title: Text('Profile'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToProfile(context);
            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.directions_car_rounded, color: Colors.green),
            title: Text('My Vehicles'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToMyVehicles(context); // Navigate to My Bookings Screen
            },
          ),
          Divider(),

          // My Bookings Option
          ListTile(
            leading: Icon(Icons.bookmark, color: Colors.green),
            title: Text('My Bookings'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToMyBookings(context); // Navigate to My Bookings Screen
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.feedback_rounded, color: Colors.green),
            title: Text('My Feedback'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToFeedback(context);
            },
          ),
          Divider(),

          // Change Password Option
          ListTile(
            leading: Icon(Icons.lock, color: Colors.green),
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToChangePassword(context);
            },
          ),
          Divider(),

          // About Option
          ListTile(
            leading: Icon(Icons.info, color: Colors.green),
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _navigateToAbout(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),

          // Logout Option
        ],
      ),
    );
  }

  // Navigate to Profile Screen
  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, "/profile");
  }

  // Navigate to Change Password Screen
  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }

  void _navigateToFeedback(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserFeedbacksScreen()));
  }

  void _navigateToMyVehicles(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VehicleDetailsScreen()));
  }

  // Navigate to My Bookings Screen
  void _navigateToMyBookings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyBookingsScreen()), // Navigate to MyBookingsScreen
    );
  }

  // Navigate to About Screen
  void _navigateToAbout(BuildContext context) {
    print('Navigating to About Screen');
  }

  // Show Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              // Clear token
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');

              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );

              print('Logged out');
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
