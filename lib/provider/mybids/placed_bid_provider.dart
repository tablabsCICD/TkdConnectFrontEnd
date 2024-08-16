import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/provider/base_provider.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/bid_placed.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';

class PlacedBidProvider extends BaseProvider {
  final bool fla ,pla ,flr ,plr ;
  PlacedBidProvider(BuildContext context, this.fla, this.pla, this.flr, this.plr):super(""){
    getAllBids(context,false);
  }

  bool isMyPlacedBids=true;
  List<Bids>listBids=[];

  bool isLoad=false;
  bool isLoadMyPlacedBid=false;
  List<PostBidData>listOwnBid=[];
  ScrollController scrollController = ScrollController();
  int selectedPage=0;
  int selectedPageAllBids=0;



  getAllBids(BuildContext context,bool tabChang)async{
    User user=await LocalSharePreferences().getLoginData();
    print('the flas is ${ApiConstant.MY_BIDS_PLACED(user.content![0].userName,selectedPageAllBids)}');

    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.MY_BIDS_PLACED(user.content![0].userName,selectedPageAllBids));
    //print('the response is ${apiResponse.response}');
    if(apiResponse.status==200){
      BidPlaced bidPlaced=BidPlaced.fromJson(apiResponse.response);
      listBids.clear();
      listBids.addAll(bidPlaced.content!);
      //print('the size is ${listBids.length}');
      selectedPageAllBids++;
      isLoad=true;
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Try Again");
    }
    notifyListeners();
  }



  pagenationPlacedBid(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAllBids(context,false);

      }
    });
  }

}