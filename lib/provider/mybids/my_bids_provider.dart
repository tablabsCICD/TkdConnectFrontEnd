import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/main.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/acceptBidResponse.dart';
import 'package:tkd_connect/model/response/bid_placed.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';

class MyBidsProvider extends BaseProvider {
  bool isMyPlacedBids = true;
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
          "${ApiConstant.MY_BIDS_PLACED(user.content![0].userName, selectedPageAllBids)}&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr");
      print(
          'the response is ${ApiConstant.MY_BIDS_PLACED(user.content![0].userName, selectedPageAllBids)}&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr}');
      if (apiResponse.status == 200) {
        BidPlaced bidPlaced = BidPlaced.fromJson(apiResponse.response);
        listBids.clear();
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
          "${ApiConstant.MYPOSTBID(user.content![0].userName, selectedPage)}&fullLoadAvailable=$fla&fullLoadRequired=$flr&partLoadAvailable=$pla&partLoadRequired=$plr");
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
    ApiResponse apiResponse = await ApiHelper().apiPut(ApiConstant.UPDATE_ACCEPTED_BID,mapData);
    if (apiResponse.status == 200) {
      AcceptBidResponse acceptBidResponse = AcceptBidResponse.fromJson(apiResponse.response);

      if(acceptBidResponse.success == true){
        ToastMessage.show(context, acceptBidResponse.message.toString());
      }else{
        ToastMessage.show(context, acceptBidResponse.message.toString());
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
      notifyListeners();
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  late Map<String, dynamic> data = {};

  getGraphDataForBids(BuildContext context, int postId,int index) async {
    try {
      debugPrint('Fetching bid data from ${ApiConstant.GET_BID_TREND(postId)}');
      ApiResponse apiResponse = await ApiHelper()
          .apiWithoutDecodeGet(ApiConstant.GET_BID_TREND(postId));

      if (apiResponse.status == 200) {
        debugPrint('${apiResponse.status}');
        listOwnBid[index].genericCardsDto!.graphList = {};
        data = jsonDecode(apiResponse.response) as Map<String, dynamic>;
        listOwnBid[index].genericCardsDto!.graphList = data;
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
}
