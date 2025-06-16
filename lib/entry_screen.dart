import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/screen/deeplink/deeplinkscreen.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:uni_links5/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';
import 'model/response/version.dart';

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
    checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(Images.logo, height: 93.h, width: 160.w),
            ),
            const SizedBox(height: 16),
            Text(
              "Tkd Connect",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
      await updateToken();
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

  Future<void> updateToken() async {
    try {
      User user = await LocalSharePreferences.localSharePreferences.getLoginData();
      String? token = await FirebaseMessaging.instance.getToken();

      await ApiHelper().apiPostWithoutDialog("${ApiConstant.UPDATE_DEVICE_ID}?userId=${user.content!.first.id}&deviceId=$token");

      ApiResponse response = await ApiHelper().apiWithoutDilogDecodeGet("${ApiConstant.BASE_URL}companyRegistration/getSameLoginResponse/${user.content!.first.id}");

      if (response.status == 200) {
        User updatedUser = User.fromJson(jsonDecode(response.response));
        if (updatedUser.content!.isNotEmpty) {
          LocalSharePreferences prefs = LocalSharePreferences();
          prefs.setBool(AppConstant.LOGIN_BOOl, true);
          prefs.setString(AppConstant.LOGIN_KEY, response.response);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
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
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Notification Permission',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Please enable notification permissions.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              requestNotificationPermission().then((_) {
                setState(() {
                  permissionStatusFuture = checkNotificationPermissionStatus();
                });
              });
            },
            child: Text(
              'Enable Permission',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: fetchVersionAndNavigate,
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
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
