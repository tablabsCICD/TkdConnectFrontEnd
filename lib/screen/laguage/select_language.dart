import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/screen/app_setting/lang_change.dart';
import 'package:tkd_connect/screen/laguage/list_language.dart' hide ListLanguageChange;
import 'package:tkd_connect/widgets/textview.dart';

import '../../constant/images.dart';
import 'change_language_screen.dart';

class SelectLanguageScreen extends StatelessWidget{
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
          color: const Color(0xFFF4F6F6),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          SvgPicture.asset(Images.logo,height: 93.h,width: 160.w,),
            SizedBox(height: 39.h,),
            Center(
              child: InkWell(
                onTap: (){
                  showBootomSheet(context);
                //  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChooseLanguagePage()));
                },
                child: Container(decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.50, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),height:52.h,width:332.w,child: Center(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 12.w,right: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Textview(TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w400,
                        ), title: "Choose the language "),
                        SvgPicture.asset("assets/images/from_arrow.svg",height:24.h ,width: 24.w,)
                      ],
                    ),
                  ),
                )),
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
          return const FractionallySizedBox(heightFactor:0.7,child:LanguageChange());
        });
  }
}