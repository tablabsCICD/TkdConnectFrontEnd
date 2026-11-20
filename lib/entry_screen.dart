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
import 'package:tkd_connect/screen/deeplink/deeplink_service.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generated/l10n.dart';

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

  final DeepLinkService _deepLinkService = DeepLinkService();

  bool _hasShownDisclosure = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasShownDisclosure) {
        _hasShownDisclosure = true;

        int userType = await getUserType();
        debugPrint("✅userType: $userType");
        if (userType == 6) {
          // ✅ Only drivers see disclosure
          showProminentDisclosureDialog();
        } else {
          // ✅ Others skip background flow
          requestAllPermissions();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ---------------- GET USER TYPE ----------------
  Future<int> getUserType() async {
    LocalSharePreferences prefs = LocalSharePreferences();
    return await prefs.getInt(AppConstant.CURRENT_USERTYPE) ?? 0;
  }

  // ---------------- DISCLOSURE ----------------
  void showProminentDisclosureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Background Location Access",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Text(
              "TKD Connect collects location data, including in the background, "
                  "to provide live route tracking between source and destination for accepted quotes. "
                  "This ensures accurate route updates and delivery tracking even when the app is closed.\n\n"
                  "Location data is used only for tracking and delivery purposes.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                requestForegroundLocation();
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  // ---------------- FOREGROUND LOCATION ----------------
  Future<void> requestForegroundLocation() async {
    PermissionStatus status =
    await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      int userType = await getUserType();

      if (userType == AppConstant.USER_DRIVER) {
        // ✅ Driver → ask background
        requestBackgroundLocation();
      } else {
        // ✅ Others → skip background
        requestAllPermissions();
      }
    } else {
      openAppSettings();
    }
  }

  // ---------------- BACKGROUND LOCATION ----------------
  Future<void> requestBackgroundLocation() async {
    PermissionStatus status =
    await Permission.locationAlways.request();

    if (status.isGranted) {
      requestAllPermissions();
    } else {
      showBackgroundPermissionDialog();
    }
  }

  void showBackgroundPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Allow Background Location"),
          content: const Text(
            "Please allow 'All the time' location access so we can track deliveries in real-time.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  // ---------------- OTHER PERMISSIONS ----------------
  Future<void> requestAllPermissions() async {
    await Permission.locationWhenInUse.request();
    await Permission.notification.request();

    String permissionStatus = await checkNotificationPermissionStatus();

    if ([permGranted, permProvisional].contains(permissionStatus)) {
      fetchVersionAndNavigate();
    } else {
      showPermissionDialog();
    }
  }

  Future<String> checkNotificationPermissionStatus() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) return permGranted;
    if (status.isDenied) return permDenied;
    if (status.isRestricted || status.isPermanentlyDenied) {
      return permUnknown;
    }
    return permProvisional;
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Notification Permission',
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Please enable notification permissions to receive updates.',
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Permission.notification.request();
              Navigator.pop(context);
              fetchVersionAndNavigate();
            },
            child: const Text('Enable'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              fetchVersionAndNavigate();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  // ---------------- VERSION CHECK ----------------
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

  void navigateToNextScreen() async {
    LocalSharePreferences prefs = LocalSharePreferences();

    bool isLoggedIn = await prefs.getBool(AppConstant.LOGIN_BOOl);
    String langCode = await prefs.getLangCode();

    if (isLoggedIn) {
      S.load(Locale(langCode));

      if (!_deepLinkService.isDeepLinkActive) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    } else {
      if (langCode == "no") {
        Navigator.pushReplacementNamed(context, AppRoutes.select_lang);
      } else {
        S.load(Locale(langCode));
        Navigator.pushReplacementNamed(
            context, AppRoutes.registration_personal_details);
      }
    }
  }

  // ---------------- UPDATE ----------------
  void showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('TKD Connect Update'),
        content: const Text(
          'A new version is available. Please update the app.',
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
        permissionStatusFuture =
            checkNotificationPermissionStatus();
      });
    }
  }
}