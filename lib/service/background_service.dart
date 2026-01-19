import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tkd_connect/service/web_socket.dart';


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final WebSocketService socket = WebSocketService();

  Timer? timer;
  bool isForeground = true;
  String? _postId;
  String? _vehicleNumber;
  String? _driverContact;
  String? _postOwnerNumber;
  String? _quoteOwnerNumber;

  const fgInterval = Duration(seconds: 30);
  const bgInterval = Duration(minutes: 1);

  void restartTimer() {
    timer?.cancel();
    final interval = isForeground ? fgInterval : bgInterval;

    timer = Timer.periodic(interval, (_) async {
      if (_postId == null ||
          _vehicleNumber == null ||
          _driverContact == null) return;

      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (!socket.isConnected) {
          await socket.connect();
        }

        await socket.sendLocation(
          postId: _postId!,
          vehicleNumber: _vehicleNumber!,
          driverContact: _driverContact!,
          postOwnerNumber: _postOwnerNumber!,
          quoteOwnerNumber: _quoteOwnerNumber!,
          latitude: pos.latitude,
          longitude: pos.longitude,
          speed: pos.speed,
        );

        print("📡 ${isForeground ? "FG" : "BG"} Sent → $_postId");
      } catch (e) {
        print("❌ BG Location Error: $e");
      }
    });
  }

  if (service is AndroidServiceInstance) {
    service.on('setForeground').listen((event) {
      isForeground = true;
      restartTimer();
    });

    service.on('setBackground').listen((event) {
      isForeground = false;
      restartTimer();
    });
  }

  service.on('startTracking').listen((event) async {
    _postId = event?["postId"];
    _vehicleNumber = event?["vehicleNumber"];
    _driverContact = event?["driverContact"];
    _postOwnerNumber = event?["postOwnerNumber"];
    _quoteOwnerNumber = event?["quoteOwnerNumber"];

    if (_postId == null) {
      print("⚠ startTracking called without postId");
      return;
    }

    if (!socket.isConnected) {
      await socket.connect();
    }
    restartTimer();
  });

  service.on('stopTracking').listen((event) {
    timer?.cancel();
    _postId = null;
    _vehicleNumber = null;
    _driverContact = null;
    _postOwnerNumber = null;
    _quoteOwnerNumber = null;
    service.stopSelf();
  });
}
