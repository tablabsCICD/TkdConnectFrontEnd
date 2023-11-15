import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/screen/kyc/kyc_screen_one.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/linear_progress.dart';
import 'package:tkd_connect/widgets/sign_in_widget.dart';

import '../../constant/images.dart';
import '../../widgets/button.dart';
import '../../widgets/plan_widget.dart';
import '../../widgets/textview.dart';

class SelectPlanScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return _SelectPlanScreen();
  }
}

class _SelectPlanScreen extends State<SelectPlanScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20.w,right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [

            SizedBox(height: 21.5.h,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(Images.arrow_back),
              Textview(
                title: 'Select Plan',
                TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox()
            ],
          ),
          SizedBox(height: 21.h,),
          LinearProgressBar(fillValue: 301.w),
          SizedBox(height: 21.h,),
          PlanWidget(isSelected: true, title: 'Clear pearl', amount: '0', image: Images.pearls, subtitle: 'CURRENT PLAN',),
          SizedBox(height: 12.h,),
          PlanWidget(isSelected: false, title: 'Blue pearl', amount: '299', image: Images.pearls_blue,subtitle: 'RECOMMENDED'),
          SizedBox(height: 12.h,),
          PlanWidget(isSelected: false, title: 'Red pearl', amount: '349', image: Images.pearls_red,subtitle: 'No'),
          SizedBox(height: 12.h,), PlanWidget(isSelected: false, title: 'Black pearl', amount: '449', image: Images.pearls_black,subtitle: 'No'),
          SizedBox(height: 161.h,), Button(width: 335.w, height: 49.h, title: "Next", textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ), onClick: (){
                showBootomSheet();

              }),
          SizedBox(height: 60.h,),
           AlredayAccountWidget()
         ]

        ),

        ),
      ),

    );
  }


  void showBootomSheet() {

    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(heightFactor:0.7,child: KYCScreenOne());
        });

  }




  
  
}