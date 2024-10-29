// lib/app/modules/home/views/map_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _initialPosition = LatLng(-6.1751, 106.8650);

  late GoogleMapController _controller;

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    // Optional: Add a marker at the initial position
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('initialPosition'),
          position: _initialPosition,
          infoWindow: InfoWindow(title: 'Initial Position'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        backgroundColor: Color(0xFF1A2947),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 11.0,
        ),
        markers: _markers,
        myLocationEnabled: true, // Enable if permissions are granted
        myLocationButtonEnabled: true,
      ),
    );
  }
}
