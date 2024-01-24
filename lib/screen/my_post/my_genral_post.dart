import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import '../../constant/api_constant.dart';
import '../../constant/app_constant.dart';
import '../../generated/l10n.dart';
import '../../model/response/own_genral_post.dart';
import '../../model/response/userdata.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';

class MyGenralPostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyGenralPost();
  }

}


class MyGenralPost extends State<MyGenralPostScreen> {

 @override
  void initState() {
   callApi();
    super.initState();
  }

  ScrollController scrollController =ScrollController();
  List<GernralPostOwnData> listOwnPost=[];
 bool isLoad=true;

  @override
  Widget build(BuildContext context) {
        return _buildPage(context);
  }


  _buildPage(BuildContext context) {
    return !isLoad || listOwnPost.length==0?Center(
      child: Text("No Post Found"),
    ) :Column(
      children: [

        Expanded(
          child: ListView.builder(
      controller: scrollController,
      itemCount: listOwnPost.length,
      itemBuilder: (context, i) {
        return Padding(padding: EdgeInsets.only(bottom: 12.h,left: 0.w,right: 0.w),child: iteamMyPost(listOwnPost[i],i),);
      },
    ),
        )

      ],
    );
  }


  iteamMyPost(GernralPostOwnData ownData, int index) {
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
                  ownData.typeName!,
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
              ownData.title!,
              "",
        ownData.description!),
          SizedBox(height: 8.h,),

          SizedBox(height: 8.h,),
          BaseWidget().deleteMyPostButton((val) async{
            if (val == 10) {
              Future.delayed(
                  Duration.zero,
                      () => _showMyDialog(index)
              );

            }
            if(val==1){

              Future.delayed(
                  Duration.zero,
                      () => _showMyDialog(index)
              );


            }
            if(val==3){
              String description= "'Type : ${ownData!.typeName!}, \nSubject : ${ownData.description}, \nPost Title : ${ownData!.title}, \nLink : https://api.tkdost.com/bids/?id=${ownData.id}'";
              await Utils().callShareFunction(description);
           }
          })


        ],
      ),
    );
  }

  void callApi() async{
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    String url="${ApiConstant.BASE_URL}getBuySellByUserId?userId=${user.content!.first.id}";
    print("the url ${url}");
    ApiResponse apiResponse=await ApiHelper().apiGet(url);
    print("the url ${apiResponse.response}");
    if(apiResponse.status==200){
      OwnGenralPostList ownGenralPostList=OwnGenralPostList.fromJson(apiResponse.response);
      listOwnPost.addAll(ownGenralPostList.data!);
      print('the lenghth is ${listOwnPost.length}');

      setState(() {
      });
    }else{
       isLoad=false;
      setState(() {
      });

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


 deletePost(int index,BuildContext context)async{
    String myUrl = ApiConstant.BASE_URL+'GeneralPost/deleteById?id=${listOwnPost[index].id!}';
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