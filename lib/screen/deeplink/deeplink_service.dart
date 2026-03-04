import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:tkd_connect/screen/deeplink/quote_deep_link.dart';
import 'package:tkd_connect/screen/deeplink/tracking_otp_screen.dart';
import '../../main.dart';
import 'deeplinkscreen.dart';

class DeepLinkService {
  DeepLinkService._internal();
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  String? _lastHandledLink;
  bool _isInitialized = false;
  bool isDeepLinkActive = false;

  void init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      // 1️⃣ App opened from terminated state
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      // 2️⃣ App opened from background / foreground
      _sub = _appLinks.uriLinkStream.listen((Uri uri) {
        _handleUri(uri);
      });
    } catch (e) {
      debugPrint("Deep link init error: $e");
    }
  }

  void _handleUri(Uri uri) {
    debugPrint("🔗 Deep Link Received: $uri");

    final String linkKey = uri.toString();
    // if (_lastHandledLink == linkKey) return;
    _lastHandledLink = linkKey;

    List<String> segments = uri.pathSegments;
    String? id = uri.queryParameters['id'];

    // ✅ ADDITION (NO existing logic removed)
    String? isPostOwnerStr = uri.queryParameters['isPostOwner'];
    bool isPostOwner = isPostOwnerStr?.toLowerCase() == 'true';

    if (segments.length >= 2 && segments[0] == "tkd" && id != null) {
      String type = segments[1];
      if (type == "post" || type == "quote" || type == "tracking") {
        isDeepLinkActive = true;
      }

      // ⏳ Wait until Navigator is ready
      _navigateWhenReady(() {
        final nav = navigatorKey.currentState;

        if (nav == null) {
          debugPrint("❌ Navigator not ready yet");
          return;
        }

        if (type == "post") {
          print("Navigation to post");
          nav.pushReplacement(
            MaterialPageRoute(
              builder: (_) => DeepLink(id: id, type: 'post'),
            ),
          );
          return;
        }

        if (type == "quote") {
          nav.pushReplacement(
            MaterialPageRoute(
              builder: (_) => DeepLink(id: id, type: 'quote'),
            ),
          );
          return;
        }

        if (type == "tracking") {
          if (id != null && id.isNotEmpty) {
            nav.pushReplacement(
              MaterialPageRoute(
                builder: (_) => TrackingOtpScreen(
                  postId: id,
                  isPostOwner: isPostOwner, // ✅ only added param
                ),
              ),
            );
          }
          return;
        }

        debugPrint("Unknown deep link type: $type");
      });
    } else {
      debugPrint("Invalid deep link format: $uri");
    }
  }

  void _navigateWhenReady(VoidCallback action, {int attempt = 0}) {
    final nav = navigatorKey.currentState;
    if (nav != null) {
      action();
      return;
    }

    if (attempt >= 10) {
      debugPrint("❌ Navigator not ready after retries");
      return;
    }

    Future.delayed(
      const Duration(milliseconds: 300),
      () => _navigateWhenReady(action, attempt: attempt + 1),
    );
  }

  void dispose() {
    _sub?.cancel();
    _isInitialized = false;
  }
}
