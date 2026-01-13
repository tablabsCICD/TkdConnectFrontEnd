import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tkd_connect/service/web_socket.dart';


const String foregroundIntervalKey = "FG_INTERVAL";
const String backgroundIntervalKey = "BG_INTERVAL";
const String vehicleKey = "VEHICLE_ID";

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final WebSocketService socket = WebSocketService();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  String? vehicleId;
  Duration fgInterval = const Duration(minutes: 1);
  Duration bgInterval = const Duration(minutes:1);

  Timer? timer;
  bool isForeground = true;

  void restartTimer() {
    timer?.cancel();
    final interval = isForeground ? fgInterval : bgInterval;

    timer = Timer.periodic(interval, (_) async {
      if (vehicleId == null) return;

      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (!socket.isConnected) {
          await socket.connect();
        }

        socket.sendLocation(
          vehicleId: vehicleId!,
          lat: pos.latitude,
          lng: pos.longitude,
          postId: '',
          driverNumber: ''
        );

        print("📡 BG Sent: $vehicleId → ${pos.latitude}, ${pos.longitude}");
      } catch (e) {
        print("❌ BG Location error: $e");
      }
    });
  }

  service.on('startTracking').listen((event) async {
    vehicleId = event?[vehicleKey];
    await socket.connect();
    restartTimer();
  });

  service.on('stopTracking').listen((event) {
    timer?.cancel();
    vehicleId = null;
    service.stopSelf();
  });

  service.on('setForeground').listen((event) {
    isForeground = true;
    restartTimer();
  });

  service.on('setBackground').listen((event) {
    isForeground = false;
    restartTimer();
  });
}
