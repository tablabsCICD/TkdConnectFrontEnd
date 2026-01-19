import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:tkd_connect/screen/deeplink/quote_deep_link.dart';
import 'package:tkd_connect/screen/deeplink/tracking_otp_screen.dart';
import '../../main.dart';
import 'deeplinkscreen.dart';


class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  String? _lastHandledLink;
  bool isDeepLinkActive = false;


  void init() async {
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

    if (segments.length >= 2 && segments[0] == "tkd" && id != null) {
      String type = segments[1];

      // ⏳ Wait until Navigator is ready
      Future.delayed(const Duration(milliseconds: 300), () {
        final nav = navigatorKey.currentState;

        if (nav == null) {
          debugPrint("❌ Navigator not ready yet");
          return;
        }

        if (type == "post") {
          isDeepLinkActive = true;
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
              builder: (_) => QuoteDeepLink(id: id, type: 'quote'),
            ),
          );

          return;
        }

        if (type == "tracking") {
          if (id != null && id.isNotEmpty) {
            nav.pushReplacement(
              MaterialPageRoute(
                builder: (_) => TrackingOtpScreen(postId: id),
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

  void dispose() {
    _sub?.cancel();
  }
}
