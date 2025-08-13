import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tkd_connect/screen/buy_sell/buy_sell_screen.dart';
import 'package:tkd_connect/screen/directory/directory_screen.dart';
import 'package:tkd_connect/screen/jobs/job_list_screen.dart';
import 'package:tkd_connect/screen/news/allNews.dart';
import 'package:tkd_connect/screen/report_incident/report_incident_list.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';

import '../../../constant/api_constant.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/images.dart';
import '../../../generated/l10n.dart';
import '../../../model/api_response.dart';
import '../../../model/response/AllCard.dart';
import '../../../model/response/userdata.dart';
import '../../../network/api_helper.dart';
import '../../../provider/dashboard/delete_interface.dart';
import '../../../provider/dashboard/home_screen_provider.dart';
import '../../../route/app_routes.dart';
import '../../../utils/colors.dart';
import '../../../utils/toast.dart';
import '../../../utils/utils.dart';
import '../../../widgets/button.dart';
import '../../../widgets/card/base_widgets.dart';
import '../../../widgets/card/dashboard_cards.dart';
import '../../../widgets/textview.dart';
import 'home_page.dart';

class NewHomeScreen extends StatelessWidget implements DeletePostInf{
  final List<_MenuItem> menuItems = [
    _MenuItem('Load Post', Icons.local_shipping, HomeScreen(),Images.new_load_post),
    _MenuItem('Finance', Icons.attach_money, HomeScreen(),Images.new_finance),
    _MenuItem('Insurance', Icons.verified_user, HomeScreen(),Images.new_insurane),
    _MenuItem('Toll Recharge', Icons.credit_card, HomeScreen(),Images.new_toll),
    _MenuItem('Check RTO Documents', Icons.insert_drive_file, HomeScreen(),Images.new_mParivahan),
    _MenuItem('Transport Directory', Icons.menu_book, DirectoryScreen(isBase:false),Images.new_transport_directory),
    _MenuItem('News', Icons.newspaper, AllNewsScreen(isBase: false,),Images.new_news),
    _MenuItem('Jobs', Icons.person, JobListScreen(),Images.new_jobs),
    _MenuItem('Buy/Sell Vehicles', Icons.directions_car, BuySellScreen(),Images.new_buy_sell),
  ];

  late HomeScreenProvider homeScreenProvider;
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeScreenProvider(context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    this.context=context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<HomeScreenProvider>(
          builder: (context, provider, child) {
            homeScreenProvider=provider;
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
              provider.filterisVisible ? const SizedBox() : filterBox(),
              provider.filterisVisible ? routeSelect() : const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16), // No top padding
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildMenuCard(context, item);
                  },
                ),
              ),

              // Report Incident Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ReportIncidentList()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Report Incident',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: AppConstant.FONTFAMILY,),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView.builder(
                        controller: provider.scrollController,
                        itemCount: provider.truckLoadTypeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            transform: Matrix4.translationValues(
                                0.0,-30.0.h, 0.0),
                            margin:
                            EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
                            child: setCardToList(index, provider,provider.truckLoadTypeList[index]),
                          );
                        }),
                  )),
            ],
          ),
        );}
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Incidents",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
              height: 0,
            ),),
          content: Text(
            "Report only verified cheating incidents to protect others in the transport community.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
              height: 0,
            ),),
          actions: [
            TextButton(
              child: Text("Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Continue",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.reportIncident);
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _pullRefresh() async {
    refreshHome();
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

      if(truckLoad.privatePost ==1){
        return AllCards().cardLoadPrivateHome(index, context, provider.truckLoadTypeList[index], provider.user.content!.first.id!,this,provider);

      }else{
        return AllCards().cardLoadHome(index, context, provider.truckLoadTypeList[index], provider.user.content!.first.id!,this,provider);

      }

    }else if(truckLoad.type=="Advertisement"){
      return AllCards().cardAdv(index, context, provider.truckLoadTypeList[index]);
    }
    else if(truckLoad.type=="Buy/Sell"){
      return AllCards().cardSellBuyPost(index, context, provider.truckLoadTypeList[index]);
    }
    else if(truckLoad.type=="Jobs"){
      return AllCards().cardJobPost(index, context, provider.truckLoadTypeList[index]);
    }
    else if(truckLoad.type=="General Post"){
      return AllCards().generalPost(truckLoad,context);
    }else{
      return AllCards().generalPost(truckLoad,context);
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
              filterIcon(),
              /* provider.filterisVisible ? SizedBox(
                width: 8.w,
              ):SizedBox.shrink(),
              provider.filterisVisible ?clearIcon():SizedBox.shrink()*/
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
              shape: const RoundedRectangleBorder(
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
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, AppRoutes.editprofile);
                      },
                      child: Column(
                        children: [
                          // SvgPicture.asset(
                          //   Images.profilepicture,
                          //   color: Colors.white,
                          //   width: 40.w,
                          //   height: 40.h,
                          // ),
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, AppRoutes.editprofile);
                            },
                            child:  BaseWidget().getImageclip(provider.imageUrl,
                                height: 40.h, width: 40.w),
                          ),

                          Container(
                            transform:
                            Matrix4.translationValues(0.0, -10.0.h, 0.0),
                            width: 42.w,
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
                                  Utils().getSelectedPackageImage(provider.ispaid),
                                  height: 8.h,
                                  width: 8.w,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  Utils().getSelectedPackageName(provider.ispaid),
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
                    ),
                    SizedBox(
                      width: 35.5.w,
                    ),
                    switchNewAppOldApp(),
                    SizedBox(
                      width: 10.5.w,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.report_problem_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        _showPopup(context);
                      },
                    ),
                    SizedBox(
                      width: 5.w,
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
                      width: 15.5.w,
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
                provider.filterisVisible ? filterBox() : const SizedBox(),
              ],
            ));
      },
    );
  }

  switchNewAppOldApp() {
    return SizedBox(
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
                side: BorderSide(width: 0.50.w, color: const Color(0x332C363F)),
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
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: provider.filterisVisible, // Ensure this flag exists in your provider
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        provider.onCloseFilter(context); // Ensure this method exists in your provider
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      provider.selectCityFromFilter(context);
                    },
                    child: fromRoute(provider.fromCity == "All" ? "From" : provider.fromCity),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      provider.selectToCityFilter(context);
                    },
                    child: fromRoute(provider.toCity == "All" ? "To" : provider.toCity),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: SvgPicture.asset(Images.route_return_home),
                  ),
                ),
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
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.40,
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
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
                            text: cityName,
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
            provider.drooDwonheading=="General Post " || provider.drooDwonheading=="Sell Buy Post" || provider.drooDwonheading=="Jobs"
                ?ToastMessage.show(context,"City filter is for load post only")
                :provider.onCliclFilter(context);
          },
          child: Container(
              width: 52.w,
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: const Color(0x332C363F)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  provider.filterisVisible?Images.close_circle:Images.filter,
                  height: 24.h,
                  width: 24.w,
                ),
              )),
        );
      },
    );
  }

  clearIcon() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            provider.onCloseFilter(context);
          },
          child: Container(
              width: 40.w,
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: const Color(0x332C363F)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Images.close_circle,
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
            side: BorderSide(width: 1.w, color: const Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: SizedBox(width: 265.w, child: dropDown()),
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
              child: SizedBox(
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
                  provider.drooDwonheading = 'Full load Required ';
                  provider.falseAllFilter();
                  provider.flr = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
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
                  provider.drooDwonheading = 'Part load required ';
                  provider.falseAllFilter();
                  provider.plr = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Part load required ',
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
                  provider.drooDwonheading = 'Full vehicle  required ';
                  provider.falseAllFilter();
                  provider.fla = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Full vehicle  required ',
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
                  provider.drooDwonheading = 'Part vehicle Required ';
                  provider.falseAllFilter();
                  provider.pla = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Part vehicle Required ',
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
                  provider.drooDwonheading = 'General Post ';
                  provider.falseAllFilter();
                  provider.gp = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'General Post ',
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
                  provider.drooDwonheading = 'Sell Buy Post';
                  provider.falseAllFilter();
                  provider.buy_sell = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Sell Buy Post',
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
                  provider.drooDwonheading = 'Jobs ';
                  provider.falseAllFilter();
                  provider.jobs = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Jobs ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ))
          ],
        );
      },
    );
  }
  refreshHome(){
    homeScreenProvider.callDashboradApi(context,0);
  }

  @override
  void deleteOwnPost(int postId,int index,) {
    _showMyDialog(index, postId,homeScreenProvider);
  }


  Future<void> _showMyDialog(int index,int id,HomeScreenProvider myPostProvider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S().deleteMsg,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(S().delete,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () {
                myPostProvider.deletePost(index,id,context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(S().no,style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void refreshHomeScreen() {

    refreshHome();
  }



  callInsuranceApi(String enquiry) async {
    String url = ApiConstant.INSURANCE_API;
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    Map<String,dynamic> data = {
      "date": "",
      "id": 0,
      "requirement": "I AM INTERESTED IN GETTING A GOOD DEAL FOR Insurance Inquiry.",
      "userId": user.content![0].id
    };
    ApiResponse response=await ApiHelper().postParameter(url, data);
    print('the resopnse is ${response.status}');
    if(response.status==200){
      ToastMessage.show(context, "Insurance Enquiry submitted successfully!");
      Navigator.pop(context);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  callFinanceApi(String enquiry) async {
    String url = ApiConstant.FINANCE_API;
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    Map<String,dynamic> data = {
      "date": "",
      "id": 0,
      "requirement": "I AM INTERESTED IN GETTING A GOOD DEAL FOR Finance Inquiry.",
      "userId": user.content![0].id
    };
    ApiResponse response=await ApiHelper().postParameter(url, data);
    print('the resopnse is ${response.status}');
    if(response.status==200){
      ToastMessage.show(context, "Finance Enquiry submitted successfully!");
      Navigator.pop(context);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  callMParivahan() async {
    String url = ApiConstant.MPARIVAHAN;
    print(url);
    final response = await http.get(Uri.parse(url));

    print('The response status is ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if(jsonResponse['message']=="success"){
        // ToastMessage.show(context, jsonResponse['url']);
        debugPrint(jsonResponse['url']);
        Utils().callDynamicUrl(context,jsonResponse['url']);
      }else{
        ToastMessage.show(context, jsonResponse['message']+"Something went wrong!!");
      }
      //  Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  callTollCalculation() async {
    String url = ApiConstant.TOLL_CALCULATION;
    print(url);
    final response = await http.get(Uri.parse(url));

    print('The response status is ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if(jsonResponse['message']=="success"){
        //  ToastMessage.show(context, jsonResponse['url']);
        debugPrint(jsonResponse['url']);
        Utils().callDynamicUrl(context,jsonResponse['url']);
      }else{
        ToastMessage.show(context, jsonResponse['message']+"Something went wrong!!");
      }
      //Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: InkWell(

        onTap: (){
          if(item.title=="Check RTO Documents"){
            callMParivahan();
          }else if(item.title=="Toll Recharge"){
            callTollCalculation();
          }else  if(item.title=="Insurance"){
            showInsuranceDialog(context,"Insurance enquiry");
          }else  if(item.title=="Finance"){
            showInsuranceDialog(context,"Finance enquiry");
          }else{
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.screen));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(item.icon, size: 36, color: Colors.orange),
              SvgPicture.asset(
                item.image,
                height: 30.h,
                width: 35.w,
              ),
              SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,fontFamily: GoogleFonts.poppins().fontFamily),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showInsuranceDialog(BuildContext context, String enquiry) async {
    final TextEditingController _reasonController = TextEditingController();
    bool enable = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "I AM INTERESTED IN GETTING A GOOD DEAL FOR ${enquiry.toUpperCase()}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel',style: TextStyle(color: ThemeColor.red),),
                ),
                Button(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 40.h,
                  title: S().submit,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                  onClick: () {
                    if ("Insurance enquiry" == enquiry) {
                      callInsuranceApi(_reasonController.text);
                    } else {
                      callFinanceApi(_reasonController.text);
                    }
                  },
                  isEnbale: true,
                ),
              ],
            );
          },
        );
      },
    );
  }

}

class _MenuItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final String image;
  _MenuItem(this.title, this.icon, this.screen,this.image);
}

