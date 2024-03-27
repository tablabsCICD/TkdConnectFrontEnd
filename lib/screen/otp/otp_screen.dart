import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tkd_connect/provider/otp_provider/otp_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/button.dart';
import '../../generated/l10n.dart';
import '../../widgets/otp_textview.dart';

class OTPScreen extends StatefulWidget {

  final String mobileNumber;
  final bool isRegistration;

  const OTPScreen({super.key, required this.mobileNumber, required this.isRegistration});

  @override
  State<StatefulWidget> createState() {

    return _OTPScreen();
  }
}


class _OTPScreen extends State<OTPScreen> {

  ValueNotifier<double> valueNotifier = ValueNotifier(10);



  
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => OtpProvider("Ideal",widget.mobileNumber,widget.isRegistration),
      builder: (context, child) => _buildPage(context),
    );

   
  }
  _buildPage(context){
    return Scaffold(
      body: Container(
        color: ThemeColor.baground,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 128.h,
            ),
            progress(),
            SizedBox(
              height: 12.h,
            ),
            mobileNumber(),
            changeNumber(),
            SizedBox(
              height: 52.h,
            ),
            textEnterOTP(),
            OtpBox(),
            SizedBox(
              height: 12.h,
            ),
            attemptText(),
            SizedBox(
              height: 26.h,
            ),
            button(context),
            SizedBox(
              height: 32.h,
            ),
            resendOTP()
          ],
        ),
      ),
    );
  }
  
  button(context){
   return Consumer<OtpProvider>(
  builder: (context, provider, child) {
  return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Button(
        isEnbale: provider.isButtonEnbale,
          width: MediaQuery.of(context).size.width,
          height: 42.h,
          title: S.current.Submit,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
          onClick: () {
            provider.verifyOtp(context);
          }),
    );
  },
);
  }

  progress() {
    return Consumer<OtpProvider>(
  builder: (context, provider, child) {
  return SimpleCircularProgressBar(
      progressStrokeWidth: 4,
      size: 40.sp,
      backStrokeWidth: 2,
      maxValue: 150,
      animationDuration: 60,
      progressColors: [ThemeColor.progress_color],
      backColor: ThemeColor.border_grey,
      mergeMode: true,
      onGetText: (double value) {
        return Text(
          '${provider.timeRemaning}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeColor.theme_blue,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  },
);
  }

  mobileNumber() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: S.current.OTP_sent_to,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' +91 ${widget.mobileNumber}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  changeNumber() {
    return InkWell(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Container(
        width: 118.w,
        height: 24.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S.current.Change_number,
              style: TextStyle(
                color: ThemeColor.red,
                fontSize: 14.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  textEnterOTP() {
    return Container(
      margin: EdgeInsets.only(left: 20.w),
      width: MediaQuery.of(context).size.width,
      child: Text(
        S.current.EnterOTP,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  OtpBox() {
    return Consumer<OtpProvider>(
  builder: (context, provider, child) {
  return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Row(
        children: [
          OtpTextView(
            hint: "-",
            otpController: provider.textControllerOne,
            onChnage: () {
             provider. onCallButtonEnble();
            },
          ),
          SizedBox(
            width: 12.h,
          ),
          OtpTextView(
            hint: "-",
            otpController: provider.textControllerTwo,
            onChnage: () {
              provider. onCallButtonEnble();
            },
          ),
          SizedBox(
            width: 12.h,
          ),
          OtpTextView(
            hint: "-",
            otpController: provider.textControllerThree,
            onChnage: () {
              provider. onCallButtonEnble();
            },
          ),
          SizedBox(
            width: 12.h,
          ),
          OtpTextView(
            hint: "-",
            otpController: provider.textControllerFour,
            onChnage: () {
              provider. onCallButtonEnble();
            },
          ),
          SizedBox(
            width: 12.h,
          ),

          OtpTextView(
            hint: "-",
            otpController: provider.textControllerFive,
            onChnage: () {
              provider. onCallButtonEnble();
            },
          ),
          SizedBox(
            width: 12.h,
          ),
          OtpTextView(
            hint: "-",
            otpController: provider.textControllerSix,
            onChnage: () {
              provider. onCallButtonEnble();
            },
          ),
          SizedBox(
            width: 12.h,
          ),
        ],
      ),
    );
  },
);
  }

  attemptText() {
    return Container(
      margin: EdgeInsets.only(right: 20.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '${S.current.Attempts} 00/03',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  resendOTP() {
    return Consumer<OtpProvider>(
  builder: (context, provider, child) {
  return Container(
      width: 335.w,
      height: 24.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 335.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.current.Havent_received_OTP,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: (){
                    provider.onClickResend(context);
                  },
                  child: Text(
                    S.current.Resend_OTP,
                    style: TextStyle(
                      color:provider.resendButtonEnble?ThemeColor.red:ThemeColor.border_grey,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
);
  }
}
