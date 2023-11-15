import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';
import '../kyc/kyc_screen_one.dart';

class CreateBuySell extends StatelessWidget{
  late User user;
  bool isLoad=true;


  getLogin()async{
    user=await LocalSharePreferences().getLoginData();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: isLoad?Container():Column(
          children: [
            topBar(context),
            item("My Posts",(){
              Navigator.pushNamed(context, AppRoutes.mypost);

            },FontWeight.w600),
            item("Jobs",(){
              Navigator.pushNamed(context, AppRoutes.job);

            },FontWeight.w600),
            item("Vehicle buy/sell",(){
              Navigator.pushNamed(context, AppRoutes.buysell);

            },FontWeight.w600),
            item("Get verified",(){
              showBootomSheet(context);

            },FontWeight.w600),
            item("App setting",(){
              Navigator.pushNamed(context, AppRoutes.appsetting);
            },FontWeight.w400),
            item("Help & support",(){
              Navigator.pushNamed(context, AppRoutes.helpsupport);

            },FontWeight.w400),

            itemLogout("Logout",(){

            },)
          ],
        ),
      ),
    );
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
            BaseWidget().getImage("",width: 80.w,height: 112.h),
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
              user.content!.first.city!+","+user.content!.first.state!,
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
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.editprofile);
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
              'Edit your profile',
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

}