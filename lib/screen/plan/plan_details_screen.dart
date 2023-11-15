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
  @override
  State<StatefulWidget> createState() {
   return _PlanDetailsScreen();
  }

}

class _PlanDetailsScreen extends State<PlanDetailsScreen>{
  List<String>listLaugaes=["Heading",'Heading 1','Heading 2','Heading 3','Heading 4','Heading 5','Heading 6'];

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
                      title: 'Plan Details',
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
              selectedPlan( Images.pearls, "Clear Peral", "0"),

              Expanded(
                child: ListView.builder(
                    itemCount: listLaugaes.length,
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

  searchBox(){
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 52.h,
            padding: const EdgeInsets.symmetric(horizontal: 0),
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
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                SvgPicture.asset(Images.search_normal)

                              ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: SizedBox(
                          child: Text(
                            'Search a language',
                            style: TextStyle(
                              color: Color(0x662C363F),
                              fontSize: 14.sp,
                              fontFamily:GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 327,
            padding: const EdgeInsets.only(top: 4),
          ),
        ],
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
                listLaugaes[index],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily:GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ),
          selectLang[index]? SvgPicture.asset(Images.green_tick,height: 24.h,width: 24.w,):Textview(TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ), title: "15")
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