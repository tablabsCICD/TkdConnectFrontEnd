import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/kyc/kyc_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../route/app_routes.dart';
import '../../widgets/button.dart';
import '../../widgets/otp_textview.dart';

class KYCScreenTwo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KYCScreenTwo();
  }
}

class _KYCScreenTwo extends State<KYCScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => KycProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(left: 20.w, top: 12.h, right: 20.w),
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
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(onTap: (){
                        Navigator.pop(context);
                      },child: SvgPicture.asset(Images.close_circle))
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  width: 327.w,
                  child: Text(
                    'Please enter your valid Aadhar number that matches your name and mobile number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0x99001E49),
                      fontSize: 14.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter Aadhar number',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                editWithButton(),
                SizedBox(
                  height: 36.h,
                ),
                otpView()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer<KycProvider>(
  builder: (context, provider, child) {
  return Container(
        margin: EdgeInsets.only(bottom: 60.h, left: 20.w, right: 20.w),
        child: Button(
          title: "Proceed to verification",
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
          onClick: () {
            // Navigator.pushNamed(context, AppRoutes.home);
            provider.checkOtpValid(context);
          },
        ),
      );
  },
),
    );
  }

  editWithButton() {
    return Consumer<KycProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 327.w,
          height: 56.h,
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
                        child: TextFormField(
                          controller: provider.adharNumberController,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "eg.1020 XXXX XXXx",
                              counter: Offstage(),
                              contentPadding: EdgeInsets.only(bottom: 8.h),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              )),
                          onChanged: (value) {
                            provider.checkAdharNumber(context);
                          },
                        ),
                      ),
                    ),
                    Visibility(
                        visible: provider.isSendOTPButtonVisible,
                        child: sendOtp())
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  otpView(){
    return Consumer<KycProvider>(
  builder: (context, provider, child) {
  return Visibility(
    visible: provider.isButtonVisible,
      child: Column(
        children: [
          enterOtp(),
          SizedBox(
            height: 6.h,
          ),
          OtpBox()
        ],
      ),
    );
  },
);
  }

  sendOtp() {
    return Consumer<KycProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            provider.createToken(context);
          },
          child: Container(
            width: 80.w,
            height: 27.h,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: ShapeDecoration(
              color: Color(0xFF001E49),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
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
          ),
        );
      },
    );
  }

  enterOtp() {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Send OTP',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ));
  }

  OtpBox() {
    return Consumer<KycProvider>(
  builder: (context, provider, child) {
  return Container(
      height: 90.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          otpBox(provider.otpController1),
          SizedBox(
            width: 12.w,
          ),
          otpBox(provider.otpController2),
          SizedBox(
            width: 12.w,
          ),
          otpBox(provider.otpController3),
          SizedBox(
            width: 12.w,
          ),
          otpBox(provider.otpController4),
          SizedBox(
            width: 12.w,
          ),
          otpBox(provider.otpController5),
          SizedBox(
            width: 12.w,
          ),
          otpBox(provider.otpController6)
        ],
      ),
    );
  },
);
  }

  otpBox(TextEditingController controller) {
    return Container(
      width: 45.w,
      height: 45.h,
      
      // padding:  EdgeInsets.symmetric(horizontal: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextFormField(
         controller: controller,
        maxLength: 1,
        obscureText: false,
        keyboardType: TextInputType.number,
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,

        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),

        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "-",
            counter: Offstage(),
            contentPadding: EdgeInsets.only(bottom: 8.h),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            )),

        onChanged: (value) {
          if (value.length >= 1) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
          //onChnage();
        },
      ),
    );
  }
  

}
