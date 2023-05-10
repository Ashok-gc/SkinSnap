import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapcontroller;
  final Set<Marker> _markers = {};
  final LatLng _myLocation = const LatLng(27.7074836, 85.3244253);
  final LatLng _hospital1 = const LatLng(27.7027875, 85.3177165);
  final LatLng _hospital2 = const LatLng(27.7045511, 85.3139169);
  final LatLng _hospital3 = const LatLng(27.7044566, 85.313802);
  final LatLng _hospital5 = const LatLng(27.7036683, 85.3119642);
  final LatLng _hospital4 = const LatLng(27.7048253, 85.310834);

  _createCustomMarkerIcon() async {
    BitmapDescriptor? customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(45, 45)),
        'assets/logo/hospital.png');
    BitmapDescriptor? customMarkerIcon1 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(45, 45)),
        'assets/logo/position.png');
    _markers.add(
      Marker(
          markerId: MarkerId(_myLocation.toString()),
          position: _myLocation,
          infoWindow: const InfoWindow(
            title: "My Current Location",
          ),
          icon: customMarkerIcon1),
    );
    _markers.add(
      Marker(
          markerId: MarkerId(_hospital1.toString()),
          position: _hospital1,
          infoWindow: const InfoWindow(
            title: "Hospital 1",
          ),
          icon: customMarkerIcon),
    );
    _markers.add(
      Marker(
          markerId: MarkerId(_hospital2.toString()),
          position: _hospital2,
          infoWindow: const InfoWindow(
            title: "Hospital 2",
          ),
          icon: customMarkerIcon),
    );
    _markers.add(
      Marker(
          markerId: MarkerId(_hospital3.toString()),
          position: _hospital3,
          infoWindow: const InfoWindow(
            title: "Hospital 3",
          ),
          icon: customMarkerIcon),
    );
    _markers.add(
      Marker(
          markerId: MarkerId(_hospital4.toString()),
          position: _hospital4,
          infoWindow: const InfoWindow(
            title: "Hospital 4",
          ),
          icon: customMarkerIcon),
    );
    _markers.add(
      Marker(
          markerId: MarkerId(_hospital5.toString()),
          position: _hospital5,
          infoWindow: const InfoWindow(
            title: "Hospital 5",
          ),
          icon: customMarkerIcon),
    );
  }

  @override
  void initState() {
    setState(() {
      _createCustomMarkerIcon();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Near Me"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _myLocation, zoom: 18),
        mapType: MapType.normal,
        markers: _markers,
        onMapCreated: (controller) {
          setState(() {
            _mapcontroller = controller;
          });
        },
      ),
    );
  }
}
