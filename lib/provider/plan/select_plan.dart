import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/api_response.dart';
import '../../screen/kyc/kyc_screen_one.dart';
import '../../screen/plan/plan_details_screen.dart';

class SelectPlanProvider extends BaseProvider {
  SelectPlanProvider(super.appState){
    checkPlan();
  }

  bool clearPearl = true;
  bool bluePearl = false;
  bool redPearl = false;
  bool blackPearl = false;
  String selectPlan = "CURRENT PLAN";
  int planAmount = 0;
  int selectedPlanCode=0;
  int previousPlan=0;
  static int previousPlanCheck=0;
  String expDate="";

  selectClearPerl() {
    selectedPlanCode=0;
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    clearPearl = true;
    bluePearl = false;
    redPearl = false;
    blackPearl = false;
    planAmount = 0;
    notifyListeners();
  }

  checkPlan()async{
    User user=await LocalSharePreferences().getLoginData();
    previousPlan=user.content!.first.isPaid!;
    previousPlanCheck=user.content!.first.isPaid!;
    selectedPlanCode=previousPlan;
    planAmount = 0;
    clearPearl = false;
    bluePearl = false;
    redPearl = false;
    blackPearl = false;
    switch(previousPlanCheck){
      case 0:clearPearl=true;
      notifyListeners();
            return;
      case 10:
        bluePearl=true;
        notifyListeners();
        return;
      case 20:
        redPearl=true;
        notifyListeners();
        return;
      case 30:
        blackPearl=true;
        notifyListeners();
        return;
    }
  }

  selectBlue() {
    selectedPlanCode=10;
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    clearPearl = false;
    bluePearl = true;
    redPearl = false;
    blackPearl = false;
    planAmount = 2000;
    notifyListeners();
  }

  selectRed() {
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    selectedPlanCode=20;
    clearPearl = false;
    bluePearl = false;
    redPearl = true;
    blackPearl = false;
    planAmount = 2500;
    notifyListeners();
  }

  selectBlack() {
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    selectedPlanCode=30;
    clearPearl = false;
    bluePearl = false;
    redPearl = false;
    blackPearl = true;
    planAmount = 5000;
    notifyListeners();
  }

  onDeatilsPlan(BuildContext context, List<String> listLaugaes,
      List<bool> selectLang, String image, String Title, String amount) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9,
              child: PlanDetailsScreen(
                listLaugaes: listLaugaes,
                selectLang: selectLang,
                image: image,
                subtitle: Title,
                amount: amount,
              )
          );
        }
    );
  }

  void showBootomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(heightFactor: 0.7, child: KYCScreenOne());
        });
  }

  goHome(BuildContext context) async {
    bool isLogin =
        await LocalSharePreferences().getBool(AppConstant.LOGIN_BOOl);
    if (isLogin) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    }
  }

  selectedPlan(BuildContext context) async {
    User user=await LocalSharePreferences().getLoginData();
    ApiResponse apiResponse = await ApiHelper().apiPutDat(ApiConstant.UPDATE_YOUR_PLAN(user.content!.first.id,selectedPlanCode));
    if (apiResponse.status == 200) {
   User user=User.fromJson(apiResponse.response);
      if(user.content!.isNotEmpty){
        LocalSharePreferences localSharePreferences=LocalSharePreferences();
        localSharePreferences.setBool(AppConstant.LOGIN_BOOl, true);
        localSharePreferences.setString(AppConstant.LOGIN_KEY, jsonEncode(apiResponse.response));
        ToastMessage.show(context, "Plan Update Success");
      }
      goHome(context);
    } else {
      print('the fail is ');
      ToastMessage.show(context, "Try Again");
    }
  }
}
