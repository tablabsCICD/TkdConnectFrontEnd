import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:http/http.dart' as http;
import '../../model/request/route_request.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/userdata.dart';
import '../../screen/my_route/select_city.dart';
import '../../utils/sharepreferences.dart';
class HomeScreenProvider extends BaseProvider{


  String fromCity="All";
  String toCity="All";
  bool isLoading = false;
  var response;
  bool isFirstLoading = false;
  int totalPages = 0;
  bool fla = false,pla = false,flr = false,plr = false;
  List truckLoadTypeList=[];
  ScrollController scrollController = ScrollController();
  int selectedPage=0;
  String imageUrl='';
  bool filterisVisible = false;
  String drooDwonheading="All routes requirements";
  HomeScreenProvider(BuildContext context) : super('Ideal'){
    callDashboradApi(context,selectedPage);
    pagenation(context);
    callUserData();
  }

  onCliclFilter(BuildContext context){
    if(filterisVisible){
      filterisVisible=false;
      truckLoadTypeList.clear();
      notifyListeners();
      selectedPage=0;
       fromCity="All";
       toCity="All";
      callDashboradApi(context,0);
    }else{
      filterisVisible=true;
    }
    notifyListeners();
  }

  callDashboradApi(BuildContext context,currentPage)async{

    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    EasyLoading.show(status: "Loading");
    String url="";
    if(fromCity=="All" && toCity=="All"){
      url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}';

    }else{
      url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&source=$fromCity&destination=$toCity';
    }
   // print('the url $url');

    var req = await http.get(Uri.parse(url));
    isFirstLoading= false;
    isLoading = false;
    if(req.statusCode == 200) {
      response = json.decode(req.body);
      var type = TruckLoadType.fromJson(response);
      totalPages = type.totalPages;
      truckLoadTypeList.addAll(type.content);
      //print('the size is ${truckLoadTypeList.length}');
      EasyLoading.dismiss();
      notifyListeners();
    }

  }
  pagenation(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        selectedPage++;
        callDashboradApi(context,selectedPage);

      }
    });
  }

  void callUserData() async{
   User user=await LocalSharePreferences.localSharePreferences.getLoginData();
   if(user.content!.first.profilePicture!=null){
     imageUrl=user.content!.first.profilePicture!;
   }

   notifyListeners();
  }

  applyDropDwonFilter(BuildContext context){
    selectedPage=0;
    truckLoadTypeList.clear();
    notifyListeners();
    callDashboradApi(context,0);
  }
  falseAllFilter(){
    fla = false;pla = false;flr = false;plr = false;
  }

  selectCityFilter(BuildContext context)async{
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9, child: SelectCityScreen());
        });
    fromCity=routeRequest.startLocation;
    toCity=routeRequest.endLocation;
    selectedPage=0;
    truckLoadTypeList.clear();
    notifyListeners();
    callDashboradApi(context,0);
    //notifyListeners();
  }

  // pullRefresh(BuildContext context){
  //   selectedPage=0;
  //   truckLoadTypeList.clear();
  //   notifyListeners();
  //   callDashboradApi(context, 0);
  //
  // }


}