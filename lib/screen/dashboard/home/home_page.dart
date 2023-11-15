import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/dashboard/home_screen_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';
import '../../../model/response/AllCard.dart';
import '../../../widgets/card/base_widgets.dart';
import '../../../widgets/card/dashboard_cards.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeScreenProvider(context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeScreenProvider>(
        builder: (context, provider, child) {
          return Container(
            color: ThemeColor.baground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 11.5.w,
                ),
                topBar(provider),
                SizedBox(
                  width: 11.5.w,
                ),
                provider.filterisVisible ? SizedBox() : filterBox(),
                provider.filterisVisible ? routeSelect() : SizedBox(),
               // listCard(),
            Expanded(
              child: ListView.builder(
                  controller: provider.scrollController,
                  itemCount: provider.truckLoadTypeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin:
                      EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
                      child: setCardToList(index, provider,provider.truckLoadTypeList[index]),
                    );
                  })),

              ],
            ),
          );
        },
      ),
    );
  }

  listCard() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
              controller: provider.scrollController,
              itemCount: provider.truckLoadTypeList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin:
                      EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
                  child: setCardToList(index, provider,provider.truckLoadTypeList[index]),
                );
              }),
        );
      },
    );
  }

  setCardToList(int index,HomeScreenProvider provider,TruckLoad truckLoad){
    if(truckLoad.type=="Full Load" || truckLoad.type=="Part Load"){
     return AllCards().cardLoad(index, context, provider.truckLoadTypeList[index]);
    }else if(truckLoad.type=="General Post"){
      return AllCards().generalPost(truckLoad);
    }else{
      return AllCards().generalPost(truckLoad);
    }
  }

  filterBox() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return Container(
          transform: Matrix4.translationValues(
              0.0, provider.filterisVisible ? 00 : -25.0.h, 0.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //dropDown(),
              popUpmenu((p0) => () {}, context),
              SizedBox(
                width: 8.w,
              ),
              filterIcon()
            ],
          ),
        );
      },
    );
  }

  topBar(HomeScreenProvider provider) {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return Container(
            width: 375.w,
            height: provider.filterisVisible ? 202.h : 136.h,
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            decoration: ShapeDecoration(
              color: ThemeColor.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        // SvgPicture.asset(
                        //   Images.profilepicture,
                        //   color: Colors.white,
                        //   width: 40.w,
                        //   height: 40.h,
                        // ),
                        BaseWidget().getImage(provider.imageUrl,
                            height: 40.h, width: 40.w),
                        Container(
                          transform:
                              Matrix4.translationValues(0.0, -10.0.h, 0.0),
                          width: 36.w,
                          height: 12.h,
                          padding: EdgeInsets.symmetric(horizontal: 4.h),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Images.pearls_blue,
                                height: 8.h,
                                width: 8.w,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                'Blue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.sp,
                                  fontFamily: AppConstant.FONTFAMILY,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 55.5.w,
                    ),
                    switchNewAppOldApp(),
                    SizedBox(
                      width: 22.5.w,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.search);
                      },
                      child: SvgPicture.asset(
                        Images.search_normal,
                        color: Colors.white,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    SizedBox(
                      width: 22.5.w,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.notificationlist);
                      },
                      child: SvgPicture.asset(
                        Images.notification,
                        color: Colors.white,
                        width: 24.w,
                        height: 24.h,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: provider.filterisVisible ? 16 : 0,
                ),
                provider.filterisVisible ? filterBox() : SizedBox(),
              ],
            ));
      },
    );
  }

  switchNewAppOldApp() {
    return Container(
      width: 136.w,
      height: 28.h,
      //clipBehavior: Clip.antiAlias,
      // decoration: ShapeDecoration(
      //   color: ThemeColor.border_grey,
      //   shape: RoundedRectangleBorder(
      //     side: BorderSide(color: ThemeColor.red),
      //     borderRadius: BorderRadius.circular(8.r),
      //   ),
      // ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            child: Expanded(
              child: Container(
                height: double.infinity,
                width: 68.w,
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: ThemeColor.border_grey),
                  ),
                ),
                child: Center(
                  child: Text(
                    'New app',
                    style: TextStyle(
                      color: ThemeColor.red,
                      fontSize: 10.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Visibility(
              visible: false,
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                decoration: ShapeDecoration(
                  color: ThemeColor.red,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: ThemeColor.border_grey),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Old app',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dropDown() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return Center(
          child: Container(
            width: 265.w,
            height: 52.h,
            //transform: Matrix4.translationValues(0.0, filterisVisible?00:-25.0.h, 0.0),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.50.w, color: Color(0x332C363F)),
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
                          child: Textview(
                            title: provider.drooDwonheading,
                            TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w400,
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
        );
      },
    );
  }

  routeSelect() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return Center(
          child: Container(
            transform: Matrix4.translationValues(0.0, -25.0.h, 00),
            width: 330.w,
            child: Stack(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () {
                        provider.selectCityFilter(context);
                      },
                      child: fromRoute(provider.fromCity),
                    )),
                Align(alignment: Alignment.bottomRight, child: fromRoute(provider.toCity)),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: SvgPicture.asset(Images.route_return_home))),
              ],
            ),
          ),
        );
      },
    );
  }

  fromRoute(String cityName) {
    return Container(
      width: 161.50.w,
      height: 52.h,
      //  transform: Matrix4.translationValues(20, 0.0.h, 0.0),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
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
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.40,
                  child: Container(
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
                          child: Stack(
                              children: [SvgPicture.asset(Images.location)]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$cityName',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w700,
                              height: 1.33,
                            ),
                          ),
                          TextSpan(
                            text: '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w400,
                              height: 1.33,
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
    );
  }

  filterIcon() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            provider.onCliclFilter(context);
          },
          child: Container(
              width: 52.w,
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x332C363F)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Images.filter,
                  height: 24.h,
                  width: 24.w,
                ),
              )),
        );
      },
    );
  }
  popUpmenu(Function(String) onMenuTap, BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton(
          position: PopupMenuPosition.values[1],
          constraints: BoxConstraints.tightFor(
            width: 265.w,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(width: 265.w, child: dropDown()),
          onSelected: (dynamic val) {
            //onMenuTap(val);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                // provider.changeDropDown("Login issue");
                provider.drooDwonheading = 'All routes requirement';
                provider.falseAllFilter();
                provider.notifyListeners();
                provider.applyDropDwonFilter(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      'All routes requirement',
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
                  provider.drooDwonheading = 'Full load available';
                  provider.falseAllFilter();
                  provider.fla = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
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
                  provider.drooDwonheading = 'Part load available ';
                  provider.falseAllFilter();
                  provider.pla = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
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
                  provider.drooDwonheading = 'Full load Vehicle available ';
                  provider.falseAllFilter();
                  provider.flr = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Full load Vehicle available ',
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
                  provider.drooDwonheading = 'Part Load Vehicle available ';
                  provider.falseAllFilter();
                  provider.plr = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Part Load Vehicle available ',
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
