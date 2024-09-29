// settings_screen.dart
import 'package:electrio/component/customclip_bar.dart';
import 'package:electrio/view/profile_sscreen.dart';
import 'package:electrio/view/signup/forget_password.dart';
import 'package:flutter/material.dart';

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

          // Change Password Option
          ListTile(
            leading: Icon(Icons.lock, color: Colors.green),
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Change Password Screen
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
              // Navigate to About Screen
              _navigateToAbout(context);
            },
          ),
          Divider(),

          // Logout Option
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              // Handle logout action
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Navigate to Profile Screen
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  // Navigate to Change Password Screen
  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
    );
  }

  // Navigate to About Screen
  void _navigateToAbout(BuildContext context) {
    // Implement navigation logic here
    // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
    print('Navigating to About Screen');
  }

  // Show Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle the logout process here
              Navigator.of(context).pop();
              print('Logged out');
              // You can also navigate to the login screen after logging out
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
