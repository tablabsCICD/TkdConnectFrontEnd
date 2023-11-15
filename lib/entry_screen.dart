import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class EntryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EntryScreen();
  }

}
class _EntryScreen extends State<EntryScreen> {
  @override
  void initState() {
    // TODO: implement initState
   // startTimer();
    versionControllApi();
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

  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {

              callNextScreen();
              timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void callNextScreen() async{
    LocalSharePreferences localSharePreferences=LocalSharePreferences();
    bool isLogin=await localSharePreferences.getBool(AppConstant.LOGIN_BOOl);
    String val=await localSharePreferences.getLangCode();
    if(isLogin){
     // S.load(Locale("hi"));
      S.load(Locale(val));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }else{

      if(val=="no"){
        Navigator.pushReplacementNamed(context, AppRoutes.select_lang);
      }else{
        S.load(Locale(val));
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }

    }
  }

  versionControllApi() async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDilogDecodeGet(ApiConstant.GET_CURRENT_VERSION);
    Version version=Version.fromJson(apiResponse.response);
    print('the version is ${version.version}');
    if(version.version! == AppConstant.APP_VERSION){
      callNextScreen();
    }else{
      upDateDailog();
    }

    try{

    }catch (e){

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

}