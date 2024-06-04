import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/screen/deeplink/place_bid_deeplink.dart';
import 'package:tkd_connect/screen/deeplink/show_bidds.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import '../../model/response/deep_link_load.dart';
import '../dashboard/home/place_bid_screen.dart';

class DeepLink extends StatefulWidget{
 final String id;

  const DeepLink({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _DeppLink();
  }




}
class _DeppLink extends State<DeepLink>{
  @override
  void initState() {
    callApiPost();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),

  );
  }


  callApiPost()async{
    User user=await LocalSharePreferences().getLoginData();
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet("${ApiConstant.BASE_URL}fullTruckLoad/${widget.id}");
    print('${apiResponse.status}');
    if(apiResponse.status==200){
      TruckDeep truckLoadType =TruckDeep.fromJson(apiResponse.response);
      TruckLoadDeepLink load=truckLoadType.content!.first;
      if(load.contactNumber==user.content!.first.mobileNumber){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ShowAllBids( id: widget.id,)));

      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>PlaceDeepBidScreen( truckLoad: load,)));

      }


    }else{
       ToastMessage.show(context, "Error to find the load");
       Navigator.pushNamed(context, AppRoutes.home);

    }
  }

}