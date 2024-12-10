// // url launcher package needed, and changes in station model , and station and sheet screens too

// import 'package:flutter/material.dart';

// import 'package:electrio/model/station_model.dart';
// import 'package:url_launcher/url_launcher.dart'; // To launch Google Maps or booking URLs
// import 'package:electrio/screens/booking_screen.dart'; // Update with your actual Booking Screen

// class StationDetailSheet extends StatelessWidget {
//   final Station station;

//   StationDetailSheet({required this.station});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Station Name
//             Text(
//               station.name,
//               style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//             SizedBox(height: 10),

//             // Location
//             Row(
//               children: [
//                 Icon(Icons.location_on, color: Colors.green),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     station.location,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Status
//             Row(
//               children: [
//                 Icon(Icons.info_outline, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text(
//                   'Status: ${station.status == 'OP' ? 'Open' : 'Closed'}',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Charger Types
//             Row(
//               children: [
//                 Icon(Icons.bolt, color: Colors.orange),
//                 SizedBox(width: 8),
//                 Text(
//                   'Charger Types: ${station.chargerTypes.length}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Total Slots Section
//             Row(
//               children: [
//                 Icon(Icons.local_parking, color: Colors.blueGrey),
//                 SizedBox(width: 8),
//                 Text(
//                   'Total Slots: ${station.totalSlots}',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Facilities Section
//             Text(
//               'Facilities:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             _buildFacilities(station),

//             // Bottom Row with "Get Directions" and "Book Now" buttons
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Get Directions Button
//                 ElevatedButton.icon(
//                   onPressed: () => _getDirections(station),
//                   icon: Icon(Icons.directions, color: Colors.white),
//                   label: Text('Get Directions'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.green, // Background color
//                   ),
//                 ),

//                 // Book Now Button
//                 ElevatedButton.icon(
//                   onPressed: () => _bookNow(context),
//                   icon: Icon(Icons.book_online, color: Colors.white),
//                   label: Text('Book Now'),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.blue, // Background color
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to launch Google Maps for directions
//   Future<void> _getDirections(Station station) async {
//     final String googleMapsUrl =
//         'https://www.google.com/maps/dir/?api=1&origin=${station.stationLatitude},${station.stationLongitude}&destination=${station.latitude},${station.longitude}';
//     if (await canLaunch(googleMapsUrl)) {
//       await launch(googleMapsUrl);
//     } else {
//       throw 'Could not open Google Maps.';
//     }
//   }

//   // Function to navigate to the booking screen
//   void _bookNow(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               BookingScreen()), // Update with your actual booking screen
//     );
//   }

//   // Widget to build the facilities list
//   Widget _buildFacilities(Station station) {
//     List<Widget> facilities = [];

//     if (station.hasHotels) {
//       facilities.add(_buildFacilityChip('Hotels', Icons.hotel, Colors.blue));
//     }
//     if (station.hasRestaurants) {
//       facilities.add(
//           _buildFacilityChip('Restaurants', Icons.restaurant, Colors.orange));
//     }
//     if (station.hasWifi) {
//       facilities.add(_buildFacilityChip('Wi-Fi', Icons.wifi, Colors.green));
//     }
//     if (station.hasParking) {
//       facilities
//           .add(_buildFacilityChip('Parking', Icons.local_parking, Colors.red));
//     }
//     if (station.hasRestrooms) {
//       facilities.add(_buildFacilityChip('Restrooms', Icons.wc, Colors.purple));
//     }

//     return Wrap(
//       spacing: 8.0,
//       children: facilities,
//     );
//   }

//   Widget _buildFacilityChip(String label, IconData icon, Color color) {
//     return Chip(
//       label: Row(
//         children: [
//           Icon(icon, color: color, size: 18),
//           SizedBox(width: 5),
//           Text(label),
//         ],
//       ),
//       backgroundColor: color.withOpacity(0.1),
//       labelStyle: TextStyle(color: color),
//     );
//   }
// }
