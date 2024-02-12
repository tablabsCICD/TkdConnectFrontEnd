import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/images.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';
import '../../widgets/plan_widget.dart';
import '../../widgets/textview.dart';

class PlanDetailsScreen extends StatefulWidget{
 final List<String>listLaugaes;
 final List<bool>selectLang;
 final String image;
 final String subtitle;
 final String amount;

  const PlanDetailsScreen({super.key, required this.listLaugaes, required this.selectLang, required this.image, required this.subtitle, required this.amount});

  @override
  State<StatefulWidget> createState() {
   return _PlanDetailsScreen();
  }

}

class _PlanDetailsScreen extends State<PlanDetailsScreen>{



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
                      title: 'Plan Details',
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(onTap:(){
                      Navigator.pop(context);
                    },child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 24.h,),
              selectedPlan( widget.image, widget.subtitle, widget.amount),

              Expanded(
                child: ListView.builder(
                    itemCount: widget.listLaugaes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return laguagesList(index);
                    }),
              )

            ],

          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 60.h,left: 20.w,right: 20.w),
        child: Button(title: "Choose plan", width: MediaQuery.of(context).size.width,height: 52.h,textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ), onClick: (){
          Navigator.pushReplacementNamed(context, AppRoutes.intro_one);


        },),
      ),

    );
  }



  laguagesList(int index){
    return Container(

      width: MediaQuery.of(context).size.width,
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.w),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        border: Border(

          bottom: BorderSide(width: 0.50.w, color: ThemeColor.border_grey),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: Text(
                widget.listLaugaes[index],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily:GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ),
          widget.selectLang[index]? SvgPicture.asset(Images.green_tick,height: 24.h,width: 24.w,):Textview(TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ), title: "No")
        ],
      ),
    );
  }

  selectedPlan(String image,String title,String amount){
    return Container(
      width: 335.w,
      height: 80.h,
      padding: EdgeInsets.only(left: 12.w,right: 12.w,top: 12.h,bottom: 12.h),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: ThemeColor.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.w, color:ThemeColor.white),
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

         SvgPicture.asset(image),

          Expanded(
            child: Container(
              height: 52.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(

                      margin: EdgeInsets.only(left: 12.w),child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Basic plan',
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  amount,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                           SizedBox(height: 4.h),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }



}