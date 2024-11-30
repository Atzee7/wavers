import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapPage({required this.latitude, required this.longitude});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    LatLng postLocation = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Postingan'),
        backgroundColor: Color(0xFF1A2947),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: postLocation,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('post-location'),
            position: postLocation,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
