import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/provider/mybids/my_bids_provider.dart';
import 'package:tkd_connect/screen/my_bids/placed_bid_screen.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import 'recived_bid_screen.dart';

class MyBidsBaseScreen extends StatefulWidget {
  const MyBidsBaseScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyBidsBaseScreenState();
  }
}

class _MyBidsBaseScreenState extends State<MyBidsBaseScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyBidsProvider>(
      create: (_) => MyBidsProvider("Ideal")..getReceviedBids(context,false), // Initial fetch
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<MyBidsProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              topBar(context),
             Container(
             transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
             child: popUpmenu((p0) => (){
          }, context)),
              _toggleBox(),


          Visibility(
            visible: !provider.isMyPlacedBids,
            child: Flexible(
              child: RecivedBidScreen(
                provider: provider,
              ),
            ),
          ),

              Visibility(
                visible: provider.isMyPlacedBids,
                child: Flexible(
                  child: PlacedBidScreen(
                    provider: provider,
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }



  Widget topBar(BuildContext context) {
    return Stack(
      children: [
        // ⬆ Red Background Header
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120.h,
          decoration: const ShapeDecoration(
            color: Color(0xFFC3262C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45.h),
              _appBarRow(context),

            ],
          ),
        ),


      ],
    );
  }

  Widget _appBarRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          SizedBox(width: 16.w),
          Text(
            "My Quotes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleBox() {
    return Consumer<MyBidsProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // ▢ Quotes You Received
              ChoiceChip(
                backgroundColor: Colors.transparent,
                selectedColor: ThemeColor.theme_blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: ThemeColor.theme_blue),
                ),
                label: Text(
                  S().quotesYouReceived,
                  style: TextStyle(
                    color: !provider.isMyPlacedBids
                        ? Colors.white
                        : Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: !provider.isMyPlacedBids,
                onSelected: (_) => provider.changeTab(),
              ),

              // ▢ Quotes You Placed
              ChoiceChip(
                backgroundColor: Colors.transparent,
                selectedColor: ThemeColor.theme_blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: ThemeColor.theme_blue),
                ),
                label: Text(
                  S().quotesYouPlaced,
                  style: TextStyle(
                    color: provider.isMyPlacedBids
                        ? Colors.white
                        : Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: provider.isMyPlacedBids,
                onSelected: (_) => provider.changeTab(),
              ),
            ],
          ),
        );
      },
    );
  }



  dropDwon() {
    return Consumer<MyBidsProvider>(
  builder: (context, provider, child) {
  return Container(
      //transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        side: const BorderSide(width: 1, color: Color(0x332C363F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    provider.selectedString,
                                    style: const TextStyle(
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
                              SizedBox(
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
  },
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
            side: BorderSide(width: 1.w, color: const Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: dropDwon()),
          onSelected: (dynamic val) {
            //onMenuTap(val);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                provider.changeDropDown("All bids",context);
              },
              child: SizedBox(
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
                  provider.changeDropDown("Full load required",context);
                },
                child: Row(
                  children: [
                    Text(
                      'Full load required ',
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
                  provider.changeDropDown("Part load required",context);
                },
                child: Row(
                  children: [
                    Text(
                      'Part load Required ',
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
                  provider.changeDropDown("Full vehicle required",context);

                },
                child: Row(
                  children: [
                    Text(
                      'Full vehicle required',
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
                  provider.changeDropDown("Part vehicle required ",context);
                },
                child: Row(
                  children: [
                    Text(
                      'Part vehicle required ',
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
