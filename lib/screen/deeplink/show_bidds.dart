import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/textview.dart';
import '../../widgets/verified_tag.dart';
import '../my_bids/show_bids_screen.dart';

class ShowAllBids extends StatefulWidget {
  final String id;

  const ShowAllBids({super.key, required this.id});
  @override
  State<StatefulWidget> createState() {
   return _ShowAllBids();
  }

}

class _ShowAllBids extends State<ShowAllBids>{
  bool isLoad=false;
 List<PostBidData> postBidData=[];
  
  @override
  void initState() {
    callApi();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar:AppBar(
       backgroundColor: Colors.white,
       leading:  InkWell(onTap: (){
         Navigator.pushReplacementNamed(context, AppRoutes.home);
       },child: SizedBox(height:10,width:10,child: SvgPicture.asset(Images.arrow_back,height: 10,width: 10,))),
       title: Center(
         child: Textview(
           title: "Bids",

           TextStyle(
             color: Colors.black,
             fontSize: 14.sp,
             fontFamily: GoogleFonts.poppins().fontFamily,
             fontWeight: FontWeight.w600,
           ),
         ),
       ),

     ),
     body: Container(
      // margin: EdgeInsets.all(10),
       color: ThemeColor.baground,
       child:!isLoad?const SizedBox(height: 10,width: 10,): ListView.builder(

         itemCount:postBidData.length,
         itemBuilder: (context, i) {
           return Padding(
             padding: EdgeInsets.only(bottom: 12.h, left: 20.w, right: 20.w,top:10.h),
             child: iteamMyPost(postBidData[i], i),);
         },
       ),

     ),
   );
  }


  iteamMyPost(PostBidData postBidData, int index) {
    return Container(
      width: 335.w,
      // height: 417.h,
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
                  Utils().mainTag(postBidData.genericCardsDto!.mainTag!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h,),
          BaseWidget().headingWithoutDate(
              postBidData.genericCardsDto!.topicName!,
              postBidData.genericCardsDto!.content!),
          SizedBox(height: 8.h,),
          BaseWidget().routes(postBidData.genericCardsDto!.source!,
              postBidData.genericCardsDto!.destination!),
          SizedBox(height: 8.h,),
          iteams(postBidData, index),
          SizedBox(height: 8.h,),
          BaseWidget().showBidButton((val) async{
            if (val == 0) {
              if (postBidData.bidings!.isNotEmpty) {
                showBootomSheet(context,postBidData.bidings);
              } else {
                ToastMessage.show(context, "There are no bids to show ");
              }
            }
            if(val==3){
              String description= "${postBidData.genericCardsDto!.mobileNumber.toString()}'Type : ${postBidData.genericCardsDto!.type}, \nSubject : ${postBidData.genericCardsDto!.content}, \nSource : ${postBidData.genericCardsDto!.source}, \nDestination : ${postBidData.genericCardsDto!.destination}, \nLink : https://api.tkdost.com/bids/?id=${postBidData.genericCardsDto!.id}'";
              await Utils().callShareFunction(description);
            }
          },true)


        ],
      ),
    );
  }


  iteams(PostBidData postBidData, int index) {
    if (postBidData.bidings!.isEmpty) {
      return Container();
    } else {


      if (postBidData.bidings!.length == 1) {
        return iteamBid(postBidData.bidings![0], true, index);
      } else if (postBidData.bidings!.length == 2) {
        List<Widget>list = [
          iteamBid(postBidData.bidings![0], false, index),
          iteamBid(postBidData.bidings![1], true, index)];
        return Column(
          children: list,
        );
      } else {
        List<Widget>list = [
          iteamBid(postBidData.bidings![0], false, index),
          iteamBid(postBidData.bidings![1], false, index),
          iteamBid(postBidData.bidings![2], true, index)];
        return Column(
          children: list,
        );
      }
    }
  }

  iteamBid(Bidings bidings, bool isLast, int index) {
    return Container(
      width: 311.w,
      //  height: 69.h,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isLast ? Colors.white : const Color(0x332C363F),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  BaseWidget().getImage(bidings.profileImage!=null?bidings.profileImage!:"", height: 28.h, width: 28.w)
                  ,
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${bidings.firstName!} ${bidings.lastName!}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Visibility(
                                  visible: bidings.isVerified!=0?true:false,
                                  child:   VerifiedTag().onVeriedTag(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              bidings.companyName!,
                              style: TextStyle(
                                color: const Color(0x99001E49),
                                fontSize: 10.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹ ${bidings.bidings!.amount!}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                    height: 0,

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 38.w,
            height: 38.h,
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.07999999821186066),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async{
                    // widget.provider.deleteBid(index, bidings);

                    User use=await LocalSharePreferences().getLoginData();
                    if(use.content!.first.isPaid==0){

                      Navigator.pushNamed(context, AppRoutes.registration_plan_details);

                    }else{
                      Utils().callFunction("${bidings.bidings!.mobileNumber}",);
                    }



                  }
                  , child: SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22.w,
                        height: 22.h,
                        child: Stack(children: [
                          SvgPicture.asset(Images.call_white,color: ThemeColor.theme_blue,height: 25.h,width: 25.w,)

                        ]),
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void callApi()async {
    ApiResponse apiResponse =await ApiHelper().apiWithoutDecodeGet("${ApiConstant.BASE_URL}getPostAndBidWithId?postId=${widget.id}");
    if(apiResponse.status==200){
      MyPostBids bidPlaced=MyPostBids.fromJson(apiResponse.response);
      postBidData=bidPlaced.content!;
      setState(() {
        isLoad=true;
      });
    }else{
      ToastMessage.show(context, "Please try again close");
    }
    
  }

  void showBootomSheet(BuildContext context,List<Bidings>? bidings) async{
    User use=await LocalSharePreferences().getLoginData();
    if(use.content!.first.isPaid==0){

      Navigator.pushNamed(context, AppRoutes.registration_plan_details);

    }else{
      showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(heightFactor:0.7,child:ShowBidsScreen(listBidings: bidings,));
          });
    }
  }


}