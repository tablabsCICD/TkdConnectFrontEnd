import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/request/post_load.dart';
import 'package:tkd_connect/model/response/oneadd.dart';
import 'package:tkd_connect/provider/base_provider.dart';

import '../../model/api_response.dart';
import '../../model/request/route_request.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/post_upload.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../route/app_routes.dart';
import '../../screen/my_route/select_city.dart';
import '../../screen/my_route/select_one_city.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import '../../widgets/card/dashboard_cards.dart';
class HomeScreenProvider extends BaseProvider{


  String fromCity="All";
  String toCity="All";
  bool isLoading = false;
  var response;
  bool isFirstLoading = false;
  int totalPages = 0;
  bool fla = false,pla = false,flr = false,plr = false,gp=false,buy_sell=false,jobs=false;
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
     // print('the clear the api');
      notifyListeners();
    }
    if(fromCity=="All" && toCity=="All"){

      // bool  bool fla = false,pla = false,flr = false,plr = false,gp=false,buy_sell=false,jobs=false; = false,pla = false,flr = false,plr = false,gp=false,buy_sell=false,jobs=false;
      if(!fla && !pla && !flr & !plr &!gp & ! buy_sell  &!jobs){
      //  url = ApiConstant.ALL_CARD +'?page=${currentPage}&size=10';//&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
        url = ApiConstant.ALL_CARD(user.content!.first.id,currentPage);//&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';

      }else{
        if(fla){
          url=ApiConstant.FULL_LOAD_AVILABLE(user.content!.first.id,currentPage);
        }else if(pla){
          url=ApiConstant.PART_LOAD_AVILABLE(user.content!.first.id,currentPage);
        }else if(flr){
          url=ApiConstant.FULL_LOAD_REQUIRED(user.content!.first.id,currentPage);
        }else if(plr){
          url=ApiConstant.PART_LOAD_REQUIRED(user.content!.first.id,currentPage);
        }else if(gp){
          url=ApiConstant.General_POST_HOMEPAGE(user.content!.first.id,currentPage);
        }else if(buy_sell){
          url=ApiConstant.BUYSELL_HOMEPAGE(user.content!.first.id,currentPage);
        }else if(jobs){
          url=ApiConstant.JOBS_HOMEPAGE(user.content!.first.id,currentPage);
        }else{
          url = '${ApiConstant.FULL_LOAD_ALL_CARD}?page=$currentPage&size=50&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
        }
      }

    }else{
   if(fromCity != "All" && toCity!="All"){
        url = '${ApiConstant.HOMEPAGE_FILTER}?page=$currentPage&size=10&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr&source=$fromCity&destination=$toCity&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
      }else if(fromCity != "All" && toCity=="All"){
        url = '${ApiConstant.HOMEPAGE_FILTER}?page=$currentPage&size=10&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr&source=$fromCity&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
           }else{
        url = '${ApiConstant.HOMEPAGE_FILTER}?page=$currentPage&size=10&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr&destination=$toCity&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
      }

    }
   // print('the url $url');
    var req = await http.get(Uri.parse(url));
    isFirstLoading= false;
    isLoading = false;
    if(req.statusCode == 200) {
      response = json.decode(req.body);
      //print('the response is ${response}');
      var type = TruckLoadType.fromJson(response);

      totalPages = type.totalPages;
      truckLoadTypeList.addAll(type.content);

      EasyLoading.dismiss();
      callAddDiloag(context);
      notifyListeners();

    }

  }

  getUserListFromString(String userList){
    List<String> addedUserListInPost = userList.split(',').map((e) => e.trim()).toList();

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
    //print('the is paid is ${user.content!.first.isPaid}');
    if(user.content!.first.companyLogo!=null){
     imageUrl=user.content!.first.companyLogo!;
   }
   ispaid=user.content!.first.isPaid!;

   AppConstant.USERTYPE=user.content!.first.transporterOrAgent!;
    //print('${AppConstant.USERTYPE} the my usertype ${user.content!.first.transporterOrAgent!}');

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
    fla = false;pla = false;flr = false;plr = false;gp=false;jobs=false;buy_sell=false;
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




  deletePost(int index,int id,BuildContext context)async{
    String myUrl = '${ApiConstant.BASE_URL}fullTruckLoad?id=$id';

    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    if(apiResponse.status==200){
      truckLoadTypeList .removeAt(index);
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  completePost(int id,BuildContext context)async{
    String myUrl = '${ApiConstant.COMPLETE_POST}$id';

    ApiResponse apiResponse= await ApiHelper().apiPutDat(myUrl);
    if(apiResponse.status==200){
     // truckLoadTypeList .removeAt(index);
      ToastMessage.show(context, "Your Post Completed Successfully");
      callDashboradApi(context,0);

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
          return const FractionallySizedBox(
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
          return const FractionallySizedBox(
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
    ApiResponse result=await ApiHelper().apiPost("${ApiConstant.UPDATE_DEVICE_ID}?userId=${user.content!.first.id}&deviceId=$token");
    if(result.status==200){
      return "Success";
    }
    return "Fail";

  }


  reSendPost(BuildContext context,TruckLoad load)async {
    ApiResponse apiResponse=await ApiHelper().apiPost("${ApiConstant.BASE_URL}repost?id=${load.id}&interchange=${false}");
    if(apiResponse.status==200){
      PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      }else{
        callDashboradApi(context,0);
      }
    }else{
      ToastMessage.show(context, "Please try again");
    }

  }

  interChnageSendPost(BuildContext context,TruckLoad load) async{
    ApiResponse apiResponse=await ApiHelper().apiPost("${ApiConstant.BASE_URL}repost?id=${load.id}&interchange=${true}");
    if(apiResponse.status==200){
      PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      }else{
        callDashboradApi(context,0);
      }



    }else{
      ToastMessage.show(context, "Please try again");
    }
  }



  createPost(BuildContext context,TruckLoad load, List<int> userIdList,bool isInterchange)async{

    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad=PostLoad();
    postLoad.contactNumber= user.content!.first.mobileNumber! ;

    postLoad.dnd =load.dnd;
    postLoad.emailId=user.content!.first.emailId!;
    postLoad.fullLoadChoice= load.mainTag =="Full load required"?"I Have Vehicle":"I Want Vehicle";

    postLoad.instructions= load.content;
    postLoad.loadWeight= load.loadWeight.toString();
    postLoad.loggedUserName= user.content!.first.userName;
    postLoad.mainTag= load.mainTag;
    postLoad.os= 'App';
    if(isInterchange){
      postLoad.source=load.destination;
      postLoad.destination=load.source;
    }else{
      postLoad.source=load.source;
      postLoad.destination=load.destination;
    }
    postLoad.otherDetails= load.content;


    postLoad.partLoad=  load.partLoadOrNot;
    postLoad.privatePost= load.privatePost;
    postLoad.rating= 5;
    postLoad.type= load.type;
   // print('the cargo type is ${load.typeOfCargo} ${load.loadWeight}');
    postLoad.typeOfCargo=load.typeOfCargo;
    postLoad.typeOfPayment=load.typeOfPayment;
    postLoad.vehicleSize= load.vehicleSize;
    postLoad.tableName=load.tableName;
    postLoad.topicName= load.tableName;
    postLoad.image= [];
    postLoad.partLoad=load.partLoadOrNot!;
    postLoad.listOfUserIds=userIdList;

 postLoad.id=0;
    ApiResponse response=await ApiHelper().postParameter("${ApiConstant.BASE_URL}fullTruckLoad", postLoad.toJson());
    if(response.status==200){
      ToastMessage.show(context, "Re-post submitted successfully!");
      callDashboradApi(context,0);

    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  callAddDiloag(BuildContext context)async{
    http.Response response=await http.get(Uri.parse("${ApiConstant.BASE_URL}my-ads/getOne"));
    if(response.statusCode==200){
    Advertisement advertisement=Advertisement.fromJson(jsonDecode(response.body));
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.of(context).pop(true);
            });
            return  AllCards().imageDialogOneAdd(
                advertisement.data!.companyName,  context, advertisement.data!.images!.first);
          });

    }

  }


}