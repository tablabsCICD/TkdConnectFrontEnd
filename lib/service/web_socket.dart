import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'offline_location_store.dart';


class WebSocketService {
  StompClient? _client;
  bool _connected = false;
  bool get isConnected => _connected;

  final Map<String, Function(String)> _subscriptions = {};
  final List<Map<String, dynamic>> _pendingMessages = [];

  Future<void> connect() async {
    if (_connected) return;

    _client = StompClient(
      config: StompConfig(
        url:
        'wss://api.tkdost.com/tkd2/ws-location/websocket',
        onConnect: _onConnect,
        onDisconnect: (_) {
          _connected = false;
          print("🔌 WS Disconnected");
        },
        onWebSocketError: (e) {
          _connected = false;
          print("❌ WS Error: $e");
        },
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
      ),
    );

    _client!.activate();
  }

  Future<void> _onConnect(StompFrame frame) async {
    print("✅ WS Connected");
    _connected = true;

    // 🔁 Re-subscribe all topics
    _subscriptions.forEach((dest, cb) {
      _client!.subscribe(
        destination: dest,
        callback: (frame) {
          if (frame.body != null) cb(frame.body!);
        },
      );
    });

    // 📤 Flush queued messages
    for (final msg in _pendingMessages) {
      _client!.send(
        destination: msg['destination'],
        body: msg['body'],
      );
    }
    _pendingMessages.clear();

    // 📤 Sync offline cached data
    final cached = OfflineLocationStore.getAll();
    for (final item in await cached) {
      _client!.send(
        destination: "/app/vehicle/location",
        body: jsonEncode(item),
      );
    }
    await OfflineLocationStore.clear();
    print("📤 Offline data synced");
  }

  // ----------------------------------------------------------
  // 📡 SUBSCRIBE
  // ----------------------------------------------------------
  void subscribe({
    required String destination,
    required Function(String message) onMessage,
  }) {
    _subscriptions[destination] = onMessage;

    if (_client != null && _client!.connected) {
      _client!.subscribe(
        destination: destination,
        callback: (frame) {
          if (frame.body != null) onMessage(frame.body!);
        },
      );
    }
  }

  // ----------------------------------------------------------
  // 📤 SEND LOCATION (UNCHANGED LOGIC + OFFLINE QUEUE)
  // ----------------------------------------------------------
  Future<void> sendLocation({
    required String postId,
    required String vehicleNumber,
    required String driverContact,
    required String postOwnerNumber,
    required String quoteOwnerNumber,
    required double latitude,
    required double longitude,
    required double speed,
  }) async {
    final payload = {

      "postId": postId,
      "vehicleNumber": vehicleNumber,
      "driverContact": driverContact,
      "postOwnerNumber": postOwnerNumber,
      "quoteOwnerNumber": quoteOwnerNumber,
      "latitude": latitude,
      "longitude": longitude,
      "speed": speed,
    };

    final body = jsonEncode(payload);

    if (!_connected || _client == null || !_client!.connected) {
      print("📦 WS offline → queued & saved locally");
      _pendingMessages.add({
        "destination": "/app/vehicle/location",
        "body": body,
      });

      await OfflineLocationStore.save(payload);
      return;
    }

    _client!.send(
      destination: "/app/vehicle/location",
      body: body,
    );

    print("📤 WS Sent: $body");
  }

  void dispose() {
    _client?.deactivate();
    _connected = false;
  }
}
