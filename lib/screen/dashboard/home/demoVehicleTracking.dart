import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleWithPolyline extends StatefulWidget {
  const VehicleWithPolyline({super.key});

  @override
  State<VehicleWithPolyline> createState() => _VehicleWithPolylineState();
}

class _VehicleWithPolylineState extends State<VehicleWithPolyline> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker? _vehicleMarker;
  int _currentIndex = 0;
  Timer? _timer;

  // 🔥 Sample route (Bangalore city points for demo)
  final List<LatLng> _route = [
    LatLng(12.9716, 77.5946), // Start
    LatLng(12.9724, 77.6000),
    LatLng(12.9750, 77.6050),
    LatLng(12.9780, 77.6100),
    LatLng(12.9820, 77.6150), // End
  ];

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _createPolyline();
    _startSimulation();
  }

  // Create polyline from route
  void _createPolyline() {
    _polylines.add(
      Polyline(
        polylineId: const PolylineId("vehicleRoute"),
        visible: true,
        points: _route,
        width: 5,
        color: Colors.blue,
      ),
    );
  }

  // Simulate vehicle movement along the polyline
  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_currentIndex < _route.length) {
        LatLng newPosition = _route[_currentIndex];
        setState(() {
          _vehicleMarker = Marker(
            markerId: const MarkerId("vehicle"),
            position: newPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: "Step $_currentIndex"),
          );
        });
        _moveCamera(newPosition);
        _currentIndex++;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _moveCamera(LatLng newPos) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newPos, zoom: 15),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Tracking with Polyline")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _route[0],
          zoom: 15,
        ),
        markers: _vehicleMarker != null ? {_vehicleMarker!} : {},
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
