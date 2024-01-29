import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/search_provider/search_provider.dart';
import 'package:tkd_connect/screen/search/search_post_screen.dart';
import 'package:tkd_connect/screen/search/search_user_screen.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchVal;

  const SearchResultScreen({super.key, required this.searchVal});

  @override
  State<StatefulWidget> createState() {
    return _SearchResultScreen();
  }
}

class _SearchResultScreen extends State<SearchResultScreen> {
  bool isCloseVisible = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SearchProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                color: ThemeColor.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    searchBar(),
                    SizedBox(
                      height: 16.h,
                    ),
                    tabSearch(),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  return Visibility(
                      visible: provider.tabPost,
                      child: SearchPostScreen(
                        searchProvider: provider,
                        serach: widget.searchVal,
                      ));
                },
              ),
              Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  return Visibility(
                      visible: !provider.tabPost, child: SearchUserScreen(searchProvider: provider,serachVal: widget.searchVal,));
                },
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
            onTap: () {
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
                  Navigator.pop(context);
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
      child: Text(
        widget.searchVal,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  tabSearch() {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 335.w,
          height: 32.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0x332C363F),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.changeTab();
                  },
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    decoration: provider.tabPost?ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0x332C363F)),
                      ),
                    ): ShapeDecoration(
                      color: Color(0x19001E49),
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
                          'Posts',
                          style: provider.tabPost?TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ):TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    provider.changeTab();
                  },
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    decoration:
                    !provider.tabPost?ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0x332C363F)),
                      ),
                    ):
                    ShapeDecoration(
                      color: Color(0x19001E49),
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
                          'Users',
                          style: !provider.tabPost? TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ):TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
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
      },
    );
  }
}
