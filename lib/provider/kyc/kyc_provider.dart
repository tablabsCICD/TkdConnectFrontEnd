import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/app_constant.dart';
import '../../model/response/verification_send_otp.dart';

class KycProvider extends BaseProvider{


  KycProvider(super.appState);

  bool isSendOTPButtonVisible=false;
  bool isButtonVisible=false;//   9860576408 ravi driver
  TextEditingController adharNumberController=TextEditingController();

  TextEditingController otpController1=TextEditingController();
  TextEditingController otpController2=TextEditingController();
  TextEditingController otpController3=TextEditingController();
  TextEditingController otpController4=TextEditingController();
  TextEditingController otpController5=TextEditingController();
  TextEditingController otpController6=TextEditingController();


  String tokenId="";
  String refId="";


  checkAdharNumber(BuildContext context){
    if(adharNumberController.text.length==12){
      isSendOTPButtonVisible=true;
    }else{
      isSendOTPButtonVisible=false;
    }
    notifyListeners();

  }


  createToken(BuildContext context)async{
    Map<String,dynamic>parameter={"version":1.0};
    ApiResponse apiResponse =await ApiHelper().apiPost("${ApiConstant.ADHAR_CREATE_TOKEN}?version=1.0");
    print('the parameter ${apiResponse.status}');
    if(apiResponse.status==200){
      print('the parameter ${apiResponse.response}');
      parameter=apiResponse.response;
      tokenId=parameter.values.first;
      sendOTPtoMobile( context);
    }else{
      ToastMessage.show(context, "Please try again");
    }

  }


  sendOTPtoMobile(BuildContext context)async{
    ApiResponse apiResponse =await ApiHelper().apiPost("${ApiConstant.ADHAR_SEND_OTP}?access-token=$tokenId&adharNumber=${adharNumberController.text}");
    print('the Send parameter ${apiResponse.status}');
    if(apiResponse.status==200){
      VerficationSendOTP verficationSendOTP=VerficationSendOTP.fromJson(apiResponse.response);
      refId=verficationSendOTP.data!.refId!;
      isButtonVisible=true;
      notifyListeners();
    }else{
        ToastMessage.show(context, "Please Enter Valid Adhar Number");
    }
  }


  verfiyOtp(BuildContext context) async{
    User user=await LocalSharePreferences().getLoginData();
    String otp=otpController1.text+otpController2.text+otpController3.text+otpController4.text+otpController5.text+otpController6.text;
    print('the user id${user.content!.first.id}');
    ApiResponse apiResponse =await ApiHelper().apiPost("${ApiConstant.ADHAR_VERFIY_OTP}?Authorization=$tokenId&otp=$otp&refId=$refId&userId=${user.content!.first.id}");
    print('the Send parameter ${apiResponse.response}');
    if(apiResponse.status==200){
      print('response is  ${apiResponse.status}');
      LocalSharePreferences().setString(AppConstant.LOGIN_KEY, jsonEncode(apiResponse.response));
      Navigator.pop(context);
      Navigator.pop(context);
      ToastMessage.show(context, "Your Aadhar number is verified ");
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Enter Valid Adhar Number");
    }
  }

  checkOtpValid(BuildContext context){
    if(otpController1.text.isNotEmpty && otpController2.text.isNotEmpty && otpController3.text.isNotEmpty &&
        otpController4.text.isNotEmpty && otpController5.text.isNotEmpty && otpController6.text.isNotEmpty){
      verfiyOtp(context);
    }else{
      ToastMessage.show(context, "Please Enter OTP");
    }

  }

}