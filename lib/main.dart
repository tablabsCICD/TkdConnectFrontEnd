import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/route/routes.dart';
import 'generated/l10n.dart';
import 'dart:io' show Platform;

import 'notification/local_notification.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Notification Received ::::::"+message.data.toString());
  //print(message.notification!.title);
  LocalNotificationService.createanddisplaynotification(message);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid==true){
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyBWKkzTGCX53nAzzyFYgeJ9op4dajnDqF4",
        authDomain: "tkd-crm.firebaseapp.com",
        projectId: "tkdost-50f52",
        storageBucket: "tkdost-50f52.appspot.com",
        messagingSenderId: "24675079714",
        appId: "1:24675079714:android:42f78f78215191b7471c7b",
        measurementId: "G-HT44YEF6PL"

    ));
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen(backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(backgroundHandler);
    LocalNotificationService.initialize();
    getFCMToken();
  }

  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(

     designSize: const Size(375, 812),
        minTextAdapt: true,
    splitScreenMode: true,
    builder: (context , child) {
      return MaterialApp(

        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: S.delegate.supportedLocales,
        title: 'TKD Connect',
        //showPerformanceOverlay: true,
       theme:    ThemeData(
         primarySwatch: Colors.blue,
       fontFamily: GoogleFonts.poppins().fontFamily),
        initialRoute: AppRoutes.entryScreen,
        onGenerateRoute: RouteGenerator.generateRoute,
        builder: EasyLoading.init(),

      );
    }
    );
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

void setToken(String? token) {
  print('FCM Token: $token');
}

