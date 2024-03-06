import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/request/comment_screen.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/dashboard/home_screen_provider.dart';
import 'package:tkd_connect/screen/general_post/post_comment_list.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/utils.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../route/app_routes.dart';
import '../textview.dart';

class BaseWidget {
  Widget profile(String profileLink, String name, String companyName,
      {int verify = 0}) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   width: 40.w,
                //   height: 40.h,
                //   child: Image.network(profileLink),
                // ),
                //getImage(profileLink,height: 40.h,width: 40.w)
                getImageclip(profileLink, height: 40.h, width: 40.w)
              ],
            ),
          ),
          SizedBox(width: 8.w),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Textview(
                                              title: name,
                                              TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Visibility(
                                                visible:
                                                    verify != 0 ? true : false,
                                                child: SvgPicture.asset(
                                                  Images.verified,
                                                  height: 12.h,
                                                  width: 12.w,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: companyName,
                                            TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 5,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    ),
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

  Widget profileWithUser(String profileLink, String name, String companyName,
      {int verify = 0, int transporterOrAgent = 0}) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   width: 40.w,
                //   height: 40.h,
                //   child: Image.network(profileLink),
                // ),
                //getImage(profileLink,height: 40.h,width: 40.w)
                getImageclip(profileLink, height: 40.h, width: 40.w)
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              // height: 52.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Textview(
                                              title: name,
                                              TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Visibility(
                                                visible:
                                                    verify != 0 ? true : false,
                                                child: SvgPicture.asset(
                                                  Images.verified,
                                                  height: 12.h,
                                                  width: 12.w,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: companyName,
                                            TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: Utils().getTranport(
                                                transporterOrAgent),
                                            TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 5,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    ),
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

  Widget profileDirectory(String profileLink, String name, String companyName,
      {int verify = 0}) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   width: 40.w,
                //   height: 40.h,
                //   child: Image.network(profileLink),
                // ),
                getImageclip(profileLink, height: 56.h, width: 40.w)
              ],
            ),
          ),
          SizedBox(width: 8.w),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Textview(
                                              title: name,
                                              TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Visibility(
                                                visible:
                                                    verify != 0 ? true : false,
                                                child: SvgPicture.asset(
                                                  Images.verified,
                                                  height: 12.h,
                                                  width: 12.w,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: companyName,
                                            TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 5,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    ),
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

  Widget routes(String fromCity, String toCity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: ShapeDecoration(
        color: Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              child: Text(
                fromCity,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xCC001E49),
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.arrow_circle_right_rounded,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: SizedBox(
              child: Text(
                toCity,
                style: TextStyle(
                  color: Color(0xCC001E49),
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget heading(String title, String date, String subTitle) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                           // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        color: Color(0x99001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
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

  Widget headingWithDescription(String title, String date, String field1,String field2,String field3,bool isJobPost) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isJobPost?"Experience : ":"Mfg Year : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              field1,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                        isJobPost?"Role : ":"Model : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              field2,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        isJobPost?SizedBox.shrink():Row(
                          children: [
                            Text(
                              "Price : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              field3,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget headingWithoutDate(String title, String subTitle) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        color: Color(0x99001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
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

  Widget bidButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(0);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().quotesNow,
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(Images.bid)
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget applyButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(0);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().applyNow,
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(Images.arrow_right)
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget getInTouchButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(2);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().getInTouch,
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Icon(Icons.call,size:15)
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget deleteButton(Function(int) onMenuTap,bool isOwnPost) {

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(10);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().delete,
                    style: TextStyle(
                      color: ThemeColor.red,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(Images.delete)
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(onTap: () {}, child: isOwnPost?popUpmenuForOwnPost(onMenuTap):popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget deleteMyPostButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(10);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().delete,
                    style: TextStyle(
                      color: ThemeColor.red,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(Images.delete)
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(onTap: () {}, child: popUpmenuOwnPost(onMenuTap))
        ],
      ),
    );
  }

  Widget buyOnlyDeleteButton(Function(int) onMenuTap, bool isDeleteVisible) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: isDeleteVisible,
            child: InkWell(
              onTap: () {
                onMenuTap(10);
              },
              child: Container(
                height: 38.h,
                width: 253.w,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().delete,
                      style: TextStyle(
                        color: ThemeColor.red,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(Images.delete)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget buyDeleteButton(Function(int) onMenuTap, bool isDeleteVisible) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: isDeleteVisible,
            child: InkWell(
              onTap: () {
                onMenuTap(10);
              },
              child: Container(
                height: 38.h,
                width: 253.w,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S().delete,
                      style: TextStyle(
                        color: ThemeColor.red,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(Images.delete)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget showBidButton(Function(int) onMenuTap, bool isBid) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(0);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().showAllQuotes,
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
              onTap: () {},
              child: isBid
                  ? popUpmenuOwnBid(onMenuTap)
                  : popUpmenuOwnPost(onMenuTap))
        ],
      ),
    );
  }

  popUpmenuOwnPost(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.w, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Images.delete,
                color: Colors.black,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 12.w,
              ),
              Text(
                S().delete,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13.w,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().share,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  Widget showBidRepostButton(Function(int) onMenuTap, bool isBid) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(0);
            },
            child: Container(
              height: 38.h,
              width: 253.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S().showAllQuotes,
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
              onTap: () {},
              child: isBid
                  ? popUpmenuOwnBid(onMenuTap)
                  : popUpmenuOwnRepostPost(onMenuTap))
        ],
      ),
    );
  }

  popUpmenuOwnRepostPost(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.w, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Images.delete,
                color: Colors.black,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 12.w,
              ),
              Text(
                S().delete,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13.w,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().share,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(4);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().Re_post,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenuOwnBid(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.w, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().share,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenuForOwnPost(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.w, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Images.message,
                color: Colors.black,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 12.w,
              ),
              Text(
                S().chat,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13.w,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(2);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.call_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().call,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().share,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(4);
            },
            child: Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.black,
                  size: 20.w,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().rating,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(5);
            },
            child: Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.black,
                  size: 20.w,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().re_post,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(6);
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                  size: 20.w,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().edit,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenu(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.w, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Images.message,
                color: Colors.black,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 12.w,
              ),
              Text(
                S().chat,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13.w,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(2);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.call_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().call,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20.w,
                  height: 20.h,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().share,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(4);
            },
            child: Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.black,
                  size: 20.w,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  S().rating,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),

      ],
    );
  }

  Widget onlyBidButton(Function onTab) {
    return InkWell(
      onTap: () {
        onTab();
      },
      child: Container(
        height: 38.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S().withdrawQuotes,
              style: TextStyle(
                color: Color(0xFF001E49),
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget image({String image = ""}) {
    // return Container(
    //   width: 311.w,
    //   height: 200.h,
    //   decoration: ShapeDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //         image,
    //       ),fit: BoxFit.fill,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => SvgPicture.asset(Images.logo),
        errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
              fit: BoxFit.fill,
              width: 311.w,
              height: 200.h,
            )),
        fit: BoxFit.fill,
        width: 311.w,
        height: 200.h,
      ),
    );
  }

  Widget imageLink(String link) {
    // return Container(
    //   width: 311.w,
    //   height: 200.h,
    //   decoration: ShapeDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //           link),
    //       fit: BoxFit.fill,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );

    return image(image: link);
  }

  Widget carouseImage(List<String?> imgList) {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        padEnds: false,
        pageSnapping: false,
        enableInfiniteScroll: false,
      ),
      items: imgList
          .map((item) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: imageLink(item!)),
                ),
              ))
          .toList(),
    ));
  }

  Widget carouseImageDelete(List<String?> imgList, Function(String) onDelete) {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        padEnds: false,
        pageSnapping: false,
        enableInfiniteScroll: false,
      ),
      items: imgList
          .map((item) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Center(child: imageLinkDelete(item!)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            onDelete(item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              Images.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
          .toList(),
    ));
  }

  Widget imageLinkDelete(String link) {
    // return Container(
    //   width: 311.w,
    //   height: 200.h,
    //   decoration: ShapeDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //           link),
    //       fit: BoxFit.fill,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );

    return image(image: link);
  }

  Widget likeComment(TruckLoad truckLoad,BuildContext context,
      {int likeCount = 0, int commentCount = 0}) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.commentscreen,
            arguments: truckLoad);
      },
      child: Container(
        height: 20.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 155.50.w,
              height: 18.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16.w,
                    height: 16.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // provider.likeIncreamentApi(truckLoad.id!, context);
                            Navigator.pushNamed(context, AppRoutes.commentscreen,
                                arguments: truckLoad);
                          },
                          child: Container(
                            width: 16.w,
                            height: 16.h,
                            child: Stack(
                                children: [SvgPicture.asset(Images.like)]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          S().like,
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        // Text(
                        //   '( ${likeCount} )',
                        //   style: TextStyle(
                        //     color: Color(0xFF001E49),
                        //     fontSize: 12.sp,
                        //     fontFamily: GoogleFonts.poppins().fontFamily,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.commentscreen,
                    arguments: truckLoad);
              },
              child: Container(
                width: 155.50.w,
                height: 18.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.h,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 16.w,
                            height: 16.h,
                            child: Stack(
                                children: [SvgPicture.asset(Images.message)]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            S().comment,
                            style: TextStyle(
                              color: Color(0xFF001E49),
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          // Text(
                          //   '( ${commentCount} )',
                          //   style: TextStyle(
                          //     color: Color(0xFF001E49),
                          //     fontSize: 12.sp,
                          //     fontFamily: GoogleFonts.poppins().fontFamily,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget likeCommentDetails(TruckLoad truckLoad,BuildContext context,Function onTabLikeCount,
      {int likeCount = 0, int commentCount = 0}) {
    return Container(
      height: 20.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 155.50.w,
            height: 18.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 16.w,
                  height: 16.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // provider.likeIncreamentApi(truckLoad.id!, context);
                          onTabLikeCount();

                        },
                        child: Container(
                          width: 16.w,
                          height: 16.h,
                          child: Stack(
                              children: [SvgPicture.asset(Images.like)]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  child: InkWell(
                    onTap: (){
                      print('this is like ');
                      onTabLikeCount();

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          S().like,
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '( ${likeCount} )',
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.commentscreen,
                  arguments: truckLoad);
            },
            child: Container(
              width: 155.50.w,
              height: 18.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16.w,
                    height: 16.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          child: Stack(
                              children: [SvgPicture.asset(Images.message)]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          S().comment,
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '( ${commentCount} )',
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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

  getImage(String src, {double? height, double? width}) {
    return src == ""
        ? Container(
            width: height == null ? 35 : height,
            height: width == null ? 35 : width,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/my_profile.png'))))
        : Container(
            width: height == null ? 35 : height,
            height: width == null ? 35 : width,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
                image: new DecorationImage(
                    fit: BoxFit.contain, image: NetworkImage(src))));
  }

  getGroupImage(String src, {double? height, double? width}) {
    return src == "string"
        ? Container(
        width: height == null ? 35 : height,
        height: width == null ? 35 : width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
         ),
      child:Icon(Icons.group_outlined,color: Colors.grey,)
    )
        : Container(
        width: height == null ? 35 : height,
        height: width == null ? 35 : width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
            image: new DecorationImage(
                fit: BoxFit.contain, image: NetworkImage(src))));
  }

  getImageclip(String src, {double? height, double? width}) {
    return src == ""
        ? Container(
            width: height == null ? 35 : height,
            height: width == null ? 35 : width,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/my_profile.png'))))
        : CircleAvatar(
            radius: width == null ? 35 : width / 2,
            backgroundColor: Colors.white,
            // borderRadius: BorderRadius.circular(width==null?35:width),

            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: src,
                placeholder: (context, url) =>
                    Image.asset("assets/images/my_profile.png"),
                fit: BoxFit.cover,
                width: height == null ? 35 : height,
                height: width == null ? 35 : width,
              ),
            ),
          );
  }

  appBar(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.w),
      height: 50.h,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: textFiled(title),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                Images.arrow_back,
                height: 24.h,
                width: 24.w,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  appBarSearchFilter(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: 20.w),

      height: 50.h,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: textFiled(title),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: SvgPicture.asset(
                  Images.arrow_back,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //SvgPicture.asset(Images.search_normal),
                SizedBox(width: 20.w),
                // SvgPicture.asset(Images.filter),
                SizedBox(width: 20.w),
              ],
            ),
          )
        ],
      ),
    );
  }

  textFiled(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget jobHeading(String fromCity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: ShapeDecoration(
        color: Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              child: Text(
                fromCity,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xCC001E49),
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
