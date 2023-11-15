import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../constant/images.dart';

class MessageScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MessageScreenState();
  }

}
class _MessageScreenState extends State<MessageScreen>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       child: Column(
         children: [
           top_bar(context),
           serachBar(),
           tabBar(),
           SizedBox(height: 16.h,),
           itemMessage(),
           itemMessage1(),
           itemMessage2(),
           itemMessage3(),
         ],
       ),
     ),
   );
  }


  top_bar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 87.h,
      //padding: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Color(0xFFC3262C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: SizedBox(),
    );
  }


  serachBar(){
    return Container(
      transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
      margin: EdgeInsets.only(right: 20.w,left: 20.w),
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
                                hintText: "Search users & messages",

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

  tabBar(){
    return Container(
      width: 335.w,
      height: 32.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: ShapeDecoration(
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
                    'All messages',
                    style: TextStyle(
                      color: Color(0xCC001E49),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
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
                    'Favourites',
                    style: TextStyle(
                      color: Color(0xCC001E49),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
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


  itemMessage(){
    return Container(
      width: 375.w,
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0x192C363F)),
          top: BorderSide(color: Color(0x192C363F)),
          right: BorderSide(color: Color(0x192C363F)),
          bottom: BorderSide(width: 1, color: Color(0x192C363F)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 33.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: ShapeDecoration(
                      color: Color(0x14001E49),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Positioned(
                              //   left: 4.w,
                              //   top: 2.h,
                              //   child: Text(
                              //     'RS',
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       color: Color(0xFFC3262C),
                              //       fontSize: 18,
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w600,
                              //       height: 0,
                              //     ),
                              //   ),
                              // ),
                              // Positioned(
                              //   left: -0.80,
                              //   top: -6.40,
                              //   child: Container(
                              //     height: 48.80.h,
                              //     padding: const EdgeInsets.only(top: 4, left: 0.80, right: 1.60),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Container(
                              //           width: 32.w,
                              //           height: 44.80.h,
                              //           decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //               image: NetworkImage("https://via.placeholder.com/32x45"),
                              //               fit: BoxFit.fill,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              BaseWidget().getImage("",height: 32.h,width: 32.w)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Dileepa BM',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet',
                            style: TextStyle(
                              color: Color(0x99001E49),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 129),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '15:21',
                  style: TextStyle(
                    color: Color(0xFFC3262C),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFFC3262C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '15',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  itemMessage1(){
    return Container(
      width: 375.w,
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0x192C363F)),
          top: BorderSide(color: Color(0x192C363F)),
          right: BorderSide(color: Color(0x192C363F)),
          bottom: BorderSide(width: 1, color: Color(0x192C363F)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 33.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: ShapeDecoration(
                      color: Color(0x14001E49),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Positioned(
                              //   left: 4.w,
                              //   top: 2.h,
                              //   child: Text(
                              //     'RS',
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       color: Color(0xFFC3262C),
                              //       fontSize: 18,
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w600,
                              //       height: 0,
                              //     ),
                              //   ),
                              // ),
                              // Positioned(
                              //   left: -0.80,
                              //   top: -6.40,
                              //   child: Container(
                              //     height: 48.80.h,
                              //     padding: const EdgeInsets.only(top: 4, left: 0.80, right: 1.60),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Container(
                              //           width: 32.w,
                              //           height: 44.80.h,
                              //           decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //               image: NetworkImage("https://via.placeholder.com/32x45"),
                              //               fit: BoxFit.fill,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              BaseWidget().getImage("",height: 32.h,width: 32.w)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Vinit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet',
                            style: TextStyle(
                              color: Color(0x99001E49),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 129),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '10:21',
                  style: TextStyle(
                    color: Color(0xFFC3262C),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFFC3262C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '1',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  itemMessage2(){
    return Container(
      width: 375.w,
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0x192C363F)),
          top: BorderSide(color: Color(0x192C363F)),
          right: BorderSide(color: Color(0x192C363F)),
          bottom: BorderSide(width: 1, color: Color(0x192C363F)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 33.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: ShapeDecoration(
                      color: Color(0x14001E49),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Positioned(
                              //   left: 4.w,
                              //   top: 2.h,
                              //   child: Text(
                              //     'RS',
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       color: Color(0xFFC3262C),
                              //       fontSize: 18,
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w600,
                              //       height: 0,
                              //     ),
                              //   ),
                              // ),
                              // Positioned(
                              //   left: -0.80,
                              //   top: -6.40,
                              //   child: Container(
                              //     height: 48.80.h,
                              //     padding: const EdgeInsets.only(top: 4, left: 0.80, right: 1.60),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Container(
                              //           width: 32.w,
                              //           height: 44.80.h,
                              //           decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //               image: NetworkImage("https://via.placeholder.com/32x45"),
                              //               fit: BoxFit.fill,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              BaseWidget().getImage("",height: 32.h,width: 32.w)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Amit Gujarthi',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Test',
                            style: TextStyle(
                              color: Color(0x99001E49),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 129),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Yestrday',
                  style: TextStyle(
                    color: Color(0xFFC3262C),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFFC3262C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '1',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  itemMessage3(){
    return Container(
      width: 375.w,
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0x192C363F)),
          top: BorderSide(color: Color(0x192C363F)),
          right: BorderSide(color: Color(0x192C363F)),
          bottom: BorderSide(width: 1, color: Color(0x192C363F)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 33.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: ShapeDecoration(
                      color: Color(0x14001E49),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Positioned(
                              //   left: 4.w,
                              //   top: 2.h,
                              //   child: Text(
                              //     'RS',
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       color: Color(0xFFC3262C),
                              //       fontSize: 18,
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.w600,
                              //       height: 0,
                              //     ),
                              //   ),
                              // ),
                              // Positioned(
                              //   left: -0.80,
                              //   top: -6.40,
                              //   child: Container(
                              //     height: 48.80.h,
                              //     padding: const EdgeInsets.only(top: 4, left: 0.80, right: 1.60),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       crossAxisAlignment: CrossAxisAlignment.center,
                              //       children: [
                              //         Container(
                              //           width: 32.w,
                              //           height: 44.80.h,
                              //           decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //               image: NetworkImage("https://via.placeholder.com/32x45"),
                              //               fit: BoxFit.fill,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              BaseWidget().getImage("",height: 32.h,width: 32.w)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Darshan Joshi',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'new one',
                            style: TextStyle(
                              color: Color(0x99001E49),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 129),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Yestrday',
                  style: TextStyle(
                    color: Color(0xFFC3262C),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFFC3262C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '2',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}