import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';

class OtpProvider extends BaseProvider{

  TextEditingController textControllerOne=TextEditingController();
  TextEditingController textControllerTwo=TextEditingController();
  TextEditingController textControllerThree=TextEditingController();
  TextEditingController textControllerFour=TextEditingController();
  TextEditingController textControllerFive=TextEditingController();
  TextEditingController textControllerSix=TextEditingController();
  bool isButtonEnbale=false;
  bool resendButtonEnble=false;
  String mobileNumber;
  bool isRegistration;


  OtpProvider(super.appState,this.mobileNumber,this.isRegistration){
    startTimer();
  }
  late Timer _timer;
  int start = 60;
  String timeRemaning="01:00";

  void startTimer() {

    const oneSec = const Duration(seconds: 1);
    resendButtonEnble=false;
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          resendButtonEnble=true;
          notifyListeners();
          timer.cancel();
        } else {
          resendButtonEnble=false;
          start--;
          timeRemaning= formatedTime(timeInSecond: start);
          notifyListeners();
        }
      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
  onCallButtonEnble(){
    if(textControllerOne.text.toString().isNotEmpty && textControllerTwo.text.toString().isNotEmpty &&  textControllerThree.text.toString().isNotEmpty &&  textControllerFour.text.toString().isNotEmpty
        &&  textControllerFive.text.toString().isNotEmpty &&  textControllerSix.text.toString().isNotEmpty){
      isButtonEnbale=true;
    }else{
      isButtonEnbale =false;
    }
    notifyListeners();
  }
  onClickResend(BuildContext context){
    if(resendButtonEnble){
      resendOtp(context,mobileNumber);
    }
  }

  formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  verifyOtp(BuildContext context) async{
    String  _deviceId="null";
    try {
      _deviceId = (await FirebaseMessaging.instance.getToken())!;
    } on PlatformException {
      _deviceId = 'Failed to get deviceId.';
    }
    print('the device id is $_deviceId');
    String otp=textControllerOne.text+textControllerTwo.text+textControllerThree.text+textControllerFour.text+textControllerFive.text+textControllerSix.text;

    String myUrl = ApiConstant.OTP_VERIFICATION(mobileNumber,otp);
    var req = await ApiHelper().apiPost(myUrl);
    if(req.status== 200){
     // try{
        User user=User.fromJson(req.response);
        if(user.content!.length>0){
          LocalSharePreferences localSharePreferences=LocalSharePreferences();
          localSharePreferences.setBool(AppConstant.LOGIN_BOOl, true);
          localSharePreferences.setString(AppConstant.LOGIN_KEY, jsonEncode(req.response));

          if(isRegistration){
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,(Route<dynamic> route) => false);
          }else{
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,(Route<dynamic> route) => false);
          }
        }else{
          ToastMessage.show(context,"Please try again");
        }

      notifyListeners();

    }else{
      ToastMessage.show(context,"Please try again");
    }

  }
  resendOtp(BuildContext context,String mobileNumber) async{
    var req = await ApiHelper().apiPost(ApiConstant.SEND_OTP(mobileNumber));
    if(req.status==200){
      start=60;
      startTimer();
      ToastMessage.show(context, "OTP resend Successfully");
    }
    notifyListeners();
  }

}