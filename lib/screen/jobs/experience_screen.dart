import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../provider/jobs/list_exp_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';
import '../../widgets/textview.dart';

class ExperienceScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ListExpProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }
  
  
  _buildPage(context){
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
                      title: S().experies,
                      TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(onTap: (){
                      Navigator.of(context).pop();
                    },child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 24.h,),
              selectTab(),
              SizedBox(height: 16.h,),
              searchBox(context),
              listLang()

            ],

          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 60.h,left: 20.w,right: 20.w),
        child: button(context),
      ),

    );
  }
  button(BuildContext context){
    return Consumer<ListExpProvider>(
  builder: (context, provider, child) {
  return Button(

      isEnbale: provider.isEnable,title: S().done, width: MediaQuery.of(context).size.width,height: 52.h,textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
    ), onClick: (){

        provider.onclick(context);

    },);
  },
);
  }

  searchBox(BuildContext context){
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
                        margin: EdgeInsets.only(left: 10.w),
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
                          child:TextField(
                            controller: TextEditingController(),
                            onChanged: (value){


                            },

                            decoration: InputDecoration(
                                hintText: S().searchPlace,

                                border: InputBorder.none,
                                hintStyle:TextStyle(
                                  color: Color(0x662C363F),
                                  fontSize: 14.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                )


                            ),

                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
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

  laguagesList(int index,BuildContext context){
    return Consumer<ListExpProvider>(
  builder: (context, provider, child) {
  return InkWell(
      onTap: (){
        provider.selectTab(index);
      },
      child: Container(

        width: MediaQuery.of(context).size.width,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.w),
        decoration: BoxDecoration(
          color: provider.checkSelecte(index)?ThemeColor.select_green:ThemeColor.white,
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
                  provider.listExp[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily:GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

            ),
            provider.checkSelecte(index) ? SvgPicture.asset(Images.green_tick,height: 24.h,width: 24.w,):SizedBox()
          ],
        ),
      ),
    );
  },
);
  }


  selectTab(){
          return Consumer<ListExpProvider>(
  builder: (context, provider, child) {
  return Container(
      width: 327.w,
      height: 32.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0x332C363F),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.w, color: Color(0x332C363F)),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
               provider.changeTab();
              },
              child: Container(
                height: double.infinity,
                padding:  EdgeInsets.symmetric(horizontal: 12.w),
                decoration: ShapeDecoration(
                  color: provider.onFrom?Colors.white:Color(0x19001E49),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().from,
                      style: TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: provider.onFrom?FontWeight.w400:FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: (){
               provider.changeTab();
              },
              child: Container(
                height: double.infinity,
                padding:  EdgeInsets.symmetric(horizontal: 12.w),
                decoration: ShapeDecoration(
                  color: !provider.onFrom?Colors.white:Color(0x19001E49),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0x332C363F)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().to,
                      style: TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight:  !provider.onFrom?FontWeight.w400:FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);

  }

  listLang() {

    return  Consumer<ListExpProvider>(
  builder: (context, provider, child) {
  return Expanded(
      child: ListView.builder(
          itemCount:provider.listExp.length,
          itemBuilder: (BuildContext context, int index) {
            return laguagesList(index,context);
          }),
    );
  },
);

  }
}