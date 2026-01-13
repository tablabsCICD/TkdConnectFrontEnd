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

    // Show prominent disclosure first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showProminentDisclosureDialog();
      requestAllPermissions();

    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Minimal loading UI
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ------------------- PROMINENT DISCLOSURE DIALOG -------------------
  void showProminentDisclosureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Location Access Disclosure",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              "TKD Connect collects location data, including in the background, "
                  "to provide live route tracking between source and destination for accepted quotes. "
                  "This ensures accurate route updates and delivery tracking even when the app is closed "
                  "or not in active use. The location data is used only for this purpose and is never shared "
                  "with third parties.",
              style: TextStyle(fontSize: 15),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                requestAllPermissions(); // Request permissions after consent
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  // ------------------- PERMISSION HANDLING -------------------
  Future<void> requestAllPermissions() async {
    // Request location permissions (foreground + background)
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();

    // Request notification permission (non-sensitive but required for alerts)
    await Permission.notification.request();

    // Continue logic after permissions
    String permissionStatus = await checkNotificationPermissionStatus();
    if ([permGranted, permProvisional].contains(permissionStatus)) {
      fetchVersionAndNavigate();
    } else {
      showPermissionDialog();
    }
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
          'Please enable notification permissions to receive important alerts and updates.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Permission.notification.request();
              Navigator.of(context, rootNavigator: true).pop();
              String permissionStatus = await checkNotificationPermissionStatus();
              if ([permGranted, permProvisional].contains(permissionStatus)) {
                fetchVersionAndNavigate();
              } else {
                fetchVersionAndNavigate();
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

  /* Future<void> initializeUniLinks() async {
    try {
      String? initialLink = await getInitialLink();

      if (initialLink != null) {
        Uri uri = Uri.parse(initialLink);

        // ✅ Extract ID from query param
        String? id = uri.queryParameters['id'];

        LocalSharePreferences prefs = LocalSharePreferences();
        bool isLoggedIn = await prefs.getBool(AppConstant.LOGIN_BOOl);

        if (id != null && id.isNotEmpty) {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeepLink(id: id),
              ),
            );
          } else {
            fetchVersionAndNavigate();
          }
        } else {
          // ✅ Safety fallback if ID is missing
          fetchVersionAndNavigate();
        }
      } else {
        fetchVersionAndNavigate();
      }
    } on PlatformException {
      fetchVersionAndNavigate();
    }
  }
*/

  Future<void> fetchVersionAndNavigate() async {
    ApiResponse response = await ApiHelper().apiWithoutDilogDecodeGet(ApiConstant.GET_CURRENT_VERSION);
    Version version = Version.fromJson(response.response);
    if (version.version == AppConstant.APP_VERSION) {
      navigateToNextScreen();
    } else {
      showUpdateDialog();
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

  void openDeepLinkScreen(String type, String id) {
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeepLink(type: type, id: id),
      ),
    );
  }

  void showUpdateDialog() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('TKD Connect Update'),
        content: const Text(
          'A new version of TKD Connect is available. Please update the app from the Play Store to continue using all features.',
        ),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = checkNotificationPermissionStatus();
      });
    }
  }

}
