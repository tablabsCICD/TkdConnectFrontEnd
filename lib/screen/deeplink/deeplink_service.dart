import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../generated/l10n.dart';
import '../../model/api_response.dart';
import '../../model/response/version.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';
import 'deeplinkscreen.dart';
import 'package:tkd_connect/route/app_routes.dart';
import '../../main.dart'; // ✅ navigatorKey import

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  void init(BuildContext context) {
    // ✅ Cold start
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleLink(uri);
      }
    });

    // ✅ Foreground & background
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleLink(uri);
      }
    });
  }

  Future<void> _handleLink(Uri uri) async {
    String? id = uri.queryParameters['id'];

    LocalSharePreferences prefs = LocalSharePreferences();
    bool isLoggedIn = await prefs.getBool(AppConstant.LOGIN_BOOl);

    if (id != null && id.isNotEmpty) {
      if (isLoggedIn) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => DeepLink(id: id, type: '',),
          ),
        );
      } else {
        fetchVersionAndNavigate();
      }
    } else {
      fetchVersionAndNavigate();
    }
  }

  // ✅ FIXED
  Future<void> fetchVersionAndNavigate() async {
    ApiResponse response = await ApiHelper()
        .apiWithoutDilogDecodeGet(ApiConstant.GET_CURRENT_VERSION);

    Version version = Version.fromJson(response.response);

    if (version.version == AppConstant.APP_VERSION) {
      navigateToNextScreen();
    } else {
      showUpdateDialog();
    }
  }

  // ✅ FIXED CONTEXT ISSUE
  void navigateToNextScreen() async {
    LocalSharePreferences prefs = LocalSharePreferences();

    bool isLoggedIn = await prefs.getBool(AppConstant.LOGIN_BOOl);
    String langCode = await prefs.getLangCode();

    if (isLoggedIn) {
      S.load(Locale(langCode));
      navigatorKey.currentState
          ?.pushReplacementNamed(AppRoutes.home);
    } else {
      if (langCode == "no") {
        navigatorKey.currentState
            ?.pushReplacementNamed(AppRoutes.select_lang);
      } else {
        S.load(Locale(langCode));
        navigatorKey.currentState?.pushReplacementNamed(
            AppRoutes.registration_personal_details);
      }
    }
  }

  // ✅ FIXED CONTEXT ISSUE
  void showUpdateDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('TKD Connect Update'),
        content: const Text(
            'A new version of TKD Connect is available. Please update the app to continue.'),
        actions: [
          TextButton(
            onPressed: redirectToPlayStore,
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void redirectToPlayStore() {
    final Uri url =
    Uri.parse('https://play.google.com/store/apps/details?id=com.pdk.tkd');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
