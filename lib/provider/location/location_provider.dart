import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/web_socket.dart';


class TrackingProvider extends ChangeNotifier with WidgetsBindingObserver {
  final WebSocketService _socket = WebSocketService();

  // vehicleId → route
  final Map<String, List<LatLng>> _routes = {};
  final Map<String, LatLng> _currentPositions = {};
  final Map<String, double> _bearings = {};

  Map<String, List<LatLng>> get routes => _routes;
  Map<String, LatLng> get currentPositions => _currentPositions;
  Map<String, double> get bearings => _bearings;

  /// Selected vehicle
  String? _selectedVehicleId;
  String? get selectedVehicleId => _selectedVehicleId;

  /// UI data
  LatLng? currentLocation;
  double bearing = 0.0;

  bool _hasNetworkError = false;
  bool get hasNetworkError => _hasNetworkError;

  TrackingProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  void pauseTracking() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeTracking() {
    _isPaused = false;
    notifyListeners();
  }


  // ============================================================
  // 🚗 SET SELECTED VEHICLE
  // ============================================================
  void setSelectedVehicle(String vehicleId) {
    _selectedVehicleId = vehicleId;

    _routes.putIfAbsent(vehicleId, () => []);
    _currentPositions.putIfAbsent(vehicleId, () => const LatLng(0, 0));
    _bearings.putIfAbsent(vehicleId, () => 0.0);

    // 🔥 Load past route first
    fetchPastRoute(vehicleId);

    notifyListeners();
  }

  // ============================================================
  // 🚀 START MULTI-VEHICLE TRACKING (UNCHANGED)
  // ============================================================
  Future<void> startTrackingVehicles(List<String> vehicleIds,{
    required String vehicleNumber,
    required String driverContact,
    required String postOwnerNumber,
    required String quoteOwnerNumber,
  }) async {
    await _socket.connect();

    for (final id in vehicleIds) {
      _routes[id] = [];
      _socket.subscribe(
        destination: "/topic/post/$id",
        onMessage: (msg) => _handleSocketData(id, msg),
      );
    }

    // 🔋 Start background service (sending)
    final service = FlutterBackgroundService();
    await service.startService();
    service.invoke("startTracking", {

      "postId": vehicleIds.first,
      "vehicleNumber": vehicleNumber,
      "driverContact": driverContact,
      "postOwnerNumber": postOwnerNumber,
      "quoteOwnerNumber": quoteOwnerNumber,
    });

    notifyListeners();
  }

  // ============================================================
  // 📡 HANDLE SOCKET DATA (ADDED SMOOTH ANIMATION)
  // ============================================================
  void _handleSocketData(String vehicleId, String message) async {
    // ⏸ If paused, ignore incoming updates
    if (_isPaused) return;
    try {
      final data = jsonDecode(message);
      final lat = _toDouble(data['latitude']);
      final lng = _toDouble(data['longitude']);
      final pos = LatLng(lat, lng);


      if (_currentPositions[vehicleId] != null) {
        _bearings[vehicleId] =
            _calculateBearing(_currentPositions[vehicleId]!, pos);
      }

      _currentPositions[vehicleId] = pos;
      _routes[vehicleId]!.add(pos);

      if (vehicleId == _selectedVehicleId) {
        final prev = currentLocation;
        if (prev != null) {
          await _animateToNewPosition(prev, pos);
        } else {
          currentLocation = pos;
        }
        bearing = _bearings[vehicleId] ?? 0.0;
      }

      _setNetworkError(false);
      notifyListeners();
    } catch (e) {
      _setNetworkError(true);
      debugPrint("❌ WS parse error: $e");
    }
  }

  // ============================================================
  // 🎯 SMOOTH MARKER MOVEMENT
  // ============================================================
  Future<void> _animateToNewPosition(LatLng start, LatLng end) async {
    const int steps = 25;
    for (int i = 1; i <= steps; i++) {
      final lat = start.latitude + (end.latitude - start.latitude) * (i / steps);
      final lng =
          start.longitude + (end.longitude - start.longitude) * (i / steps);
      currentLocation = LatLng(lat, lng);
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  // ============================================================
  // 📱 FG / BG SWITCH
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

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final dLon = (end.longitude - start.longitude) * pi / 180;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) -
        sin(lat1) * cos(lat2) * cos(dLon);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  void _setNetworkError(bool value) {
    if (_hasNetworkError == value) return;
    _hasNetworkError = value;
    notifyListeners();
  }

  // ============================================================
  // 📍 LOAD DEVICE CURRENT LOCATION (UNCHANGED)
  // ============================================================
  Future<void> loadMyCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation = LatLng(pos.latitude, pos.longitude);
      bearing = 0.0;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ loadMyCurrentLocation error: $e");
    }
  }


  // ============================================================
// 📜 FETCH PAST ROUTE FROM API
// ============================================================
  Future<void> fetchPastRoute(String vehicleId) async {
    final String url =
        "https://api.tkdost.com/tkd2/api/vehicleTracking/getVehicleTrackingByPostId/newJson/$vehicleId";

    debugPrint("📡 Fetching past route: $url");

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        _setNetworkError(true);
        debugPrint("❌ Failed to load past route");
        return;
      }

      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) return;

      _setNetworkError(false);

      // Clear existing route for this vehicle
      _routes[vehicleId] = [];

      for (final item in data) {
        final lat = (item['latitude'] as num).toDouble();
        final lng = (item['longitude'] as num).toDouble();
        _routes[vehicleId]!.add(LatLng(lat, lng));
      }

      // Set last point as current location
      final lastPoint = _routes[vehicleId]!.last;
      _currentPositions[vehicleId] = lastPoint;

      if (vehicleId == _selectedVehicleId) {
        currentLocation = lastPoint;
      }

      notifyListeners();
      debugPrint("✅ Past route loaded for $vehicleId");

    } catch (e) {
      _setNetworkError(true);
      debugPrint("❌ fetchPastRoute error: $e");
    }
  }


  // ============================================================
// ⏹ STOP ALL TRACKING
// ============================================================
  Future<void> stopAll() async {
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();

    if (isRunning) {
      service.invoke("stopTracking");   // background isolate
    }

    _socket.dispose();                 // WebSocket disconnect
    _routes.clear();
    _currentPositions.clear();
    _bearings.clear();

    _selectedVehicleId = null;
    currentLocation = null;
    bearing = 0.0;

    _isPaused = false;
    _setNetworkError(false);

    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _socket.dispose();
    super.dispose();
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

}
