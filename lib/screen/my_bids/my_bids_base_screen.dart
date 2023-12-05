import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/provider/mybids/my_bids_provider.dart';
import 'package:tkd_connect/screen/my_bids/placed_bid_screen.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../widgets/card/base_widgets.dart';
import 'recived_bid_screen.dart';

class MyBidsBaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyBidsBaseScreenState();
  }
}

class _MyBidsBaseScreenState extends State<MyBidsBaseScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyBidsProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<MyBidsProvider>(
        builder: (context, provider, child) {
          return SafeArea(
              child: Column(
            children: [
              top_bar(context),
              //dropDwon(),
             Container(
                 transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
                 child: popUpmenu((p0) => (){

              }, context)),
              Visibility(
               visible: provider.isMyPlacedBids,
                child: Flexible(
                  child: PlacedBidScreen(
                    provider: provider,
                  ),
                ),
              ),

              Visibility(
                visible: !provider.isMyPlacedBids,
                child: Flexible(
                  child: RecivedBidScreen(
                    provider: provider,
                  ),
                ),
              ),



            ],
          ));
        },
      ),
    );
  }



  top_bar(BuildContext context) {
    return Consumer<MyBidsProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 137.h,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 92.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  SizedBox(height: 20.h,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(

                              onTap:() {
                                provider.changeTab();
                              },
                              child: Container(
                                height: 32.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Color(0x332C363F),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xCCC3262C)),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.h),
                                        decoration: ShapeDecoration(
                                          color: provider.isMyPlacedBids?Colors.white:Color(0xFF9D1C21),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0x332C363F)),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              S().quotesYouPlaced,
                                              style: TextStyle(
                                                color:provider.isMyPlacedBids? Color(0xFFC3262C):Colors.white,
                                                fontSize: 12,
                                                fontFamily: AppConstant.FONTFAMILY,
                                                fontWeight: provider.isMyPlacedBids?FontWeight.w600:FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ],
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.h),
                                          decoration: ShapeDecoration(
                                            color: provider.isMyPlacedBids?Color(0xFF9D1C21):Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Color(0x332C363F)),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                S().quotesYouReceived,
                                                style: TextStyle(
                                                  color:provider.isMyPlacedBids? Colors.white:Color(0xFFC3262C),
                                                  fontSize: 12,
                                                  fontFamily: AppConstant.FONTFAMILY,
                                                  fontWeight:provider.isMyPlacedBids? FontWeight.w400:FontWeight.w600,
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
          ),
        );
      },
    );
  }

  dropDwon() {
    return Container(
      //transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
                    height: 52.h,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0x332C363F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                child: SizedBox(
                                  child: Text(
                                    'All bids',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: 24.w,
                                height: 24.h,
                                child: Stack(children: [
                                  SvgPicture.asset(
                                    Images.dwon_arrow,
                                  )
                                ]),
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
          ),
        ],
      ),
    );
  }


  popUpmenu(Function(String) onMenuTap, BuildContext context) {
    return Consumer<MyBidsProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton(
          position: PopupMenuPosition.values[1],
          constraints:
          BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: dropDwon()),
          onSelected: (dynamic val) {
            //onMenuTap(val);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
               // provider.changeDropDown("Login issue");
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      'All bids',
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
            ),
            PopupMenuItem(
                onTap: () {
                 // provider.changeDropDown("App crash");
                },
                child: Row(
                  children: [
                    Text(
                      'Full load available',
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
                  //provider.changeDropDown("Registration");
                },
                child: Row(
                  children: [
                    Text(
                      'Part load available ',
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
                  //provider.changeDropDown("Registration");
                },
                child: Row(
                  children: [
                    Text(
                      'Full load Required ',
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
                  //provider.changeDropDown("Registration");
                },
                child: Row(
                  children: [
                    Text(
                      'Part Load Required ',
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
      },
    );
  }
}
