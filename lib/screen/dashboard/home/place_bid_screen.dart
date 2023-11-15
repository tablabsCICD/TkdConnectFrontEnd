import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/request/bid_place.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/editText.dart';

import '../../../constant/images.dart';
import '../../../generated/l10n.dart';
import '../../../model/response/userdata.dart';
import '../../../widgets/textview.dart';
class PlaceBidScreen extends StatefulWidget{
  final TruckLoad truckLoad;

  const PlaceBidScreen({super.key, required this.truckLoad});
  @override
  State<StatefulWidget> createState() {
  return _PlaceBidScreen();
  }

}

class _PlaceBidScreen extends State<PlaceBidScreen> {

  TextEditingController controller=TextEditingController();
  bool buttonEnable=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            controller: null,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 36.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Textview(
                      title: S().quotesNow,
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(onTap:(){Navigator.pop(context);},child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 50.h,),
              Text(
                widget.truckLoad!.topicName!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(height: 8.h,),
              Text(
                widget.truckLoad.content!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0x99001E49),
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(height: 36.h,),
              Text(
                S().enterQuoteAmount,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),

              ),
              SizedBox(height: 8.h,),
              Container(height:49.w,child: EditText(width: 300.w,height: 42.w, hint: "\u{20B9}", controller: controller,keybordType: TextInputType.number,onChange: (val){
                if(val==0){
                  buttonEnable=false;
                }else{
                  buttonEnable=true;
                }
                callSetState();

              },)),
              SizedBox(height: 8,)

            ],
          ),
        ),
        
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(20),child: Button(width: 327.w, height: 49.h, title: S().submit, textStyle: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: AppConstant.FONTFAMILY,
        fontWeight: FontWeight.w600,
        height: 0,
      ), onClick: (){

        callApi(controller.text.toString());

      },isEnbale: buttonEnable,),),
    );
  }


  callApi(String amount)async{
    User user=await LocalSharePreferences().getLoginData();
    BidPlace bidPlace=BidPlace();
    bidPlace.amount=amount;
    bidPlace.idOfPost=widget.truckLoad.id;
    bidPlace.id=0;
    bidPlace.mobileNumber=user.content!.first.mobileNumber;
    bidPlace.userName=user.content!.first.userName;
    bidPlace.bidderUserName=user.content!.first.userName;;
    bidPlace.emailId=user.content!.first.emailId;
    bidPlace.description="No ANY";
    bidPlace.loggedUserName=user.content!.first.userName;
    bidPlace.type=widget.truckLoad.type;
    
    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.PLACED_BID, bidPlace.toJson());
    if(apiResponse.status==200){
      ToastMessage.show(context, "Quote submitted successfully");
      Navigator.pop(context);
    }else{
      ToastMessage.show(context, "Please try again");
    }
 }

  callSetState(){
    setState(() {

    });
  }
  
  


}