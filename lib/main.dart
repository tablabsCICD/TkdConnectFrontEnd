import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/route/routes.dart';
import 'generated/l10n.dart';

void main() {
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

