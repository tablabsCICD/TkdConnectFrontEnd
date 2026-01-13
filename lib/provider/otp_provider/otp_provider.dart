import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/toast.dart';
import '../../constant/api_constant.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';

class OtpProvider extends BaseProvider {
  final String mobileNumber;
  final bool isRegistration;

 // ✅ Holds current OTP (typed or auto-filled)
  bool resendButtonEnabled = false;

  late Timer _timer;
  int start = 60;
  String timeRemaining = "01:00";


  OtpProvider(super.appState, this.mobileNumber, this.isRegistration) {
    startTimer();
  }

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



  Future<void> resendOtp(BuildContext context, String mobileNumber) async {
    var req = await ApiHelper().apiPost(ApiConstant.SEND_OTP(mobileNumber));
    if (req.status == 200) {
      start = 60;
      startTimer();
      ToastMessage.show(context, "OTP resent successfully");
    }
    notifyListeners();
  }

  void onClickResend(BuildContext context) {
    if (resendButtonEnabled) {
      resendOtp(context, mobileNumber);
    }
  }
}
