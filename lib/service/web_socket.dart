
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService {
  StompClient? _stompClient;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  String? _lastMessage; // 🔁 Prevent duplicate processing

  /// 🔹 Connect to STOMP WebSocket
  Future<void> connect() async {
    if (_isConnected) return;

    _stompClient = StompClient(
      config: StompConfig(
        url:
        'ws://ec2-13-201-5-93.ap-south-1.compute.amazonaws.com:8080/tracking/tracking/ws-location/websocket',

        onConnect: _onConnect,

        onWebSocketError: (error) {
          print('❌ WS ERROR: $error');
          _isConnected = false;
        },

        onStompError: (frame) {
          print('❌ STOMP ERROR: ${frame.body}');
          _isConnected = false;
        },

        onDisconnect: (frame) {
          print('🔌 STOMP DISCONNECTED');
          _isConnected = false;
        },

        /// 🔁 Auto reconnect
        reconnectDelay: const Duration(seconds: 5),

        /// ❤️ Heartbeat to keep connection alive
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
      ),
    );

    _stompClient!.activate();
  }

  /// 🔹 Called when connection is established
  void _onConnect(StompFrame frame) {
    print("✅ STOMP Connected");
    _isConnected = true;
  }

  // ----------------------------------------------------------
  // 📡 Subscribe to topic
  // ----------------------------------------------------------
  void subscribe({
    required String destination,
    required Function(String message) onMessage,
  }) {
    if (_stompClient == null) {
      print("⚠️ STOMP client not initialized.");
      return;
    }

    if (!_stompClient!.connected) {
      print("⚠️ STOMP not connected yet. Retrying subscribe...");
      Future.delayed(const Duration(seconds: 2), () {
        subscribe(destination: destination, onMessage: onMessage);
      });
      return;
    }

    _stompClient!.subscribe(
      destination: destination,
      callback: (StompFrame frame) {
        if (frame.body == null) return;

        final message = frame.body!;

        /// 🔁 Prevent duplicate messages
        if (_lastMessage == message) return;
        _lastMessage = message;

        onMessage(message);
      },
    );

    print("📡 Subscribed to $destination");
  }

  // ----------------------------------------------------------
  // 📤 Send location to backend
  // ----------------------------------------------------------
  void sendLocation({
    required String postId,
    required String vehicleId,
    required String driverNumber,
    required double lat,
    required double lng
  }) {
    if (!_isConnected || _stompClient == null || !_stompClient!.connected) {
      print("⚠️ STOMP not connected. Skipping send.");
      return;
    }

    final data = jsonEncode({
      "postId": postId,
      "vehicleId": vehicleId,
      "driverNumber": driverNumber,
      "latitude": lat,
      "longitude": lng,
      "timestamp": DateTime.now().toIso8601String(),
    });

    _stompClient!.send(
      destination: "/app/vehicle/location",
      body: data,
    );

    print("📤 Sent location: $data");
  }

  // ----------------------------------------------------------
  // 🔌 Disconnect cleanly
  // ----------------------------------------------------------
  void dispose() {
    try {
      _stompClient?.deactivate();
      _isConnected = false;
      print("🔌 STOMP Closed");
    } catch (e) {
      print("STOMP Close Error: $e");
    }
  }
}
