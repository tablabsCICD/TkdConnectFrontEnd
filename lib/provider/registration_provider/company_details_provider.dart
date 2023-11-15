import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/provider/registration_provider/base_registration_provider.dart';

import '../../constant/app_constant.dart';
import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../screen/my_route/select_city.dart';

class CompanyDetailsProvider extends BaseRegistartionProvider{

  CompanyDetailsProvider(super.appState);
  List<RouteRequest> listRoute=[];

  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController companyTypeController = TextEditingController();
  bool isEnbale=false;
  String valName="${S().selectOne}";
  int selectType=-1;

  addRoute(RouteRequest routeRequest){
    listRoute.add(routeRequest);
    notifyListeners();
  }


  void showBootomSheet(BuildContext context) async {
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9, child: SelectCityScreen());
        });
    listRoute.add(routeRequest);
    notifyListeners();

  }

  checkValidation() {
    if (companyNameController.text.isNotEmpty &&
        locationController.text.isNotEmpty ) {

      if(selectType==-1){
        isEnbale = false;
      }else{
        isEnbale = true;
      }


    } else {
      isEnbale = false;
    }
    notifyListeners();
  }

  saveData(BuildContext buildContext){
    AppConstant.registerCompany.companyName=companyNameController.text.toString();
    AppConstant.registerCompany.city=locationController.text.toString();
    AppConstant.registerCompany.companyAddress=companyTypeController.text.toString();
    AppConstant.registerCompany.transporterOrAgent=selectType;
    registerCompany(buildContext);
  }

  void changeDropDown(String name,int val) {
    valName=name;
    selectType=val;
    checkValidation();
    notifyListeners();
  }



}