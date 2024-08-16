import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/request/RegistrationUserWithRoute.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../route/app_routes.dart';
import '../base_provider.dart';

class BaseRegistartionProvider extends BaseProvider{
  BaseRegistartionProvider(super.appState);
  registerCompany(BuildContext context,List<RouteReq> listRoute)async{
    ApiHelper apiHelper=ApiHelper();
    RegistrationUserWithRoute registration=RegistrationUserWithRoute();
    registration.user=AppConstant.registerCompany;
    registration.route=listRoute;
    ApiResponse apiResponse=await apiHelper.postParameter(ApiConstant.REGISTRATION,AppConstant.registerCompany.toJson());
    if(apiResponse.status==200){
     Navigator.pushReplacementNamed(context, AppRoutes.otp_registration,arguments:AppConstant.registerCompany.mobileNumber);
    }else{
      ToastMessage.show(context, "Mobile number or Email id should be used already please change");
    }
  }

}