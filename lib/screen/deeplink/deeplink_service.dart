import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  String? _lastHandledLink;

  void init(BuildContext context) async {
    try {
      // 1️⃣ App opened from terminated state
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(context, initialUri);
      }

      // 2️⃣ App opened from background / foreground
      _sub = _appLinks.uriLinkStream.listen((Uri uri) {
        _handleUri(context, uri);
      });
    } catch (e) {
      debugPrint("Deep link init error: $e");
    }
  }

  void _handleUri(BuildContext context, Uri uri) {
    debugPrint("🔗 Deep Link Received: $uri");

    final String linkKey = uri.toString();

    // 🚫 Prevent duplicate opens
    if (_lastHandledLink == linkKey) {
      debugPrint("Duplicate deep link ignored: $linkKey");
      return;
    }
    _lastHandledLink = linkKey;

    List<String> segments = uri.pathSegments;

    /*
      Expected:
      https://tkdost.com/tkd/post/123
      https://tkdost.com/tkd/quote/456

      segments[0] = tkd
      segments[1] = post / quote
      segments[2] = id
    */

    if (segments.length >= 3 && segments[0] == "tkd") {
      String type = segments[1];
      String id = segments[2];

      if (type == "post") {
        Navigator.pushNamed(context, "/post", arguments: id);
        return;
      }

      if (type == "quote") {
        Navigator.pushNamed(context, "/quote", arguments: id);
        return;
      }

      debugPrint("Unknown deep link type: $type");
    } else {
      debugPrint("Invalid deep link format: $uri");
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
