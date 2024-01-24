import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../generated/l10n.dart';
import '../../main.dart';
import '../../model/request/language_select.dart';
import '../../route/app_routes.dart';
import '../../widgets/button.dart';

class ListLanguageChange extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ListLanguageChange();
  }
}

class _ListLanguageChange extends State<ListLanguageChange>{
  List<LanaguageSelect>listLaugaes=LanaguageSelect().getLang();
  bool isLangSelect=false;
  String selectLanguage="en";

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
                      title: 'Choose a language',
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
              searchBox(),
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
        child: Button(isEnbale: isLangSelect,title: "Save preferred language", width: MediaQuery.of(context).size.width,height: 52.h,textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ), onClick: ()async{
          if(isLangSelect){
            print('the selected lang is ${selectLanguage}');
              S.load(Locale(selectLanguage));
            LocalSharePreferences sharePreferences=LocalSharePreferences();
            await sharePreferences.setLanguage(selectLanguage);
            Navigator.popAndPushNamed(context, AppRoutes.home);
          }else{
            ToastMessage.show(context, "Please Select the language");
          }
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
            width: 327.w,
            padding: EdgeInsets.only(top: 4.h),
          ),
        ],
      ),
    );
  }

  laguagesList(int index){
    return InkWell(
      onTap: (){
        for(int i=0;i<listLaugaes.length;i++){
          listLaugaes[i].isSelect=false;
        }
        listLaugaes[index].isSelect=true;
        selectLanguage=listLaugaes[index].langCode!;
        // S.load(Locale("hi"));
        isLangSelect=true;
        setState(() {
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.w),
        decoration: BoxDecoration(
          color: listLaugaes[index].isSelect!?ThemeColor.select_green:ThemeColor.white,
          border: Border(

            bottom: BorderSide(width: 0.50, color: Color(0x332C363F)),
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
                  listLaugaes[index].langName!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily:GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

            ),
            listLaugaes[index].isSelect!? SvgPicture.asset(Images.green_tick,height: 24.h,width: 24.w,):SizedBox()
          ],
        ),
      ),
    );
  }

}