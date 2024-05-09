import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generated/l10n.dart';
import 'model/response/version.dart';

class EntryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EntryScreen();
  }

}
class _EntryScreen extends State<EntryScreen> with WidgetsBindingObserver{
  @override
  void initState() {
    // TODO: implement initState
   // startTimer();
    versionControllApi();
    //callNextScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     body: Container(
       width: MediaQuery.of(context).size.width,

       height: MediaQuery.of(context).size.height,
       child: Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(
           //  decoration: BoxDecoration(color: Color(0xFF001E49)),
             child: SvgPicture.asset(Images.logo,height: 93.h,width: 160.w,),
           ),
         ],
       ),
     ),

   );
  }


  void callNextScreen() async{
    LocalSharePreferences localSharePreferences=LocalSharePreferences();
    bool isLogin=await localSharePreferences.getBool(AppConstant.LOGIN_BOOl);
    String val=await localSharePreferences.getLangCode();
    if(isLogin){
      await callToken();
      S.load(Locale(val));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }else{
      if(val=="no"){
        Navigator.pushReplacementNamed(context, AppRoutes.select_lang);
      }else{
        S.load(Locale(val));
        Navigator.pushReplacementNamed(context, AppRoutes.registration_personal_details);
      }

    }
  }

  versionControllApi() async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDilogDecodeGet(ApiConstant.GET_CURRENT_VERSION);
    Version version=Version.fromJson(apiResponse.response);
   // print('the version is ${version.version}');
    if(version.version == AppConstant.APP_VERSION){
      callNextScreen();
    }else{
      upDateDailog();
    }

  }



  void upDateDailog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('TKDost Update'),
        content: const Text('New application update is available on play store please update the app.',),
        actions: <Widget>[
          TextButton(
            onPressed:(){
              redirectionUrl();
            } ,
            child: const Text('Update',),
          ),
        ],
      ),
    );
  }


  void redirectionUrl() {
    final url = Uri.parse(
      'market://details?id=com.pdk.tkd',
    );
    launchUrl(url,mode:LaunchMode.externalApplication);

  }



  late Future<String> permissionStatusFuture;

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  void inPermision() async{

    //await repeatProvider.checkRepeatTim();


    permissionStatusFuture =  getCheckNotificationPermStatus();
    String permissionStatusFutures= await getCheckNotificationPermStatus();
    //permissionStatusFuture=permissionStatusFutures.toString() as Future<String>;
    WidgetsBinding.instance.addObserver(this);
    if(permissionStatusFutures.toString().compareTo(permGranted)==0 || permissionStatusFutures.toString().compareTo(permProvisional)==0){
        versionControllApi();

    }else {
      permissionDialog();

    }
  }

  Widget permissionNotification(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //textWidget,
        SizedBox(
          height: 20,
        ),
        TextButton(
          //color: Colors.amber,
          child: Text("Ask for notification status".toUpperCase()),
          onPressed: () {
            // show the dialog/open settings screen
            NotificationPermissions.requestNotificationPermissions(

                iosSettings: const NotificationSettingsIos(
                    sound: true, badge: true, alert: true))
                .then((_) {
              // when finished, check the permission status
              setState(() {
                permissionStatusFuture =
                    getCheckNotificationPermStatus();
              });
            });
          },
        )
      ],
    );
  }


  void permissionDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:  Text('Notification Permission',style:  TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        ),
        content:  Text('Please Enable Notification permission',style:  TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),),
        actions: <Widget>[
          TextButton(
            onPressed:(){

              NotificationPermissions.requestNotificationPermissions(
                  iosSettings: const NotificationSettingsIos(
                      sound: true, badge: true, alert: true))
                  .then((_) {
                // when finished, check the permission status
                setState(() {
                  permissionStatusFuture =getCheckNotificationPermStatus();
                });


              });


            } ,
            child:  Text('Enable Permission',style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),),
          ),

          TextButton(
            onPressed:(){

                versionControllApi();

            } ,
            child:  Text('Close',style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),),
          ),
        ],
      ),
    );
  }



  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }
  }


  callToken()async {
   try{





     User user=await LocalSharePreferences.localSharePreferences.getLoginData();

     String? token=await FirebaseMessaging.instance.getToken();
     ApiResponse result=await ApiHelper().apiPostWithoutDialog(ApiConstant.UPDATE_DEVICE_ID+"?userId=${user.content!.first.id}"+"&deviceId=${token}");
      ApiResponse apiResponse=await ApiHelper().apiWithoutDilogDecodeGet(ApiConstant.BASE_URL+"companyRegistration/getSameLoginResponse/${user.content!.first.id}}");
      if(apiResponse.status==200){

        User user=User.fromJson(jsonDecode(apiResponse.response));
       if(user.content!.length>0){
         print('added unb ${apiResponse.response.toString()}');
         LocalSharePreferences localSharePreferences=LocalSharePreferences();
         localSharePreferences.setBool(AppConstant.LOGIN_BOOl, true);
         localSharePreferences.setString(AppConstant.LOGIN_KEY, apiResponse.response);

     }
   }
   }
   catch (e){
      print(e);
   }

  }

}