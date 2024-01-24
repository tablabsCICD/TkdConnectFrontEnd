import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/my_post/my_post_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../generated/l10n.dart';
import '../../model/response/my_post_bid_list.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../my_bids/show_bids_screen.dart';

class MyPostScreenTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPostStateTwo();
  }

}

class _MyPostStateTwo extends State<MyPostScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyPostProvider(context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Column(
      children: [

        Expanded(
          child: Consumer<MyPostProvider>(
            builder: (context, provider, child) {
              return
                provider.listOwnBid.length==0?Center(
                  child: Text("No Post Found"),
                ):
                ListView.builder(
                controller: provider.scrollController,
                itemCount: provider.listOwnBid.length,
                itemBuilder: (context, i) {
                  return Padding(padding: EdgeInsets.only(bottom: 12.h,left: 0.w,right: 0.w),child: iteamMyPost(provider.listOwnBid[i],i),);
                },
              );
            },
          ),
        )

      ],
    );
  }


  iteamMyPost(PostBidData postBidData, int index) {

    return Consumer<MyPostProvider>(
      builder: (context, provider, child) {
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
                      postBidData.genericCardsDto!.mainTag!,
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
              BaseWidget().heading(
                  postBidData.genericCardsDto!.topicName!,
                  postBidData.genericCardsDto!.postingTime!=null?postBidData.genericCardsDto!.postingTime!.split(" ").first:"",
                  postBidData.genericCardsDto!.content!),
              SizedBox(height: 8.h,),
              BaseWidget().routes(postBidData.genericCardsDto!.source!,
                  postBidData.genericCardsDto!.destination!),
              SizedBox(height: 8.h,),
              iteams(postBidData, index),
              SizedBox(height: 8.h,),
              BaseWidget().showBidRepostButton((val) async{
                if (val == 0) {
                  if (postBidData.bidings!.length > 0) {
                    showBootomSheet(context,postBidData.bidings);
                  } else {
                    ToastMessage.show(context, "No any Bids to show");
                  }
                }
                if(val==1){

                  Future.delayed(
                      Duration.zero,
                          () => _showMyDialog(index,provider)
                  );


                }
                if(val==3){
                  String description= "${postBidData.genericCardsDto!.mobileNumber.toString()}'Type : ${postBidData.genericCardsDto!.type}, \nSubject : ${postBidData.genericCardsDto!.content}, \nSource : ${postBidData.genericCardsDto!.source}, \nDestination : ${postBidData.genericCardsDto!.destination}, \nLink : https://api.tkdost.com/bids/?id=${postBidData.genericCardsDto!.id}'";
                  await Utils().callShareFunction(description);
                }
                if(val==4){
                 provider.reSendPost(context,postBidData);
                }

              },false)


            ],
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(int index,MyPostProvider myPostProvider) async {
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
                myPostProvider.deletePost(index, context);
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

  void showBootomSheet(BuildContext context,List<Bidings>? bidings) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(heightFactor:0.7,child:ShowBidsScreen(listBidings: bidings,));
        });
  }

  iteams(PostBidData postBidData, int index) {
    if (postBidData.bidings!.length == 0) {
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isLast ? Colors.white : Color(0x332C363F),
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
                                  bidings.firstName! + " " + bidings.lastName!,
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
                                  visible: bidings.isPaid!=0?true:false,
                                  child: Container(
                                    width: 12.w,
                                    height: 12.h,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(Images.verified)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              bidings.companyName!,
                              style: TextStyle(
                                color: Color(0x99001E49),
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
                  onTap: () {
                    // widget.provider.deleteBid(index, bidings);
                    Utils().callFunction("${bidings.bidings!.mobileNumber}");
                  }
                  , child: Container(
                  width: 22.w,
                  height: 22.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
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



}