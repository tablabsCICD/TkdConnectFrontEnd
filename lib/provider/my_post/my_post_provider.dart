import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/provider/base_provider.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/request/post_load.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/post_upload.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../route/app_routes.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';

class MyPostProvider extends BaseProvider{
  MyPostProvider(BuildContext context):super(""){
    getReceviedBids(context);
    pagenation(context);
  }
  List<PostBidData>listOwnBid=[];
  ScrollController scrollController = ScrollController();
  int selectedPage=0;
  getReceviedBids(BuildContext context)async{

    User user=await LocalSharePreferences().getLoginData();
    print('the link is ${ApiConstant.MYPOSTBID(user.content!.first.userName,selectedPage)}');
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.MYPOSTBID(user.content!.first.userName,selectedPage));
    if(apiResponse.status==200){
      MyPostBids bidPlaced=MyPostBids.fromJson(apiResponse.response);
      listOwnBid.addAll(bidPlaced.content!);
      listOwnBid.reversed;
      selectedPage++;
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Try Again");
    }


  }


  Map<String, dynamic> data = {};
  getGraphDataForBids(BuildContext context,int postId)async{
    User user=await LocalSharePreferences().getLoginData();
    print('the link is ${ApiConstant.GET_BID_TREND(postId)}');
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.GET_BID_TREND(postId));
    if(apiResponse.status==200){
      data = apiResponse.response;
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Try Again");
    }
  }

  pagenation(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getReceviedBids(context);

      }
    });
  }

  deletePost(int index,BuildContext context)async{
    String myUrl = '${ApiConstant.BASE_URL}fullTruckLoad?id=${listOwnBid[index].genericCardsDto!.id!}';

    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    if(apiResponse.status==200){
      listOwnBid.removeAt(index);
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
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  // reSendPost(BuildContext context,PostBidData postBidData) async {
  //   addedMemberIdList = await getTruckLoadById(postBidData.genericCardsDto!.id!);
  //   createPost(context,postBidData);
  //
  // }


  reSendPost(BuildContext context,PostBidData postBidData)async {
    ApiResponse apiResponse=await ApiHelper().apiPost("${ApiConstant.BASE_URL}repost?id=${postBidData.genericCardsDto!.id!}&interchange=${false}");
    print('the response is ${apiResponse.response}');
    if(apiResponse.status==200){
      // ToastMessage.show(context, "Re-post submitted successfully!");
      // Navigator.pop(context,1);

      PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      }else{
        ToastMessage.show(context, "Re-post submitted successfully!");

        Navigator.pop(context, 1);
      }

    }else{
      ToastMessage.show(context, "Please try again");
    }

  }

  interChnageSendPost(BuildContext context,PostBidData postBidData) async{
    ApiResponse apiResponse=await ApiHelper().apiPost("${ApiConstant.BASE_URL}repost?id=${postBidData.genericCardsDto!.id!}&interchange=${true}");
    print('the response is ${apiResponse.response}');
    if(apiResponse.status==200){


      PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      }else{
        ToastMessage.show(context, "Intercity post submitted successfully!");
        Navigator.pop(context, 1);
      }

    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  List<int> addedMemberIdList = [];
  getTruckLoadById(int id) async {
    ApiHelper apiHelper = ApiHelper();
    String myUrl = ApiConstant.FULL_LOAD_BY_ID + id.toString();
    print(myUrl);
    var response = await apiHelper.apiWithoutDecodeGet(myUrl);
    print(response.response);
    var result = TruckLoadType.fromJson(response.response);
    TruckLoad truckLoad = result.content.first;
    addedMemberIdList = await getUserListFromString(truckLoad.userList!);
    return addedMemberIdList;
  }

  List<String> addedUserListIdInPost=[];
  getUserListFromString(String userList){
    addedUserListIdInPost = userList.split(',').map((e) => e.trim()).toList();
    print(addedUserListIdInPost);
    for (var element in addedUserListIdInPost)  {
      addedMemberIdList.add(int.parse(element));
      print(element);
    }
    return addedMemberIdList;
  }


  createPost(BuildContext context,PostBidData postBidData)async{

    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad=PostLoad();
    postLoad.contactNumber= user.content!.first.mobileNumber! ;
    postLoad.destination=postBidData.genericCardsDto!.destination;
    postLoad.dnd =postBidData.genericCardsDto!.dnd;
    postLoad.emailId=user.content!.first.emailId!;
    postLoad.fullLoadChoice= postBidData.genericCardsDto!.mainTag =="Full load required"?"I Have Vehicle":"I Want Vehicle";

    postLoad.instructions= postBidData.genericCardsDto!.content;
    postLoad.loadWeight= postBidData.genericCardsDto!.vehicleWeight.toString();
    postLoad.loggedUserName= user.content!.first.userName;
    postLoad.mainTag= postBidData.genericCardsDto!.mainTag;
    postLoad.os= 'App';
    postLoad.otherDetails= postBidData.genericCardsDto!.content;
    postLoad.source=postBidData.genericCardsDto!.source;
    postLoad.partLoad=  postBidData.genericCardsDto!.partLoadOrNot;
    postLoad.privatePost= postBidData.genericCardsDto!.privatePost;
    postLoad.rating= 5;
    postLoad.type= postBidData.genericCardsDto!.type;
    postLoad.typeOfCargo=postBidData.genericCardsDto!.cargoType;
    postLoad.typeOfPayment=postBidData.genericCardsDto!.typeOfPayment;
    postLoad.vehicleSize= postBidData.genericCardsDto!.vehicleSize;
    postLoad.tableName="Full Load";
    postLoad.topicName= "Full Load Truck";
    postLoad.image= [];
    postLoad.partLoad=postBidData.genericCardsDto!.partLoadOrNot!;
    postLoad.expireDate=postBidData.genericCardsDto!.expireDate;
    postLoad.listOfUserIds=addedMemberIdList;

    postLoad.id=0;
    ApiResponse response=await ApiHelper().postParameter("${ApiConstant.BASE_URL}fullTruckLoad", postLoad.toJson());
    print('the resopnse is ${json.encode(postLoad.toJson())}');
    print('the resopnse is ${response.status}');
    if(response.status==200){
      ToastMessage.show(context, "Re-post submitted successfully!");
      Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  // createVehiclePost(BuildContext context)async{
  //   User user=await LocalSharePreferences.localSharePreferences.getLoginData();
  //   PostLoad postLoad=PostLoad();
  //   postLoad.contactNumber= user.content!.first.mobileNumber! ;
  //   postLoad.destination= destinationCity;
  //   postLoad.dnd =dnd?0:1;
  //   postLoad.emailId=user.content!.first.emailId!;
  //   postLoad.fullLoadChoice="I Want Vehicle";
  //
  //   postLoad.instructions= specialInstructionController.text;
  //   postLoad.loadWeight= loadWeightController.text;
  //   postLoad.loggedUserName= user.content!.first.userName;
  //   postLoad.mainTag= selectedRequriment;
  //   postLoad.os= 'App';
  //   postLoad.otherDetails= specialInstructionController.text;
  //   postLoad.source=sourceCity;
  //   postLoad.partLoad=selectedRequriment == 'Part Load Vehicle' ? 1 : 0;
  //   postLoad.privatePost= 0;
  //   postLoad.rating= 5;
  //   //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
  //   postLoad.type=selectedRequriment;
  //   postLoad.typeOfCargo= selectedCargo;
  //   postLoad.typeOfPayment=selectedPayment;
  //   postLoad.vehicleSize= vehicleSizeController.text;
  //   postLoad.tableName="Full Load";
  //   postLoad.topicName= "Full Load Truck";
  //   postLoad.image=images;
  //   ApiResponse response=await ApiHelper().postParameter(ApiConstant.BASE_URL+"fullTruckLoad", postLoad.toJson());
  //   if(response.status==200){
  //     print('the response is ${response.response}');
  //     ToastMessage.show(context, "Post submitted successfully!");
  //     Navigator.pop(context,1);
  //   }else{
  //     ToastMessage.show(context, "Please try again");
  //   }
  // }






}