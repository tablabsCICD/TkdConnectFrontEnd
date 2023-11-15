import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../route/app_routes.dart';
import '../../widgets/button.dart';

class KYCScreenTwo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _KYCScreenTwo();
  }
}

class _KYCScreenTwo extends State<KYCScreenTwo>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 20.w,top: 12.h,right: 20.w),
          child: Column(
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 36.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Textview(
                      title: 'Free one time verification',
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(Images.close_circle)
                  ],
                ),
              ),
              SizedBox(height: 24.h,),
              SizedBox(
                width: 327.w,
                child: Text(
                  'Please enter your valid Aadhar number that matches your name and mobile number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0x99001E49),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 36.h,),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Enter Aadhar number',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,

                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 6.h,),
              editWithButton(),
              SizedBox(height: 36.h,),
              enterOtp(),
              SizedBox(height: 6.h,),
              OtpBox()



            ],

          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 60.h,left: 20.w,right: 20.w),
        child: Button(title: "Proceed to verification", width: MediaQuery.of(context).size.width,height: 52.h,textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ), onClick: (){

          Navigator.pushNamed(context, AppRoutes.home);


        },),
      ),

    );
  }


  editWithButton(){
    return Container(
      width: 327.w,
      height: 52.h,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color: Color(0x332C363F)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      'eg. 2313 XXXX XXXX XXXX',
                      style: TextStyle(
                        color: Color(0x662C363F),
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                ),
                sendOtp(),

              ],
            ),
          ),
        ],
      ),
    );
  }

  sendOtp(){
    return Container(
      width: 80.w,
      height: 27.h,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: ShapeDecoration(
        color: Color(0xFF001E49),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Send OTP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  enterOtp(){
    return Align(
        alignment: Alignment.topLeft,child:
    Text(
      'Send OTP',
      style: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w400,
      ),
    ));
  }

  OtpBox(){
    return Container(
      height: 90,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          otpBox(),
          SizedBox(width: 12.w,),
          otpBox(),
          SizedBox(width: 12.w,),
          otpBox(),
          SizedBox(width: 12.w,),
          otpBox()
        ],
      ),
    );
  }

  otpBox(){
    return  Container(
      width: 72.w,
      height: 52.h,
      // padding:  EdgeInsets.symmetric(horizontal: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child:  Text(
        '•',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 36.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
