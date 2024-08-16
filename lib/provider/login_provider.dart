import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/validation.dart';

import '../model/response/delete_user.dart';
import '../network/api_helper.dart';
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
}