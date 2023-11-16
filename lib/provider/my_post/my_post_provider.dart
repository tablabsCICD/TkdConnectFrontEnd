import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/provider/base_provider.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
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
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.MYPOSTBID(user.content!.first.userName,selectedPage));
    if(apiResponse.status==200){
      MyPostBids bidPlaced=MyPostBids.fromJson(apiResponse.response);
      listOwnBid.addAll(bidPlaced.content!);
      selectedPage++;
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
    String myUrl = ApiConstant.BASE_URL+'fullTruckLoad?id=${listOwnBid[index].genericCardsDto!.id!}';

    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    if(apiResponse.status==200){
      listOwnBid.removeAt(index);
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }




}