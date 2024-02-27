import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/provider/dashboard/delete_interface.dart';
import 'package:tkd_connect/provider/dashboard/home_screen_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';
import '../../../generated/l10n.dart';
import '../../../model/response/AllCard.dart';
import '../../../utils/utils.dart';
import '../../../widgets/card/base_widgets.dart';
import '../../../widgets/card/dashboard_cards.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeScreen();
//   }
// }

// class _HomeScreen extends State<HomeScreen> {
class HomeScreen extends StatelessWidget implements DeletePostInf
{
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
                provider.filterisVisible ? SizedBox() : filterBox(),
                provider.filterisVisible ? routeSelect() : SizedBox(),
               // listCard(),
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
          );
        },
      ),
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
        return AllCards().cardLoadPrivateHome(index, context, provider.truckLoadTypeList[index], provider.user.content!.first.id!,this);

      }else{
        return AllCards().cardLoadHome(index, context, provider.truckLoadTypeList[index], provider.user.content!.first.id!,this);

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
                            width: 38.w,
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
                                  width: 2.w,
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
                       // provider.selectCityFilter(context);
                        provider.selectCityFromFilter(context);
                      },
                      child: fromRoute(provider.fromCity),
                    )),
                Align(alignment: Alignment.bottomRight, child: InkWell(
                  onTap: (){
                    provider.selectToCityFilter(context);
                  },
                  child: fromRoute(provider.toCity),
                )),
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
                  provider.drooDwonheading = 'Full vehicle  required ';
                  provider.falseAllFilter();
                  provider.flr = true;
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
                  provider.plr = true;
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
                  provider.drooDwonheading = 'Sell Buy Post ';
                  provider.falseAllFilter();
                  provider.buy_sell = true;
                  provider.notifyListeners();
                  provider.applyDropDwonFilter(context);
                },
                child: Row(
                  children: [
                    Text(
                      'Sell Buy Post ',
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
    if(homeScreenProvider!=null){
      homeScreenProvider.callDashboradApi(context,0);
    }
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

}
