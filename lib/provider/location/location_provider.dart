import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class DriverTrackingProvider extends ChangeNotifier {
  bool isTracking = false;
  Position? lastPosition;

  String? _postId;
  String? _vehicleId;
  String? _driverNumber;

  StreamSubscription<Position>? fgSubscription;

  DateTime? _lastForegroundApiHit;
  static const Duration _foregroundInterval = Duration(minutes: 1);

  /// START TRACKING
  Future<void> startTracking({
    required String postId,
    required String vehicleId,
    required String driverNumber,
  }) async {
    if (isTracking) return;

    _postId = postId;
    _vehicleId = vehicleId;
    _driverNumber = driverNumber;

    isTracking = true;

    fgSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      ),
    ).listen(_onNewPosition);



    notifyListeners();
  }

  /// STOP TRACKING
  Future<void> stopTracking() async {
    if (!isTracking) return;

    isTracking = false;

    await fgSubscription?.cancel();
    fgSubscription = null;

    _lastForegroundApiHit = null;



    notifyListeners();
  }

  /// FOREGROUND LOCATION HANDLER
  Future<void> _onNewPosition(Position pos) async {
    if (_postId == null || _vehicleId == null || _driverNumber == null) return;

    // Ignore GPS noise
    if (lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        pos.latitude,
        pos.longitude,
      );
      if (distance < 10) return;
    }

    lastPosition = pos;

    final now = DateTime.now();

    final shouldCallApi =
        _lastForegroundApiHit == null ||
            now.difference(_lastForegroundApiHit!) >= _foregroundInterval;

    if (!shouldCallApi) return;

    _lastForegroundApiHit = now;

   

    print("🟢 Foreground location saved (1 min)");
  }
}
