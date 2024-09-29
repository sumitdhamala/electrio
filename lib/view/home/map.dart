import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;
  final TextEditingController searchController = TextEditingController();
  List<String> suggestions = [];
  String apiKey = 'AIzaSyCB5aUQoFi6DVNRYg-wwwyuNISsrNkala8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Electrio"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a place...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // This was removed since it's handled in onChanged
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _getSuggestions(value);
                } else {
                  setState(() {
                    suggestions = [];
                  });
                }
              },
            ),
          ),
          // Display suggestions
          if (suggestions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      _navigateToPlace(suggestions[index]);
                    },
                  );
                },
              ),
            ),
          // Google Map
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition:
                  CameraPosition(target: Home._pGooglePlex, zoom: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Get place suggestions from the Google Places API
  Future<void> _getSuggestions(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        suggestions = (data['predictions'] as List)
            .map((prediction) => prediction['description'] as String)
            .toList();
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  // Navigate to the selected place
  Future<void> _navigateToPlace(String placeName) async {
    // Use Google Places API to get the location details for the selected place
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=geometry&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'].isNotEmpty) {
        final lat = data['candidates'][0]['geometry']['location']['lat'];
        final lng = data['candidates'][0]['geometry']['location']['lng'];

        // Update the map camera position
        mapController.animateCamera(
          CameraUpdate.newLatLng(LatLng(lat, lng)),
        );

        // Clear suggestions after selecting a place
        setState(() {
          suggestions = [];
          searchController.clear(); // Clear the search input
        });
      }
    } else {
      throw Exception('Failed to find place');
    }
  }
}
