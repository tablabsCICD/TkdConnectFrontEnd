import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/screen/kyc/kyc_screen_two.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../widgets/button.dart';

class KYCScreenOne extends StatefulWidget{
  const KYCScreenOne({super.key});

  @override
  State<StatefulWidget> createState() {
    return _KYCScreenOne();
  }
}

class _KYCScreenOne extends State<KYCScreenOne>{
  List<String>listLaugaes=["Mumbai",'Pune','Kolhapur','Nashik','Nagar','Satra','Sangli'];

  List<bool>selectLang=[false,false,true,false,false,false,false];


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
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 24.h,),
              SvgPicture.asset(Images.kyc_one,height: 236.h,width: 236.w,),
              SizedBox(height: 20.h,),
              Text(
                'Identity verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h,),

              SizedBox(
                width: 327.w,
                child: Text(
                  'Please help us verify your identity in order to keep the community secure',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0x99001E49),
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )


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

          showBootomSheet();


        },),
      ),

    );
  }


  void showBootomSheet() {

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(heightFactor:0.7,child: KYCScreenTwo());
        });

  }



}