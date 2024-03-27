import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';

class BuySellScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BuySellScreen();
  }

}
class _BuySellScreen extends State<BuySellScreen>{
  bool isTabBuy=false;
  int selectedPage=0;
  ScrollController scrollController=ScrollController();
  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callBuyApi();
    callData();
    pagination();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Column(
          children: [
            BaseWidget().appBar(context, S().buySell),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: tabBuySell(),
            ),
            SizedBox(height: 12.h,),
            listView(),


          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: ()async{

          Navigator.pushNamed(context, AppRoutes.createbuysell);
        },
        child: Container(
          width: 155.w,
          height: 38.h,
          padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: ShapeDecoration(
            color: ThemeColor.theme_blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Post',
                style: TextStyle(
                  color: ThemeColor.progress_color,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                width: 16.w,
                height: 16.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.w,
                      child: Stack(children: [
                        SvgPicture.asset(Images.add,height: 16.h,width: 16.w,)

                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  iteamBuy(TruckLoad truckLoad,int index){
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
              color: Color(0x114A5568),
              blurRadius: 8.r,
              offset: Offset(0, 3),
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
                color: Color(0xFF2C8FEA),
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
          BaseWidget().profileWithUser("", truckLoad.nameOfPerson!, truckLoad.companyName!,
              verify: truckLoad.isverified!,
              transporterOrAgent: truckLoad.transporterOrAgent!),
          SizedBox(
            height: 12.h,
          ),
          BaseWidget().heading(truckLoad.topicName!, truckLoad.postingTime!.split(" ")[0],truckLoad.content!),
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
                  buyListIteam(truckLoad.modelName!,false),
                  buyListIteam(truckLoad.makerName!,false),
                  buyListIteam(truckLoad.estPrice!,false),
                ],

              ),



            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          BaseWidget().buyDeleteButton(((val){
            if(val==10){
              _showMyDialog(truckLoad.id!,index);
            }else{
              Utils().openMenu(val, truckLoad, context);
            }
          }),_user.content!.first.id==truckLoad.userId),
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


  tabBuySell() {
    return Container(
      width: 335.w,
      height: 32.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0x332C363F),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x332C363F)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if(isTabBuy){
                  isTabBuy=false;
                  selectedPage=0;
                  setState(() {

                  });
                  callBuyApi();

                }else{

                }
              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                decoration:
                !isTabBuy?ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ):
                ShapeDecoration(
                  color: Color(0x19001E49),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().sell,
                      style: !isTabBuy? TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ):TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if(isTabBuy){

                }else{
                  isTabBuy=true;
                  selectedPage=0;
                  setState(() {

                  });

                  callBuyApi();
                }

              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                decoration: isTabBuy?ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ): ShapeDecoration(
                  color: Color(0x19001E49),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().buy,
                      style: isTabBuy?TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ):TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  listView() {
    return Container(
      child: Expanded(
        child:  RefreshIndicator(
        onRefresh: _pullRefresh,
          child: ListView.builder(
              itemCount: buyVehicleList.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) {
                return Padding(padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 10.h),child: iteamBuy(buyVehicleList[index],index),);
              }),
        ),
      ),
    );
  }

  Future<void> _pullRefresh()async{
    selectedPage=0;
    await callBuyApi();
  }


  List<TruckLoad> buyVehicleList = [];
  callBuyApi()async{

    ApiResponse response=await ApiHelper().apiWithoutDecodeGet(ApiConstant.BUY_SELL_ALL_CARD(isTabBuy?"Buy":"Sell", selectedPage));
    if(response.status==200){

      var type = TruckLoadType.fromJson(response.response);
      if(         selectedPage==0){
        buyVehicleList.clear();
      }
      buyVehicleList.addAll(type.content);
      selectedPage++;
      setState(() {

      });
    }else{
      ToastMessage.show(context, "Please try again");
    }

  }

  pagination(){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        callBuyApi();

      }
    });
  }

  void callData() async{
    _user=await LocalSharePreferences().getLoginData();
  }

  void callDeleteApi(int id,int index)async {
    String myUrl = ApiConstant.POST_BUY_SELL+'?id=${id}';
    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    if(apiResponse.status==200){
      buyVehicleList .removeAt(index);
      setState(() {

      });
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  Future<void> _showMyDialog(int id,int index) async {
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
                callDeleteApi(id,index);
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

}