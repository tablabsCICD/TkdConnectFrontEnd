import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/validation.dart';

import '../constant/app_constant.dart';
import '../model/response/delete_user.dart';
import '../model/response/userdata.dart';
import '../network/api_helper.dart';
import '../utils/sharepreferences.dart';
import '../utils/toast.dart';

class LoginProvider extends BaseProvider{
  bool isMobileNumberValid=false;
  LoginProvider(super.appState);

  void callOtp(BuildContext context,String mobileNumber) async{
    var req = await ApiHelper().apiPost(ApiConstant.SEND_OTP(mobileNumber));
    if(req.status==200){
      Navigator.pushNamed(context,AppRoutes.otp,arguments: mobileNumber);
    }else{
      ToastMessage.show(context, "Please try again");
    }
    notifyListeners();
  }


  void callSwitch(DeleteUser user,BuildContext context,String mobileNumber) {
    switch (user.errorCode){
      case '200':
        callOtp(context,mobileNumber);
        break;
      case '201':
        ToastMessage.show(context, "User is deleted please register again");
        break;
      case '500':
        ToastMessage.show(context, "Mobile number is not register please register");
        break;
    }
  }

  isUserDeleted(String mobileNumber,BuildContext context)async{
    if(Validation().isValidPhoneNumber(mobileNumber)){
      ApiHelper apiHelper=ApiHelper();
      var response= await apiHelper.apiGet(ApiConstant.USER_FIND_BY_MOBILE(mobileNumber));
      if(response.status==200){
        DeleteUser deleteUser=DeleteUser.fromJson(response.response);
        callSwitch(deleteUser,context,mobileNumber);
      }else{
        ToastMessage.show(context, " Please try again ");
      }
    }else{
      ToastMessage.show(context, " Enter valid mobile number ");
    }
  }

  isMobileValide(String mobile){
    isMobileNumberValid= Validation().isValidPhoneNumber(mobile);
    notifyListeners();
  }

  String otpCode = ''; // ✅ Holds current OTP (typed or auto-filled)
  bool isLoginButtonEnabled = false;
  bool resendButtonEnabled = false;
  bool isOtpInvalid = false;

  late Timer _timer;
  int start = 60;
  String timeRemaining = "01:00";
  VoidCallback? onInvalidOtp;



  void startTimer() {
    const oneSec = Duration(seconds: 1);
    resendButtonEnabled = false;
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start == 0) {
        resendButtonEnabled = true;
        timer.cancel();
      } else {
        start--;
      }
      timeRemaining = _formatTime(start);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int sec = seconds % 60;
    int min = (seconds / 60).floor();
    String minute = min < 10 ? "0$min" : "$min";
    String second = sec < 10 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  /// ✅ Updates OTP and enables button when 6 digits entered
  void updateOtp(String code) {
    otpCode = code;
    isLoginButtonEnabled = otpCode.length == 6;
    notifyListeners();
  }

  Future<void> verifyOtp(BuildContext context,String mobileNumber) async {
    if (otpCode.length != 6) {
      ToastMessage.show(context, "Please enter a valid 6-digit OTP");
      return;
    }

    String deviceId = '';
    try {
      deviceId = await FirebaseMessaging.instance.getToken() ?? '';
    } catch (e) {
      print("❌ FCM token fetch failed: $e");
    }

    print("📨 Verifying OTP: $otpCode for mobile: $mobileNumber");

    String myUrl = ApiConstant.OTP_VERIFICATION(mobileNumber, otpCode, deviceId);
    var req = await ApiHelper().apiPost(myUrl);

    if (req.status == 200) {
      try {
        User user = User.fromJson(req.response);
        if (user.content!.isNotEmpty) {
          LocalSharePreferences prefs = LocalSharePreferences();
          await prefs.setBool(AppConstant.LOGIN_BOOl, true);
          await prefs.setString(AppConstant.LOGIN_KEY, jsonEncode(req.response));

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
                (route) => false,
          );
        } else {
          ToastMessage.show(context, "Please try again");
        }
      } catch (e) {
        ToastMessage.show(context, "Error verifying OTP");
      }
    } else {
      ToastMessage.show(context, "Invalid OTP, please try again");
      if (onInvalidOtp != null) {
        onInvalidOtp!(); // ✅ Trigger shake safely
      }
      isOtpInvalid = true;
    }
    notifyListeners();
  }

  Future<void> resendOtp(BuildContext context, String mobileNumber) async {
    var req = await ApiHelper().apiPost(ApiConstant.SEND_OTP(mobileNumber));
    if (req.status == 200) {
      start = 60;
      startTimer();
      ToastMessage.show(context, "OTP resent successfully");
    }
    notifyListeners();
  }

  void onClickResend(BuildContext context,String mobileNumber) {
    if (resendButtonEnabled) {
      resendOtp(context, mobileNumber);
    }
  }
}