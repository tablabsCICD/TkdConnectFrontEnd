import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_connect/model/response/quoteResponse.dart';
import 'package:tkd_connect/provider/message/chat_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/route/routes.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'generated/l10n.dart';
import 'dart:io' show Platform;
import 'notification/local_notification.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Notification Received ::::::${message.data}");
  LocalNotificationService.createanddisplaynotification(message);
}
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
 /* SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
*/

  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid==true){
    await Firebase.initializeApp(options: const FirebaseOptions(
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

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp( MyApp(prefs: prefs,));
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

  _MyApp({required this.prefs});

    @override
  void initState() {
    // TODO: implement initState
      sendNotification();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
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




