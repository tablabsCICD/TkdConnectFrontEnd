import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../generated/l10n.dart';
import '../../route/app_routes.dart';

class IntroScreenTwo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFF4F6F6),
      body: Container(

        margin: EdgeInsets.only(left: 32.w,right: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            screen(context),
            SizedBox(
              height: 40.h,
            ),
            image(),
            headLineText(),
            SizedBox(
              height: 16.h,
            ),
            description()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 32.w,right: 32.w,bottom: 52.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Images.into_progress_two,width: 40.w,height: 6.h,)   ,
            InkWell(onTap:(){
              Navigator.pushReplacementNamed(context, AppRoutes.intro_three);

            },child: SvgPicture.asset(Images.red_next_button,height: 56.h,width: 80.w,))          ],

        ),
      ),
    );
  }

  image(){
    return Container(
      width: 335.w,
      height: 335.h,
      child:
      SvgPicture.asset(Images.introw_two,width: 335.w,height: 335.h,)
      ,
    );
  }

  description(){
    return SizedBox(
      width: 311.w,
      child: Text(
        S().introTwoDescription,
        style: TextStyle(
          color: Colors.black.withOpacity(0.6000000238418579),
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
          height: 1.64.h,
        ),
      ),
    );
  }

  screen(context){
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 31.w,
        height: 24.h,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: [
            BoxShadow(
              color: Color(0x1E00B398),
              blurRadius: 24,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.pushReplacementNamed(context, AppRoutes.registration_personal_details);
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }

  headLineText(){
    return SizedBox(
      width: 332.w,
      child: Text(
        'Grow your\nbusiness with us',
        style: TextStyle(
          color: Colors.black.withOpacity(0.8999999761581421),
          fontSize: 26,
          fontFamily: GoogleFonts.besley().fontFamily,
          fontWeight: FontWeight.w800,
          height: 1.38,
        ),
      ),
    );
  }

}