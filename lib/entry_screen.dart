import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/version.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/screen/deeplink/deeplinkscreen.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:uni_links5/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generated/l10n.dart';
import 'package:flutter/services.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EntryScreen();
}

class _EntryScreen extends State<EntryScreen> with WidgetsBindingObserver {
  late Future<String> permissionStatusFuture;

  final String permGranted = "granted";
  final String permDenied = "denied";
  final String permUnknown = "unknown";
  final String permProvisional = "provisional";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Run checks after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show minimal loading UI (not splash anymore)
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> checkPermissions() async {
    permissionStatusFuture = checkNotificationPermissionStatus();
    String permissionStatus = await permissionStatusFuture;
    if ([permGranted, permProvisional].contains(permissionStatus)) {
      initializeUniLinks();
    } else {
      showPermissionDialog();
    }
  }

  void navigateToNextScreen() async {
    LocalSharePreferences prefs = LocalSharePreferences();
    bool isLoggedIn = await prefs.getBool(AppConstant.LOGIN_BOOl);
    String langCode = await prefs.getLangCode();
    if (isLoggedIn) {
      S.load(Locale(langCode));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      if (langCode == "no") {
        Navigator.pushReplacementNamed(context, AppRoutes.select_lang);
      } else {
        S.load(Locale(langCode));
        Navigator.pushReplacementNamed(context, AppRoutes.registration_personal_details);
      }
    }
  }

  void showUpdateDialog() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('TKD Connect Update'),
        content: const Text('A new application update is available on the Play Store. Please update the app.'),
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
    final Uri url = Uri.parse('market://details?id=com.pdk.tkd');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> initializeUniLinks() async {
    try {
      String? initialLink = await getInitialLink();
      if (initialLink != null) {
        LocalSharePreferences prefs = LocalSharePreferences();
        bool isLoggedIn = await prefs.getBool(AppConstant.LOGIN_BOOl);
        if (isLoggedIn) {
          String id = initialLink.split("/").last;
          Navigator.push(context, MaterialPageRoute(builder: (_) => DeepLink(id: id)));
        } else {
          fetchVersionAndNavigate();
        }
      } else {
        fetchVersionAndNavigate();
      }
    } on PlatformException {
      fetchVersionAndNavigate();
    }
  }

  Future<void> fetchVersionAndNavigate() async {
    ApiResponse response = await ApiHelper().apiWithoutDilogDecodeGet(ApiConstant.GET_CURRENT_VERSION);
    Version version = Version.fromJson(response.response);
    if (version.version == AppConstant.APP_VERSION) {
      navigateToNextScreen();
    } else {
      showUpdateDialog();
    }
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }

  Future<String> checkNotificationPermissionStatus() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isGranted) {
      return permGranted;
    } else if (status.isDenied) {
      return permDenied;
    } else if (status.isRestricted || status.isPermanentlyDenied) {
      return permUnknown;
    } else {
      return permProvisional;
    }
  }

  void showPermissionDialog() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Notification Permission',
          style: TextStyle(
            fontSize: 18,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Please enable notification permissions.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await requestNotificationPermission();
              Navigator.of(context, rootNavigator: true).pop();
              String permissionStatus = await checkNotificationPermissionStatus();
              if ([permGranted, permProvisional].contains(permissionStatus)) {
                initializeUniLinks();
              }
            },
            child: const Text('Enable Permission'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              fetchVersionAndNavigate();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = checkNotificationPermissionStatus();
      });
    }
  }
}
