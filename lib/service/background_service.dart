import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tkd_connect/service/web_socket.dart';


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final WebSocketService socket = WebSocketService();

  final Map<String, Timer> _timers = {};
  final Map<String, Map<String, dynamic>> _vehicles = {};
  bool isForeground = true;


  const fgInterval = Duration(seconds: 30);
  const bgInterval = Duration(minutes: 1);

  void startVehicleTimer(String postId) {
    _timers[postId]?.cancel();

    final interval =
    isForeground ? const Duration(seconds: 30) : const Duration(minutes: 1);

    _timers[postId] = Timer.periodic(interval, (_) async {
      final v = _vehicles[postId];
      if (v == null) return;

      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (!socket.isConnected) {
          await socket.connect();
        }

        await socket.sendLocation(
          postId: postId,
          vehicleNumber: v["vehicleNumber"],
          driverContact: v["driverContact"],
          postOwnerNumber: v["postOwnerNumber"],
          quoteOwnerNumber: v["quoteOwnerNumber"],
          latitude: pos.latitude,
          longitude: pos.longitude,
          speed: pos.speed,
        );

        print("📡 ${isForeground ? "FG" : "BG"} Sent → $postId");
      } catch (e) {
        print("❌ BG error [$postId]: $e");
      }
    });
  }

  if (service is AndroidServiceInstance) {
    service.on('setForeground').listen((_) {
      isForeground = true;
      for (final postId in _vehicles.keys) {
        startVehicleTimer(postId);
      }
    });

    service.on('setBackground').listen((_) {
      isForeground = false;
      for (final postId in _vehicles.keys) {
        startVehicleTimer(postId);
      }
    });
  }

  service.on('startTracking').listen((event) async {
    final postId = event?["postId"];
    if (postId == null) return;

    _vehicles[postId] = {
      "vehicleNumber": event?["vehicleNumber"],
      "driverContact": event?["driverContact"],
      "postOwnerNumber": event?["postOwnerNumber"],
      "quoteOwnerNumber": event?["quoteOwnerNumber"],
    };

    if (!socket.isConnected) {
      await socket.connect();
    }

    startVehicleTimer(postId);
  });




  service.on('stopTracking').listen((event) {
    final postId = event?["postId"];
    if (postId == null) return;

    _timers[postId]?.cancel();
    _timers.remove(postId);
    _vehicles.remove(postId);

    if (_vehicles.isEmpty) {
      service.stopSelf();
    }
  });

}
