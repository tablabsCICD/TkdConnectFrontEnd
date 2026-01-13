import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tkd_connect/model/response/quoteResponse.dart';
import 'package:tkd_connect/provider/location/location_provider.dart';
import 'package:tkd_connect/provider/message/chat_provider.dart';
import 'package:tkd_connect/provider/mybids/my_bids_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/route/routes.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tkd_connect/screen/deeplink/deeplink_service.dart';
import 'package:tkd_connect/service/background_service.dart';
import 'generated/l10n.dart';
import 'dart:io' show Platform;
import 'notification/local_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print("Notification Received ::::::${message.data}");
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
  LocalNotificationService.createanddisplaynotification(message);
}
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // ⚠️ Your existing initialization (untouched)
  if (Platform.isAndroid == true) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBWKkzTGCX53nAzzyFYgeJ9op4dajnDqF4",
          authDomain: "tkd-crm.firebaseapp.com",
          projectId: "tkdost-50f52",
          storageBucket: "tkdost-50f52.appspot.com",
          messagingSenderId: "24675079714",
          appId: "1:24675079714:android:42f78f78215191b7471c7b",
        ));

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    LocalNotificationService.initialize();
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen(backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(backgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        LocalNotificationService.createanddisplaynotification(message);
      }
    });
    getFCMToken();
  }

  // ✅ NEW: Initialize local notifications for popup (safe addition)
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ✅ NEW: Listen for OTP verification FCM message and show popup
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received FCM: ${message.data}");
    if (message.data["type"] == "otp_verification") {
      String otp = message.data["otp"] ?? "";
      _showOtpDialog(navigatorKey.currentContext!, otp);
    }
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();


  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      initialNotificationTitle: "Vehicle Tracking",
      initialNotificationContent: "Tracking running in background",
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: (service) => true,
    ),
  );

  runApp(MyApp(prefs: prefs));
}



// ✅ NEW: OTP popup dialog
void _showOtpDialog(BuildContext context, String otp) {
  if (context == null) return;
  showDialog(
    context: context,
    builder: (context) {
      final TextEditingController otpController = TextEditingController();
      return AlertDialog(
        title: const Text("Enter OTP"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("OTP received: $otp"),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Enter OTP here"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (otpController.text == otp) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Success")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid OTP")),
                );
              }
            },
            child: const Text("Verify"),
          ),
        ],
      );
    },
  );
}


class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _MyApp(prefs: prefs);
  }
}


class _MyApp extends State<MyApp> {

  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final DeepLinkService _deepLinkService = DeepLinkService();
  _MyApp({required this.prefs});

    @override
  void initState() {
    // TODO: implement initState
      //getAppHash();
      sendNotification();
      super.initState();
  }


 /* Future<void> getAppHash() async {
    final signature = await SmsAutoFill().getAppSignature;
    print("✅ YOUR APP HASH: $signature");
  }
*/

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
   //   _deepLinkService.init(context);
    });
    return  ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context , child) {
          return MultiProvider(
            providers: [
              Provider<ChatProvider>(
                create: (_) => ChatProvider(
                  prefs: prefs,
                  firebaseFirestore: firebaseFirestore,
                  firebaseStorage: firebaseStorage,
                ),
              ),
              ChangeNotifierProvider(create: (_) => MyBidsProvider('Idel')),
              ChangeNotifierProvider(create: (_) => DriverTrackingProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: 'TKD Connect',
              theme:    ThemeData(
                  useMaterial3: false,
                  primarySwatch: Colors.blue,
                  fontFamily: GoogleFonts.poppins().fontFamily),
              initialRoute: "/",
              onGenerateRoute: RouteGenerator.generateRoute,
              builder: EasyLoading.init(),
              navigatorKey: navigatorKey,
            ),
          );
        }
    );
  }

  sendNotification()async{
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }
}


late Stream<String> _tokenStream;
getFCMToken(){
  FirebaseMessaging.instance
      .getToken().then(setToken);
  _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
  _tokenStream.listen(setToken);
  print("Fcm toke: ${FirebaseMessaging.instance
     .getToken().toString()}");
}


Future<void> setToken(String? token) async {
  String? token1= await token;
  print('FCM Token: $token1');
}




