import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/own_buy_sell.dart';
import 'package:tkd_connect/network/api_helper.dart';

import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';

class MyBuySellPostScreen extends StatefulWidget {
  const MyBuySellPostScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyBuySellPost();
  }

}


class MyBuySellPost extends State<MyBuySellPostScreen> {

  @override
  void initState() {
    callApi();
    super.initState();
  }

  ScrollController scrollController =ScrollController();
  List<OwnBuySellData> listOwnPost=[];
  bool isLoad=true;

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }


  _buildPage(BuildContext context) {
    return !isLoad || listOwnPost.isEmpty?const Center(
      child:Text("No Post Found ") ,
    ):Column(
      children: [

        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: listOwnPost.length,
            itemBuilder: (context, i) {
              return Padding(padding: EdgeInsets.only(bottom: 12.h,left: 0.w,right: 0.w),child: iteamBuy(listOwnPost[i],i),);
            },
          ),
        )

      ],
    );
  }

  iteamBuy(OwnBuySellData truckLoad,int index){
    return Container(
      width: 335.w,

      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x114A5568),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(

        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: const Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  truckLoad.mainTag!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
           SizedBox(
            height: 12.h,
          ),
          BaseWidget().heading(truckLoad.topicName!, truckLoad.postingTime!.split(" ")[0],truckLoad.additionalInformation!),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buyListIteam("Vehicle Model ",true),
                  buyListIteam("Vehicle Brand",true),
                  buyListIteam("Price",true),
                ],

              ),
              SizedBox(width: 10.w,),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buyListIteam(truckLoad.model!,false),
                  buyListIteam(truckLoad.maker!,false),
                  buyListIteam(truckLoad.estimatedPrice!.toString(),false),
                ],

              ),



            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          BaseWidget().deleteMyPostButton(((val){
            if(val==10 || val== 1){
              _showMyDialog(index);
            }else if(val==5){
              callRePost(truckLoad.id!);
            }

            else{
              String description= "${truckLoad
                  .contactNumber
                  .toString()}'Type : ${truckLoad.type}, \nSubject : ${truckLoad.additionalInformation} , \nLink : https://api.tkdost.com/bids/?id=${truckLoad.id}'";
              Utils().callShareFunction(description);
            }
          })),
          SizedBox(
            height: 5.h,
          ),



        ],
      ),
    );
  }


  buyListIteam(String title ,bool istitle){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight:istitle? FontWeight.w600:FontWeight.w400,
          ),
        ),


      ],
    );

  }

  void callApi() async{
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    listOwnPost.clear();
    ApiResponse response=await ApiHelper().apiWithoutDecodeGet("${ApiConstant.BASE_URL}/getBuySellByUserId/${user.content!.first.id}");
    if(response.status==200){
      var type = OwnBuySelllPostList.fromJson(jsonDecode(response.response));
      listOwnPost.addAll(type.data!);
      isLoad=true;
      setState(() {

      });
    }else{
      isLoad=false;
      ToastMessage.show(context, "Please try again");
    }
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S().deleteMsg,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () {
                deletePost(index, context);

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(S().no,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  callRePost(int id )async{

    String myUrl = '${ApiConstant.POST_BUY_SELL}/repost?id=$id';
    ApiResponse apiResponse= await ApiHelper().apiPost(myUrl);
    if(apiResponse.status==200){
     callApi();
      setState(() {
      });
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }





  deletePost(int index,BuildContext context)async{
    String myUrl = '${ApiConstant.POST_BUY_SELL}?id=${listOwnPost[index].id}';
    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
      if(apiResponse.status==200){
      listOwnPost.removeAt(index);
      setState(() {
      });
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }
}




