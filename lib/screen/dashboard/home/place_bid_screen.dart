import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/request/bid_place.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/editText.dart';

import '../../../constant/images.dart';
import '../../../generated/l10n.dart';
import '../../../model/response/bid_state_response.dart';
import '../../../model/response/post_upload.dart';
import '../../../model/response/userdata.dart';
import '../../../route/app_routes.dart';
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
  TextEditingController reasonController=TextEditingController();
  bool buttonEnable=false;
  String bidState="";
  String avgBid="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callAvrageBid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
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
                widget.truckLoad.topicName!,
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
                  color: const Color(0x99001E49),
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(height: 10.h,),
              avgBid=="0"?const SizedBox.shrink():Text(
                "Average Bid is $avgBid",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
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
              SizedBox(height:49.w,child: EditText(width: 300.w,height: 42.w, hint: "\u{20B9}", controller: controller,keybordType: TextInputType.number,
                onChange: (val){
                if(val==0){
                  buttonEnable=false;
                }else{
                  buttonEnable=true;
                  callApiBidState();
                }

                callSetState();


              },)),
              SizedBox(height: 16.h,),
              Text(
                S().quoteReason,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),

              ),
              SizedBox(height: 8.h,),
              SizedBox(height:49.w,child: EditText(width: 300.w,height: 42.w, hint: "Quote reason", controller: reasonController,keybordType: TextInputType.text,
                onChange: (val){
                 /* if(val==0){
                    buttonEnable=false;
                  }else{
                    buttonEnable=true;
                  }

                  callSetState();*/


                },)),
              const SizedBox(height: 8,),
              Text(
                bidState,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),

              ),

            ],
          ),
        ),
        
      ),
      bottomNavigationBar: Padding(padding: const EdgeInsets.all(20),child: Button(width: 327.w, height: 49.h, title: S().submit, textStyle: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: AppConstant.FONTFAMILY,
        fontWeight: FontWeight.w600,
        height: 0,
      ), onClick: (){

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quote',style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),),
              content: Text('Are you sure you want to quote this post?',style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
              ),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,),),
                ),
                TextButton(
                  onPressed: () {
                   callYes();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.green, fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,),
                  ),
                ),
              ],
            );
          },
        );
      //  callApi(controller.text.toString());

      },isEnbale: buttonEnable,),),
    );
  }


  callApi(String amount, String reason)async{
    User user=await LocalSharePreferences().getLoginData();
    BidPlace bidPlace=BidPlace();
    bidPlace.amount=amount;
    bidPlace.idOfPost=widget.truckLoad.id;
    bidPlace.id=0;
    bidPlace.mobileNumber=user.content!.first.mobileNumber;
    bidPlace.userName=user.content!.first.userName;
    bidPlace.bidderUserName=user.content!.first.userName;
    bidPlace.emailId=user.content!.first.emailId;
    bidPlace.description=reason;
    bidPlace.loggedUserName=user.content!.first.userName;
    bidPlace.type=widget.truckLoad.type;
    
    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.PLACED_BID, bidPlace.toJson());
    if(apiResponse.status==200){
        PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
        if(postUpload.statusCode==401){
          ToastMessage.show(context, "Please update your package");
          Navigator.pushNamed(context, AppRoutes.registration_plan_details);
        }else{
          ToastMessage.show(context, "Quote submitted successfully");
          Navigator.pop(context);
        }

    }else{
      ToastMessage.show(context, "Please try again");
    }
 }

  callSetState(){
    setState(() {

    });
  }
  
  callApiBidState()async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.GET_BID_STATE(widget.truckLoad.id,controller.text.toString()));
   // print('apires${apiResponse.response}');
    if(apiResponse.status==200){
      BidState bidStateObj=BidState.fromJson(jsonDecode(apiResponse.response));
      if(bidStateObj.data=="0"){

      }else{
        bidState="Your Bid Range is in ${bidStateObj.data} position";
      }
     setState(() {
      });
    }else{
    }
    
  }

  void callYes() {
    Navigator.pop(context);
    callApi(controller.text.toString(),reasonController.text);

  }

  callAvrageBid() async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.AVG_BID(widget.truckLoad.id));
    //print('apires${apiResponse.response}');
    if(apiResponse.status==200){
      BidState bidStateObj=BidState.fromJson(jsonDecode(apiResponse.response));
      if(bidStateObj.data=="0"){
        avgBid = "0";
      }else{
        avgBid = bidStateObj.data.toString();
      }
      setState(() {
      });
    }else{
    }
  }
  
  


}