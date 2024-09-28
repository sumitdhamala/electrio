import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Electrio"),
          centerTitle: true,
        ),
        body: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: Home._pGooglePlex, zoom: 13)));
  }
}
