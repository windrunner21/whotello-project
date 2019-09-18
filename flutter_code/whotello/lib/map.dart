import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var location = new Location();
LocationData currentLocation;

LatLng center = LatLng(39.9334, 32.8597);

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Google Maps'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: GoogleMap(
              myLocationButtonEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 11.0,
              ),
            )));
  }

  _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      center = LatLng(currentLocation.latitude, currentLocation.longitude);
    } on Exception {
      currentLocation = null;
    }
  }
}
