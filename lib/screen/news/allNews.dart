import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/news/news_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/app_constant.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/allNewsResponse.dart';
import '../../model/response/transport_directory_search.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';
import '../../widgets/card/dashboard_cards.dart';
import '../../widgets/textview.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllNewsScreenState();
  }
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NewsProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: true,
        child: InkWell(
          onTap: ()async{
           await Navigator.pushNamed(context,AppRoutes.create_post);

          },
          child: Container(
            width: 155.w,
            height: 38.h,
            padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            decoration: ShapeDecoration(
              color: ThemeColor.theme_blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S().addNews,
                  style: TextStyle(
                    color: ThemeColor.progress_color,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: Stack(children: [
                          SvgPicture.asset(Images.add,height: 16.h,width: 16.w,)

                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          return Container(
            color: ThemeColor.baground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                top_bar(context,provider),
              SizedBox(height: 20.h,),
                allNewsTag(),
                provider.allNews.isEmpty && provider.isLoadDone?Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(S().noRecordFound),
                )):const SizedBox(),
                allNewsData()

              ],
            ),
          );
        },
      ),
    );
  }

  allNewsData() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child: ListView.builder(
                controller: provider.scrollControllerVertical,
                itemCount: provider.allNews.length,
                itemBuilder: (BuildContext context, int index) {
                  return newsItem(provider.allNews[index]);
                }),
          ),
        );
      },
    );
  }



  top_bar(BuildContext context, provider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 87.h,
      decoration: const ShapeDecoration(
        color: Color(0xFFC3262C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: searchBoxFilter(),
    );
  }

  searchBoxFilter() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Transform.translate(
          offset: Offset(0.0, 25.0.h), // Adjust as needed for vertical centering
          child: Center( // This ensures the search bar is centered
            child: serachBarFilter(),
          ),
        );
      },
    );
  }


  serachBar() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Container(
          transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
          margin: EdgeInsets.only(right: 20.w, left: 20.w),
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
                    side: const BorderSide(width: 0.50, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
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
                                SizedBox(
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
                              child: TextField(
                                controller: provider.searchController,
                                onChanged: (value) {
                                  provider.getBySearchData();
                                },
                                decoration: InputDecoration(
                                    hintText: S().searchUsersCompanies,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: const Color(0x662C363F),
                                      fontSize: 14.sp,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w400,
                                    )),
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
      },
    );
  }


  serachBarFilter() {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 260.w,
              height: 52.h,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0x332C363F)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
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
                              SizedBox(
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
                            child: TextField(
                              controller: provider.searchController,
                              onChanged: (value) {
                                provider.getBySearchData();
                              },
                              decoration: InputDecoration(
                                  hintText: S().searchNews,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: const Color(0x662C363F),
                                    fontSize: 14.sp,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w400,
                                  )),
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

          ],
        );
      },
    );
  }



  allNewsTag() {
    return Container(
      margin: EdgeInsets.only(left: 20.w,top: 0.h),
      child: Text(
        S().allNews,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
    );
  }

  newsItem(Content content) {
    return Consumer<NewsProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 375.w,
          //height: 67.h,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Color(0x192C363F)),
              top: BorderSide(color: Color(0x192C363F)),
              right: BorderSide(color: Color(0x192C363F)),
              bottom: BorderSide(width: 1, color: Color(0x192C363F)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Text(
                    "${content.topicName!}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                      height: 0,

                    ),

                  ),


                ],
              ),
              Container(
                child: Text(
                  content.description!,
                  style: TextStyle(
                    color: const Color(0x99001E49),
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              BaseWidget().image(image: content.image!),
              SizedBox(
                height: 0.h,
              ),
              Container(
                child: Text(
                  content.youtubeLink??"",
                  style: TextStyle(
                    color: const Color(0x99001E49),
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        );
      },
    );
  }











}
