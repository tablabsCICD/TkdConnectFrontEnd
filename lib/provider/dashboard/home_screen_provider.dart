import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/response/comment_response.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:http/http.dart' as http;
import '../../model/api_response.dart';
import '../../model/request/route_request.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../screen/my_route/select_city.dart';
import '../../screen/my_route/select_one_city.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
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
 late User user ;
  int ispaid=0;
  bool filterisVisible = false;

  String drooDwonheading="All routes requirements";
  HomeScreenProvider(BuildContext context) : super('Ideal'){
    callUserData();
    callDashboradApi(context,selectedPage);
    pagenation(context);
    //callToken();

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
    if(currentPage==0){
      truckLoadTypeList.clear();
      print('the clear the api');
      notifyListeners();
    }
    if(fromCity=="All" && toCity=="All"){
      url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&loggedUserId=${user.content!.first.id}';

    }else{

      if(fromCity != "All" && toCity!="All"){
        url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&source=$fromCity&destination=$toCity&loggedUserId=${user.content!.first.id}';
      }else if(fromCity != "All" && toCity=="All"){
        url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&source=$fromCity&loggedUserId=${user.content!.first.id}';
           }else{
        url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&destination=$toCity&loggedUserId=${user.content!.first.id}';
      }


   //   url = ApiConstant.FULL_LOAD_ALL_CARD +'?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&source=$fromCity&destination=$toCity';
    }
    print('the url $url');

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

  likeIncreamentApi(int postId, BuildContext context)async{

    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    EasyLoading.show(status: "Loading");
    String url=ApiConstant.BASE_URL+"GeneralPost/incrementLike?postId=${postId}";

    print('the url $url');

    var req = await http.post(Uri.parse(url));
   if(req.statusCode == 200) {
     var response = json.decode(req.body);
      if(response['success']==true){
        //


      }else{
        print(response['message']);
      }
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
    user=await LocalSharePreferences.localSharePreferences.getLoginData();
   if(user.content!.first.companyLogo!=null){
     imageUrl=user.content!.first.companyLogo!;
   }
   ispaid=user.content!.first.isPaid!;

    //callToken();
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


  deletePost(int index,int id,BuildContext context)async{
    String myUrl = ApiConstant.BASE_URL+'fullTruckLoad?id=${id}';

    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    if(apiResponse.status==200){
      truckLoadTypeList .removeAt(index);
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  selectCityFromFilter(BuildContext context)async{
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9, child: SelectOneCityScreen());
        });
    fromCity=routeRequest.startLocation;
    selectedPage=0;
    truckLoadTypeList.clear();
    notifyListeners();
    callDashboradApi(context,0);

  }

  selectToCityFilter(BuildContext context)async{
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9, child: SelectOneCityScreen());
        });
    toCity=routeRequest.startLocation;
    selectedPage=0;
    truckLoadTypeList.clear();
    notifyListeners();
    callDashboradApi(context,0);

  }

  callToken()async {
   // user=await LocalSharePreferences.localSharePreferences.getLoginData();
     String? token=await FirebaseMessaging.instance.getToken();
    ApiResponse result=await ApiHelper().apiPost(ApiConstant.UPDATE_DEVICE_ID+"?userId=${user.content!.first.id}"+"&deviceId=${token}");
    if(result.status==200){
      return "Success";
    }
    return "Fail";

  }




}