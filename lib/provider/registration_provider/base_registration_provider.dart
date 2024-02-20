import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/request/register_company.dart';
import '../../model/request/route_request.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';
import '../base_provider.dart';

class BaseRegistartionProvider extends BaseProvider{



  BaseRegistartionProvider(super.appState);

  registerCompany(BuildContext context)async{




    ApiHelper apiHelper=ApiHelper();
    ApiResponse apiResponse=await apiHelper.postParameter(ApiConstant.REGISTRATION,AppConstant.registerCompany.toJson());
    print('the response ${apiResponse.response}');
    if(apiResponse.status==200){

      Navigator.pushReplacementNamed(context, AppRoutes.otp_registration,arguments:AppConstant.registerCompany.mobileNumber);

      // User user=User.fromJson(apiResponse.response);
      // if(user.content!.length>0){
      //   LocalSharePreferences localSharePreferences=LocalSharePreferences();
      //   localSharePreferences.setBool(AppConstant.LOGIN_BOOl, true);
      //   localSharePreferences.setString(AppConstant.LOGIN_KEY, jsonEncode(apiResponse.response));
      //   Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,(Route<dynamic> route) => false);
      // }else{
      //   ToastMessage.show(context,"Please try again");
      // }
      //
      // notifyListeners();

    }else{
      ToastMessage.show(context, "Mobile number or Email id should be used already please change");
    }

  }



}