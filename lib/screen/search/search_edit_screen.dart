import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../generated/l10n.dart';

class SearchEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchEditState();
  }
}

class _SearchEditState extends State<SearchEditScreen> {
  bool isCloseVisible = false;
  TextEditingController controller=TextEditingController();
  List<String>listSuggestes=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                color: ThemeColor.baground,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    searchBar(),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14,),

              Container(
                width: 320.w,
                child: Textview(
                  title: S().recent_search,
                  TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),

          Expanded(
            child: ListView.builder(

                itemCount: listSuggestes.length,
                itemBuilder: (BuildContext context, int index) {
                  return searchIteam(listSuggestes[index]);
                }),
          )

            ],
          ),
        ),
      ),
    );
  }

  searchBar() {
    return Container(
      width: 335.w,
      height: 40.h,
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              Images.arrow_back,
              height: 24.h,
              width: 24.w,
            ),
          ),
          SizedBox(width: 8.w),
          Align(
            alignment: Alignment.center,
            child: textFiled(),
          ),
          SizedBox(width: 8.w),
          Spacer(),
          Visibility(
              visible: isCloseVisible,
              child: InkWell(
                onTap: (){
                  controller.clear();
                  setState(() {

                  });

                },
                child: SvgPicture.asset(
                  Images.close_circle,
                  height: 24.h,
                  width: 24.w,
                ),
              ))
        ],
      ),
    );
  }

  textFiled() {
    return Container(
      width: 250.w,
      height: 40.h,
      padding: EdgeInsets.only(top: 10.h),
      child: TextField(
         controller: controller,
        onChanged: (value) {
          if (value.length > 0) {
            isCloseVisible=true;
          } else {
            isCloseVisible=false;
          }
          setState(() {});
        },
        onSubmitted: (val)async{
          String lastSearch=await LocalSharePreferences().getString(AppConstant.RESENT_SEARCH);

          if(lastSearch!=null){
            print('the last search is $lastSearch');
            String value=val+","+lastSearch;
            LocalSharePreferences().setString(AppConstant.RESENT_SEARCH, value);
          }else{
            LocalSharePreferences().setString(AppConstant.RESENT_SEARCH, val);
          }
          Navigator.pushNamed(context, AppRoutes.searchresult,arguments: val);

        },
        textInputAction: TextInputAction.done,
        showCursor: true,
        cursorColor: ThemeColor.red,

        decoration: InputDecoration(
            hintText: S().search_here,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Color(0x662C363F),
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            )),

        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  searchIteam(String val){
    return Container(
      width: 375.w,
      height: 50.h,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0x192C363F)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, AppRoutes.searchresult,arguments: val);
              },
              child: Container(
                height: 18.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10.w,),
                    Text(
                     val,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,
                        height: 0,
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
  }



  getSuggestions()async{
    String lastSearch=await LocalSharePreferences().getString(AppConstant.RESENT_SEARCH);

    if(lastSearch!=null){
      listSuggestes=lastSearch.split(",");
      setState(() {

      });

    }
  }


}
