import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:electrio/view/home/history.dart';
import 'package:electrio/view/home/settings.dart';
import 'package:electrio/view/home/map.dart';
import 'package:electrio/view/home/station/stations.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens to display
  final List<Widget> _children = [
    HomeView(),
    StationsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          _navItem(Icons.home, 'Home', 0),
          _navItem(Icons.charging_station_outlined, 'Charging', 1),
          _navItem(Icons.history_edu_outlined, 'History', 2),
          _navItem(Icons.settings, 'Settings', 3),
        ],
        color: Colors.white, // Set background color to white
        buttonBackgroundColor: Colors.white, // Button background color
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Helper method to create navigation items
  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 30,
          color: isSelected ? Colors.green : Colors.grey, // Change icon color
        ),
        SizedBox(height: 4), // Spacing between icon and label
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.green : Colors.grey, // Change text color
          ),
        ),
      ],
    );
  }
}
