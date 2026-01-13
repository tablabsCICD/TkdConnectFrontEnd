import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tkd_connect/service/background_service.dart';
import 'package:tkd_connect/service/location_service.dart';
import 'package:tkd_connect/service/web_socket.dart';


import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DriverTrackingProvider extends ChangeNotifier with WidgetsBindingObserver {
  final WebSocketService _socket = WebSocketService();
  bool _connected = false;

  String? _selectedVehicle;
  String? get selectedVehicle => _selectedVehicle;

  final List<LatLng> liveRoute = [];
  List<LatLng> get getLiveRoute => liveRoute;

  LatLng? currentLocation;
  double bearing = 0.0;

  LatLng? get getCurrentLocation => currentLocation;
  double get getBearing => bearing;

  TrackingProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  // ============================================================
  // 🚀 START TRACKING (FOREGROUND + BACKGROUND)
  // ============================================================
  Future<void> startTracking(String postId,String vehicleId,String driverNumber,) async {
    _selectedVehicle = vehicleId;

    if (!_connected) {
      await _socket.connect();
      _connected = true;
    }

    _socket.subscribe(
      destination: "/topic/vehicle/$vehicleId",
      onMessage: (msg) {
        _handleSocketData(msg);
      },
    );

    // 🔥 Start background service
    final service = FlutterBackgroundService();
    await service.startService();
    service.invoke("startTracking", {
      "VEHICLE_ID": vehicleId,
    });

    notifyListeners();
  }

  // ============================================================
  // ⏹ STOP TRACKING
  // ============================================================
  Future<void> stopTracking() async {
    final service = FlutterBackgroundService();
    service.invoke("stopTracking");

    _socket.dispose();
    _connected = false;
    _selectedVehicle = null;
    liveRoute.clear();

    notifyListeners();
  }

  // ============================================================
  // 📡 HANDLE WEBSOCKET DATA
  // ============================================================
  void _handleSocketData(String message) {
    try {
      final data = Map<String, dynamic>.from(jsonDecode(message));
      final lat = (data['latitude'] as num).toDouble();
      final lng = (data['longitude'] as num).toDouble();

      final newPos = LatLng(lat, lng);

      if (currentLocation != null) {
        bearing = _calculateBearing(currentLocation!, newPos);
      }

      currentLocation = newPos;
      liveRoute.add(newPos);

      notifyListeners();
    } catch (e) {
      debugPrint("❌ WebSocket parse error: $e");
    }
  }

  // ============================================================
  // 📱 APP LIFECYCLE → SWITCH BG / FG MODE
  // ============================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final service = FlutterBackgroundService();

    if (state == AppLifecycleState.resumed) {
      service.invoke("setForeground");
    } else if (state == AppLifecycleState.paused) {
      service.invoke("setBackground");
    }
  }

  // ============================================================
  // 🧭 BEARING
  // ============================================================
  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * 3.14159 / 180;
    final lat2 = end.latitude * 3.14159 / 180;
    final dLon = (end.longitude - start.longitude) * 3.14159 / 180;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) -
        sin(lat1) * cos(lat2) * cos(dLon);

    final brng = atan2(y, x);
    return (brng * 180 / 3.14159 + 360) % 360;
  }

  bool _hasNetworkError = false;
  bool get hasNetworkError => _hasNetworkError;

  void _setNetworkError(bool value) {
    if (_hasNetworkError == value) return;
    _hasNetworkError = value;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _socket.dispose();
    super.dispose();
  }


  // ============================================================
  // 📍 LOAD DEVICE CURRENT LOCATION
  // ============================================================
  Future<void> loadMyCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation = LatLng(pos.latitude, pos.longitude);
      bearing = 0.0;

      notifyListeners();
    } catch (e) {
      debugPrint("❌ loadMyCurrentLocation error: $e");
    }
  }

}
