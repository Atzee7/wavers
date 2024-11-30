import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  LatLng? _currentPosition; // Mengizinkan null

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Fungsi untuk mendapatkan lokasi pengguna
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  // Fungsi saat peta dibuat
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      // Menampilkan indikator loading saat lokasi belum tersedia
      return Scaffold(
        appBar: AppBar(
          title: Text('Select Location'),
          backgroundColor: Color(0xFF1A2947),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Color(0xFF1A2947),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _currentPosition);
            },
            child:
            Text("SELECT", style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15,
        ),
        myLocationEnabled: true,
        onTap: (LatLng location) {
          setState(() {
            _currentPosition = location;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('selected-location'),
            position: _currentPosition!,
          ),
        },
      ),
    );
  }
}
