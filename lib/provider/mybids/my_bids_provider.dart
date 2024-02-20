import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/bid_placed.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';

class MyBidsProvider extends BaseProvider{
  bool isMyPlacedBids=true;
  List<Bids>listBids=[];
  MyBidsProvider(super.appState);
  bool isLoad=false;
  bool isLoadMyPlacedBid=false;
  List<PostBidData>listOwnBid=[];
  ScrollController scrollController = ScrollController();
  int selectedPage=0;
  int selectedPageAllBids=0;
  String selectedString="All Bids";

  bool fla = false,pla = false,flr = false,plr = false;


  getAllBids(BuildContext context,bool tabChang)async{
    if(isLoad && tabChang){
    }else{
      User user=await LocalSharePreferences().getLoginData();
      //print('the link is ${ApiConstant.MY_BIDS_PLACED(user.content![0].userName,selectedPageAllBids)+"&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}"}');

      ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.MY_BIDS_PLACED(user.content![0].userName,selectedPageAllBids)+"&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}");
     // print('the response is ${apiResponse.response}');
      if(apiResponse.status==200){
        BidPlaced bidPlaced=BidPlaced.fromJson(apiResponse.response);
        listBids.clear();
        listBids.addAll(bidPlaced.content!);
       // print('the size is ${listBids.length}');
        selectedPageAllBids++;
        isLoad=true;
        notifyListeners();
      }else{
        ToastMessage.show(context, "Please Try Again");
      }
    }
    notifyListeners();
  }

  getReceviedBids(BuildContext context,bool tabChange)async{
    if(isLoadMyPlacedBid && tabChange){
      notifyListeners();
    }else{
      User user=await LocalSharePreferences().getLoginData();
      ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.MYPOSTBID(user.content![0].userName,selectedPage)+"&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}");
       if(apiResponse.status==200){
        MyPostBids bidPlaced=MyPostBids.fromJson(apiResponse.response);
        if(selectedPage==0){
          listOwnBid.clear();
        }
        listOwnBid.addAll(bidPlaced.content!);
        notifyListeners();
        selectedPage++;
        isLoadMyPlacedBid=true;
      }else{
        ToastMessage.show(context, "Please Try Again");
      }
    }

  }




  changeTab(){
    if(isMyPlacedBids){
      isMyPlacedBids=false;
    }else{
      isMyPlacedBids=true;
    }
    notifyListeners();
  }

  deleteBid(int index,Bids bidings,BuildContext context)async{
    // listOwnBid[index].bidings!.remove(bidings);
    // notifyListeners();
    ApiResponse apiResponse=await ApiHelper().ApiDeleteData(ApiConstant.PLACED_BID+"?id=${bidings.bidingId}");
    if(apiResponse.status==200){
      listBids.removeAt(index);
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }


  }
  pagenation(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getReceviedBids(context,false);

      }
    });
  }

  pagenationPlacedBid(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAllBids(context,false);

      }
    });
  }

  changeDropDown(String tab,BuildContext context){
    selectedString=tab;
    if(tab.contains("All bids")){
      fla = false;pla = false;flr = false;plr = false;
    }

    if(tab.contains("Full load available")){
      fla = true;pla = false;flr = false;plr = false;
    }

    if(tab.contains("Part load available")){
      fla = false;pla = true;flr = false;plr = false;
    }
    if(tab.contains("Full load Required")){
      fla = false;pla = false;flr = true;plr = false;
    }

    if(tab.contains("Part load Required")){
      fla = false;pla = false;flr = false;plr = true;
    }
    if(isLoadMyPlacedBid){

        selectedPage=0;
        notifyListeners();
      getReceviedBids(context,false);
      notifyListeners();

    }else{

      selectedPageAllBids=0;
      notifyListeners();
      getAllBids(context, false);
      notifyListeners();

    }

  }

}