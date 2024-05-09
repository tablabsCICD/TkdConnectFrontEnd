import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/app_constant.dart';
import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../model/response/route_model.dart';
import '../../screen/my_route/select_city.dart';

class EditProfileProvider extends BaseProvider{

  //tabs

  String valName="${S().business_type}";
  int selectType=-1;

  //personal info feilds
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController mobileNameController = TextEditingController();
  bool isEnbale = false;
  late User user;

  //company details

  List<RouteData>routeList=[];

  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController companyTypeController = TextEditingController();
  static String profilePic="";


  EditProfileProvider():super(""){
    getData();

  }

  void showBootomSheet(BuildContext context) async {
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9, child: SelectCityScreen());
        });
    //listRoute.add(routeRequest);
    RouteData routeData=RouteData(id: 0, userId: user.content!.first.id, routeSource: routeRequest.startLocation, routeDestination: routeRequest.endLocation, loggedUserName:user.content!.first.userName );
    if(routeList.length>=5){
      ToastMessage.show(context, "You can add only 5 Routes");
    }else{
     // routeList.add(routeData);
      createRoute(routeData);
    }

    notifyListeners();

  }

  getData()async{
    user =await LocalSharePreferences().getLoginData();

    firstNameController.text=user.content!.first.firstName!;
    lastNameController.text=user.content!.first.lastName!;
    emailNameController.text=user.content!.first.emailId!;
    mobileNameController.text=user.content!.first.mobileNumber.toString()!;
    companyNameController.text=user.content!.first.companyName!;
    locationController.text=user.content!.first.city!;
    if(user.content!.first.transporterOrAgent==0){
      companyTypeController.text=S().agentBroker;
      valName=S().agentBroker+"/"+"${S().packersAndMovers}";
      selectType=0;
    }else if(user.content!.first.transporterOrAgent==1){
      companyTypeController.text= S().transporter;
      valName=S().transporter;
      selectType=1;
    }else if(user.content!.first.transporterOrAgent==2){
      companyTypeController.text= S().packersAndMovers;
      valName=S().packersAndMovers;
      selectType=2;
    }
    else if(user.content!.first.transporterOrAgent==3){
      companyTypeController.text= S().manufacturerDistributorTrade;
      valName=S().manufacturerDistributorTrade;
      selectType=3;
    }else{
      companyTypeController.text= S().truckDriver;
      valName=S().truckDriver;
     selectType=3;

    }
    profilePic=user.content!.first.companyLogo!;



    getRouteListByUserId();
    notifyListeners();

  }


    getRouteListByUserId() async {
      String myUrl = ApiConstant.MY_ROUTE(user.content!.first.id);
      ApiResponse req = await ApiHelper().apiWithoutDecodeGet(myUrl);
      print('the status is ${req.status} ${req.response}');
    if(req.status==200){
        RouteModel type = RouteModel.fromJson(req.response);
        routeList .clear();
        routeList .addAll(type.content) ;
      }
      notifyListeners();
    }

    deleteRoute(int index)async{
      String url = ApiConstant.ROUTE +'?id=${routeList[index].id}';
      var req = await ApiHelper().ApiDeleteData(url);
      if(req.status==200){
        routeList.removeAt(index);
      }else{

      }
      notifyListeners();
    }

    editRoute(BuildContext context,int index)async{

      RouteRequest routeRequest = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
                heightFactor: 0.9, child: SelectCityScreen(isEdit: true,sorceCity: routeList[index].routeSource,desCity: routeList[index].routeDestination,));
          });
      //listRoute.add(routeRequest);
      RouteData routeData=RouteData(id: routeList[index].id, userId: user.content!.first.id, routeSource: routeRequest.startLocation, routeDestination: routeRequest.endLocation, loggedUserName:user.content!.first.userName );
      if(routeList.length>=5){
        ToastMessage.show(context, "You can add only 5 Routes");
      }else{
        editRouteCall(routeData,index);
      }

      notifyListeners();

    }

   createRoute(RouteData routeData)async{
     ApiResponse req = await ApiHelper().postParameter(ApiConstant.ROUTE,routeData.toJson());
     if(req.status==200){
       RouteData data=RouteData.fromJson(req.response);
       routeList.add(data);
       notifyListeners();
     }else{

     }
     notifyListeners();

   }

  editRouteCall(RouteData routeData,int index)async{
    ApiResponse req = await ApiHelper().apiPut(ApiConstant.ROUTE,routeData.toJson());
    if(req.status==200){
      RouteData data=RouteData.fromJson(req.response);
      routeList[index]=data;

    }else{

    }
    notifyListeners();

  }


  editProfileImage(BuildContext context)async{
    profilePic =await postImage(context);
    saveChanges(context);
    notifyListeners();
  }

  saveChanges(BuildContext context)async{
    User user =await LocalSharePreferences().getLoginData();
    UserData userData=user.content!.first;
    userData.firstName=firstNameController.text;
    userData.lastName=lastNameController.text;
    userData.companyName=companyNameController.text;
    userData.companyAddress=locationController.text;
    userData.profilePicture=profilePic;
    userData.companyLogo=profilePic;
    if(selectType!=-1){
      userData.transporterOrAgent=selectType;
    }
    print('the select type $selectType');
    ApiResponse apiResponse=await ApiHelper().apiPut(ApiConstant.REGISTRATION, userData.toJson());
    if(apiResponse.status==200){
      LocalSharePreferences localSharePreferences=LocalSharePreferences();
      localSharePreferences.setString(AppConstant.LOGIN_KEY, jsonEncode(apiResponse.response));
      ToastMessage.show(context, "Profile updated");
      //Navigator.pop(context,1);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => true);
      notifyListeners();

    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  void changeDropDown(String name,int val) {
    valName=name;
    selectType=val;
    //checkValidation();
    notifyListeners();
  }



}