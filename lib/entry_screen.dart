import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:tkd_connect/screen/bulkupload/load_upload.dart';
import 'package:tkd_connect/screen/deeplink/deeplinkscreen.dart';
import 'package:tkd_connect/screen/deeplink/show_bidds.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generated/l10n.dart';

import 'model/response/version.dart';



class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EntryScreen();
  }

}
class _EntryScreen extends State<EntryScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    // TODO: implement initState
    inPermision();

    // initUniLinks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     body: SizedBox(
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
    print('the version ${ApiConstant.GET_CURRENT_VERSION}');
    ApiResponse apiResponse=await ApiHelper().apiWithoutDilogDecodeGet(ApiConstant.GET_CURRENT_VERSION);
     print('the version is ${apiResponse.response}');
    Version version=Version.fromJson(apiResponse.response);

    if(version.version == AppConstant.APP_VERSION){
      callNextScreen();
      //callScreen();Api
    }else{
      upDateDailog();
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }



  void upDateDailog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('TKD Connect Update'),
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
      initUniLinks();

    }else {
      permissionDialog();

    }
  }

  Widget permissionNotification(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //textWidget,
        const SizedBox(
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
     ApiResponse result=await ApiHelper().apiPostWithoutDialog("${ApiConstant.UPDATE_DEVICE_ID}?userId=${user.content!.first.id}&deviceId=$token");
      ApiResponse apiResponse=await ApiHelper().apiWithoutDilogDecodeGet("${ApiConstant.BASE_URL}companyRegistration/getSameLoginResponse/${user.content!.first.id}");
     //print('${ApiConstant.BASE_URL+"companyRegistration/getSameLoginResponse/${user.content!.first.id}"}');
      if(apiResponse.status==200){

        User user=User.fromJson(jsonDecode(apiResponse.response));
       if(user.content!.isNotEmpty){
        // print('added unb ${apiResponse.response.toString()}');
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




  callScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>const ShowAllBids( id: "22",)));

  }

  Future<void> initUniLinks() async {
      try {
        String? initialLink = await getInitialLink();
        if(initialLink!=null){
          LocalSharePreferences localSharePreferences=LocalSharePreferences();
          bool isLogin=await localSharePreferences.getBool(AppConstant.LOGIN_BOOl);
          if(isLogin){
            String number=initialLink.split("/").last;
            Navigator.push(context, MaterialPageRoute(builder: (_)=>DeepLink(id: number)));
    }else{

            versionControllApi();
          }
        }else{
          versionControllApi();
        }

        // Parse the link and warn the user, if it is not correct,
        // but keep in mind it could be `null`.
      } on PlatformException {
        // Handle exception by warning the user their action did not succeed
        // return?
        versionControllApi();
      }


  }





}