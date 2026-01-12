import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/main.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/acceptBidResponse.dart';
import 'package:tkd_connect/model/response/bid_placed.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/provider/location/location_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/app_constant.dart';
import '../../model/response/delete_user.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/quoteResponse.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/validation.dart';

class MyBidsProvider extends BaseProvider {
  bool isMyPlacedBids = false;
  bool isMobileNumberValid=false;
  List<Bids> listBids = [];

  MyBidsProvider(super.appState);

  bool isLoad = false;
  bool isLoadMyPlacedBid = false;
  List<PostBidData> listOwnBid = [];
  ScrollController scrollController = ScrollController();
  int selectedPage = 0;
  int selectedPageAllBids = 0;
  String selectedString = "All Bids";

  bool fla = false, pla = false, flr = false, plr = false;

  getAllBids(BuildContext context, bool tabChang) async {
    if (isLoad && tabChang) {
    } else {
      User user = await LocalSharePreferences().getLoginData();

      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(
          "${ApiConstant.MY_BIDS_PLACED(user.content![0].id, selectedPageAllBids)}&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr");
      print(
          'the response is ${ApiConstant.MY_BIDS_PLACED(user.content![0].id, selectedPageAllBids)}&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr}');
      if (apiResponse.status == 200) {
        BidPlaced bidPlaced = BidPlaced.fromJson(apiResponse.response);

        if (selectedPageAllBids == 0) {
          listBids.clear();
        }
        listBids.addAll(bidPlaced.content!);
        // print('the size is ${listBids.length}');
        selectedPageAllBids++;
        isLoad = true;
        notifyListeners();
      } else {
        ToastMessage.show(context, "Please Try Again");
      }
    }
    notifyListeners();
  }

  getReceviedBids(BuildContext context, bool tabChange) async {
    if (isLoadMyPlacedBid && tabChange) {
      notifyListeners();
    } else {
      User user = await LocalSharePreferences().getLoginData();
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(
          "${ApiConstant.MYPOSTBID(user.content![0].id, selectedPage)}&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr");
     print(apiResponse.response);
      if (apiResponse.status == 200) {
        MyPostBids bidPlaced = MyPostBids.fromJson(apiResponse.response);
        if (selectedPage == 0) {
          listOwnBid.clear();
        }
        listOwnBid.addAll(bidPlaced.content!);
        notifyListeners();
        selectedPage++;
        isLoadMyPlacedBid = true;
      } else {
        ToastMessage.show(context, "Please Try Again");
      }
    }
  }

  acceptBidSaveForm(BuildContext context, PostBidData data, Bidings bidings,
      String driverNumber, String vehicleNumber) async {
    User user = await LocalSharePreferences().getLoginData();
    Map<String, dynamic> mapData = {
      "amount": bidings.bidings!.amount,
      "bidId": bidings.bidings!.id,
      "bidderUserId": 0,
      "bidderUserName": bidings.bidings!.bidderUserName,
      "destinationLocation": data.genericCardsDto!.destination,
      "driverContact": driverNumber,
      "id": 0,
      "isUpdatedDriverDetails": 0,
      "loggedTime": "",
      "postId": data.genericCardsDto!.id,
      "sourceLocation":data.genericCardsDto!.source ,
      "userId": user.content![0].id,
      "vehicleNumber": vehicleNumber
    };
    print(ApiConstant.ACCEPTBID);
    ApiResponse apiResponse = await ApiHelper().postParameterDecode(ApiConstant.ACCEPTBID,mapData);
    if (apiResponse.status == 200) {
      AcceptBidResponse acceptBidResponse = AcceptBidResponse.fromJson(apiResponse.response);

      if(acceptBidResponse.success == true){
        ToastMessage.show(context, acceptBidResponse.message.toString());
        isLoadMyPlacedBid = false;
        selectedPage = 0;

        await getReceviedBids(context, false);
        notifyListeners();

       // Navigator.of(context).pop();
      }else{
        ToastMessage.show(context, acceptBidResponse.message.toString());
      }
      notifyListeners();
      getReceviedBids(context, false);
      Navigator.of(context).pop();
    } else {
      ToastMessage.show(context, "Please Try Again");
    }
  }

  updateAcceptBid(BuildContext context, Bids data,
      String driverNumber, String vehicleNumber) async {
    User user = await LocalSharePreferences().getLoginData();
    Map<String, dynamic> mapData = {
      "driverContact": driverNumber,
      "id": data.acceptBidId,
      "userId": user.content![0].id,
      "vehicleNumber": vehicleNumber
    };
    print(ApiConstant.UPDATE_ACCEPTED_BID);
    print(mapData);
    ApiResponse apiResponse = await ApiHelper().apiPut(ApiConstant.UPDATE_ACCEPTED_BID,mapData);
    print(apiResponse.response);
    if (apiResponse.status == 200) {
      AcceptBidResponse acceptBidResponse = AcceptBidResponse.fromJson(apiResponse.response);

      if(acceptBidResponse.success == true){
        ToastMessage.show(context, "Detail Sent successfully");
        // ✅ Reset & refresh Placed Bids
        isLoad = false;
        selectedPageAllBids = 0;

        await getAllBids(context, false);
        notifyListeners();

      //  Navigator.of(context).pop();
      }else{
        ToastMessage.show(context, "Something went wrong");
      }
      notifyListeners();
      Navigator.of(context).pop();
    } else {
      ToastMessage.show(context, "Please Try Again");
    }
  }

  changeTab() {
    if (isMyPlacedBids) {
      isMyPlacedBids = false;
    } else {
      isMyPlacedBids = true;
    }
    notifyListeners();
  }

  deleteBid(int index, Bids bidings, BuildContext context) async {
    // listOwnBid[index].bidings!.remove(bidings);
    // notifyListeners();
    ApiResponse apiResponse = await ApiHelper()
        .ApiDeleteData("${ApiConstant.PLACED_BID}?id=${bidings.bidingId}");
    if (apiResponse.status == 200) {
      listBids.removeAt(index);
      ToastMessage.show(context, "Bid withdraw successful ");
      isLoadMyPlacedBid = false;
      selectedPage = 0;

      await getReceviedBids(context, false);
      notifyListeners();

      Navigator.of(context).pop();
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

   Map<String, dynamic>? data = {};





  getGraphDataForBids(BuildContext context, int postId,int index) async {
    try {
      debugPrint('Fetching bid data from ${ApiConstant.GET_BID_TREND(postId)}');
      ApiResponse apiResponse = await ApiHelper()
          .apiWithoutDecodeGet(ApiConstant.GET_BID_TREND(postId));

      if (apiResponse.status == 200) {
        debugPrint('${apiResponse.status}');
        data = jsonDecode(apiResponse.response) as Map<String, dynamic>;
        print("Response data $data");
        if(data != null) {
          listOwnBid[index].genericCardsDto!.graphList = [];

          QuoteResponse response = QuoteResponse.fromJson(data!);
          if(response.data != null){
          listOwnBid[index].genericCardsDto!.graphList = response.data;
         }
          else{
            ToastMessage.show(context,response.message!);
          }
        }


        notifyListeners();
      } else {
        ToastMessage.show(context, "Please Try Again");
        // Default data in case of failure
      }
    } catch (e) {
      debugPrint("Error fetching bid data: $e");
      ToastMessage.show(context, "An error occurred. Please try again.");
    }
  }

  pagenation(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getReceviedBids(context, false);
      }
    });
  }

  pagenationPlacedBid(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAllBids(context, false);
      }
    });
  }

  changeDropDown(String tab, BuildContext context) {
    selectedString = tab;
    //print('the selcted tab $selectedString');
    if (tab.contains("All bids")) {
      fla = false;
      pla = false;
      flr = false;
      plr = false;
    }

    if (tab.contains("Full load required")) {
      fla = false;
      pla = false;
      flr = true;
      plr = false;
    }

    if (tab.contains("Part load required")) {
      fla = false;
      pla = false;
      flr = false;
      plr = true;
    }
    if (tab.contains("Full vehicle required")) {
      fla = true;
      pla = false;
      flr = false;
      plr = false;
    }

    if (tab.contains("Part vehicle required")) {
      fla = false;
      pla = true;
      flr = false;
      plr = false;
    }
    // print('the fa $fla $pla $flr $plr');
    if (isLoadMyPlacedBid) {
      selectedPage = 0;
      notifyListeners();
      getReceviedBids(context, false);
      notifyListeners();
    } else {
      selectedPageAllBids = 0;
      notifyListeners();
      getAllBids(context, false);
      notifyListeners();
    }
  }

  Future<bool> callOtp(BuildContext context, String mobileNumber,int postId, bool isPostOwner) async {
    try {
      var req = await ApiHelper().apiPost(ApiConstant.SEND_TRACKING_OTP(isPostOwner,postId));

      // ✅ Prevent calling Toasts on disposed context
      if (!context.mounted) return false;

      if (req.status == 200) {
        ToastMessage.show(context, "OTP Sent Successfully");
        return true;
      } else {
        ToastMessage.show(context, "Failed to send OTP");
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(context, "Error: $e");
      }
      return false;
    }
  }

  Future<bool> callSwitch(DeleteUser user, BuildContext context, String mobileNumber,int postId, bool isPostOwner) async {
    try {
      switch (user.errorCode) {
        case '200':
          return await callOtp(context, mobileNumber,postId,isPostOwner);

        case '201':
          if (context.mounted) {
            ToastMessage.show(context, "User is deleted, please register again");
          }
          return false;

        case '500':
          if (context.mounted) {
            ToastMessage.show(context, "Mobile number is not registered, please register");
          }
          return false;

        default:
          if (context.mounted) {
            ToastMessage.show(context, "Unexpected response");
          }
          return false;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(context, "Error: $e");
      }
      return false;
    }
  }

  Future<bool> isUserDeleted(String mobileNumber, BuildContext context,int postId,bool isPostOwner) async {
    if (!Validation().isValidPhoneNumber(mobileNumber)) {
      if (context.mounted) {
        ToastMessage.show(context, "Enter valid mobile number");
      }
      return false;
    }

    try {
      ApiHelper apiHelper = ApiHelper();
      var response = await apiHelper.apiGet(ApiConstant.USER_FIND_BY_MOBILE(mobileNumber));

      // ✅ Check again after API call
      if (!context.mounted) return false;

      if (response.status == 200) {
        DeleteUser deleteUser = DeleteUser.fromJson(response.response);
        bool returnVal = await callSwitch(deleteUser, context, mobileNumber,postId,isPostOwner);
        return returnVal;
      } else {
        if (context.mounted) {
          ToastMessage.show(context, "Please try again");
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(context, "Error: $e");
      }
      return false;
    }
  }

  isMobileValide(String mobile){
    isMobileNumberValid= Validation().isValidPhoneNumber(mobile);
    notifyListeners();
  }


  verifyOtp(BuildContext context,String mobileNumber,String otp) async{
    String  deviceId="null";
    try{
    try {
      deviceId = (await FirebaseMessaging.instance.getToken())!;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    print('the device id is $deviceId');

    String myUrl = ApiConstant.OTP_VERIFICATION(mobileNumber,otp,deviceId);
    var req = await ApiHelper().apiPost(myUrl);
    if (req.status == 200) {
      ToastMessage.show(context, "OTP Verified");
      return true;
    } else {
      ToastMessage.show(context, "Incorrect OTP");
      return false;
    }
  } catch (e) {
  ToastMessage.show(context, "Error: $e");
  return false;
  }
  }
}
