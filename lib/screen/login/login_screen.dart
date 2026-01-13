import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../generated/l10n.dart';
import '../../provider/login_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/editText_mobile.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppHash();
  }
  Future<void> getAppHash() async {
    final signature = await SmsAutoFill().getAppSignature;
    print("✅ YOUR APP HASH: $signature");
  }

  _buildPage(context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: ThemeColor.baground,
              margin: EdgeInsets.only(left: 20.w, right: 20.20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 128.h,
                  ),
                  SvgPicture.asset(
                    Images.logo,
                    height: 57.h,
                    width: 100.w,
                  ),
                  SizedBox(
                    height: 72.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Textview(
                        TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                        title: S.current.login_to_continue),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  EditTextMobile(
                    key:  Key('mobileNumber'),
                    onChange: (val){
                      provider.isMobileValide(val);
                    },
                    keybordType: TextInputType.number
                  ,width: MediaQuery.of(context).size.width,
                    height: 52.h,
                    hint: S.current.Enter_mobile_number,
                    controller: mobileController,
                  ),
                  SizedBox(
                    height: 36.h,
                  ),
                  Button(
                      key:  Key('LoginButton'),
                      isEnbale: provider.isMobileNumberValid
                      ,width: MediaQuery.of(context).size.width,
                      height: 49.h,

                      title: S.current.Send_OTP,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                      onClick: () {

                        provider.isUserDeleted(mobileController.text, context);



                      }),
                  SizedBox(
                    height: 44.h,
                  ),
                  Textview(
                    title: S.current.OR,

                    TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 62.h,
                  ),
                 // socialLogin(),
                  SizedBox(
                    height: 40.h,
                  ),
                  newRegistration(),


                ],
              ),
            ),
          );
        },
      ),

     bottomNavigationBar:   supportNumber(),
    );
  }

  socialLogin() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.gmail_logo,
            height: 32.h,
            width: 32.w,
          ),
          SizedBox(
            width: 28.w,
          ),
          SvgPicture.asset(
            Images.fb_logo,
            height: 32.h,
            width: 32.w,
          ),
        ],
      ),
    );
  }

  newRegistration() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Textview(
              TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 14.sp,
                  color: Colors.black),
              title: S.current.NewUser),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, AppRoutes.registration_personal_details);
            },
            child: Textview(
                TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14.sp,
                    color: Colors.red),
                title: S.current.RegisterHere),
          )
        ],
      ),
    );
  }

  supportNumber() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Textview(
                TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 12.sp,
                    color: Colors.black),
                title: S().helpSupport),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, AppRoutes.registration_personal_details);
              },
              child:

              Row(
                children: [
                  InkWell(

                    onTap: (){
                      Utils().callFunction("8123006888");
                    },child: subTitle('(+91)  8123006888 '),
                  ),
                  const Text(" / "),
                  InkWell(

                    onTap: (){
                      Utils().callFunction("8123004666");
                    },child:   subTitle('(+91)  8123004666 '),
                  ),
                ],
              )
              ,
            )
          ],
        ),
      ),
    );
  }


  subTitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        color: const Color(0xFFC3262C),
        fontSize: 10.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }
}
