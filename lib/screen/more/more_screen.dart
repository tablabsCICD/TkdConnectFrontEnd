

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/utils/utils.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/images.dart';
import '../../model/response/userdata.dart';
import '../../utils/colors.dart';
import '../kyc/kyc_screen_one.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoreScreen();
  }

}
class _MoreScreen extends State<MoreScreen> {

  late User user;
  bool isLoad=true;




  @override
  void initState() {
    super.initState();
    getLogin();

  }

  getLogin()async{
    user=await LocalSharePreferences().getLoginData();
    isLoad=false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: isLoad?Container():SingleChildScrollView(
          child: Column(
            children: [
              topBar(context),
              item(S().myPost,(){
                Navigator.pushNamed(context, AppRoutes.mypost);

              },FontWeight.w600),
              item(S().jobs,(){
                Navigator.pushNamed(context, AppRoutes.job);

              },FontWeight.w600),
              AppConstant.USERTYPE==AppConstant.TRANSPOTER || AppConstant.USERTYPE==AppConstant.AGENT?
              item(S().buySell,(){
                Navigator.pushNamed(context, AppRoutes.buysell);

              },FontWeight.w600):SizedBox(),
              item(S().group,(){

                Navigator.pushNamed(context, AppRoutes.group,arguments: user.content!.first.id);

              },FontWeight.w600),
              item(S().getVerified,(){

                openVerifiedTag();
              },FontWeight.w600),
              // item(S().change_plan,(){
              //   Navigator.pushNamed(context, AppRoutes.registration_plan_details);
              // },FontWeight.w400),
              item(S().appSetting,(){
                Navigator.pushNamed(context, AppRoutes.appsetting);
              },FontWeight.w400),
              item(S().helpSupport,(){
                Navigator.pushNamed(context, AppRoutes.helpsupport);

              },FontWeight.w400),

              item(S().shareapp,(){

                String meesage="Download TKD Connect now and use it to \n "
                    "We are here to elevate your logistics experience. Let us be your logistics assistance and your business needs will be fulfilled seamlessly. \n \n "
                "https://play.google.com/store/apps/details?id=com.pdk.tkd";
                Utils().callShareFunction(meesage);



              },FontWeight.w400),

              item(S().rateAndReviewApp,() async {
                Utils().requestReview(context);

              },FontWeight.w400),

              item(S().terms_condition,() async {
                Utils().callTermsAndCondition(context);

              },FontWeight.w400),

              item(S().privacyAndPolicy,() async {
                Utils().callPrivacyAndPolicy(context);

              },FontWeight.w400),

              itemLogout(S().logout,(){

                _showMyDialog();

              },)
            ],
          ),
        ),
      ),
    );
  }


  openVerifiedTag(){

    if(user.content!.first.verified==1){
      ToastMessage.show(context, "You Already Verified");
    }else{
      showBootomSheet(context);
    }
  }


  topBar(BuildContext context) {
    return Container(
        width: 375.w,
        height:  266.h ,
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        decoration: ShapeDecoration(
          color: ThemeColor.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            BaseWidget().getImageclip(user.content!.first.companyLogo!=null?user.content!.first.companyLogo!:"",width: 80.w,height: 112.h),
            selectedPlan(),
            nameWithVerfiyTag(),
            Text(
              user.content!.first.companyName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            SizedBox(height:12.h,),
            Text(
              user.content!.first.companyAddress!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(height:12.h,),
            button(context)
          ],
        ));
  }

  selectedPlan(){
    return  Container(
      transform: Matrix4.translationValues(0.0, -10.0.h, 0.0),
      // width: 36.w,
      // height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Utils().getSelectedPackageImage(user.content!.first.isPaid!),
            height: 8.h,
            width: 8.w,
          ),
          SizedBox(width: 4.w,),
          Text(
            Utils().getSelectedPackageName(user.content!.first.isPaid!),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 8.sp,
              fontFamily: AppConstant.FONTFAMILY,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  nameWithVerfiyTag(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          user.content!.first.firstName!+" "+user.content!.first.lastName!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        SizedBox(width: 8.w,),
        Visibility(visible:user.content!.first.isPaid!=0?true:false,child: SvgPicture.asset(Images.verified))
      ],
    );
  }

  button(BuildContext context){
    return InkWell(
      onTap: ()async{
       var obj=await  Navigator.pushNamed(context, AppRoutes.editprofile);
          if(obj==1){
            getLogin();
          }
       },
      child: Container(
        width: 117.w,
        height: 27.h,
        padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Colors.white),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S().editYourProfile,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }


  item(String  title,Function onClick,FontWeight fontWeight){
    return InkWell(
      onTap: (){
        onClick();
      },
      child: Container(
        width: 327.w,
        height: 60.h,
        decoration: BoxDecoration(
          border: Border(

            bottom: BorderSide(width: 1, color: Color(0x192C363F)),
          ),
        ),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: fontWeight,

                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    child: Stack(children: [
                      SvgPicture.asset(Images.arrow_right)
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  itemLogout(String  title,Function onClick){
    return InkWell(
      onTap: (){
        onClick();
      },
      child: Container(
        width: 327.w,
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    child: Stack(children: [
                    //  SvgPicture.asset(Images.arrow_right)
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showBootomSheet(BuildContext context) {

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(heightFactor:0.7,child: KYCScreenOne());
        });

  }


  Future<void> _showMyDialog ()async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(S().logout,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S().logoutMsg,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(S().yes,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () async{
                await LocalSharePreferences().logOut();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
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