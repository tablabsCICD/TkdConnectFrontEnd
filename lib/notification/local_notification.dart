


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tkd_connect/route/app_routes.dart';

import '../constant/app_constant.dart';
import '../main.dart';
import '../screen/deeplink/deeplinkscreen.dart';
import '../utils/sharepreferences.dart';
class LocalNotificationService{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings("tkd_logo"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        if (id!.isNotEmpty) {
          LocalSharePreferences localSharePreferences=LocalSharePreferences();
          bool isLogin=await localSharePreferences.getBool(AppConstant.LOGIN_BOOl);
         if(isLogin){
            Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (_)=>DeepLink(id: id)));

          }else{
            Navigator.pushNamed(navigatorKey.currentState!.context, AppRoutes.login);
          }

       }
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
  try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "TKD Connect",
          "TKD Connect",
          icon: "tkd_logo",
          largeIcon:DrawableResourceAndroidBitmap('@mipmap/ic_launcher') ,
          importance: Importance.max,
          priority: Priority.high,

        ),
      );

      //  print('the massage data value is ${message.data}');
      // print('the massage data value is ${message.data.toString()}');
      await _notificationsPlugin.show(
        int.parse(message.data["Id"]),
        message.data['title'],
        message.data['body'],
        notificationDetails,
        payload: message.data["Id"],
      );

    } on Exception catch (e) {
      print(e);
    }

  }




}