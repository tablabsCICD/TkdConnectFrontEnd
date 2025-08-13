import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/card/dashboard_cards.dart';
import 'package:tkd_connect/widgets/textview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/transport_directory_search.dart';
import '../../provider/directory/directory_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';

class DirectoryScreen extends StatefulWidget {
  bool? isBase;
  DirectoryScreen({super.key,required this.isBase});

  @override
  State<StatefulWidget> createState() {
    return _DirectoryScreenState();
  }
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DirectoryProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<DirectoryProvider>(
  builder: (context, provider, child) {
  return Container(
        color: ThemeColor.baground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            top_bar(context,provider),
            //serachBar(),
            provider.filterisVisible ? const SizedBox(): searchBoxFilter(),
            provider.filterisVisible ? routeSelect() : const SizedBox(),
            allUserTag(),
            provider.user.isEmpty && provider.isLoadDone?Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(S().noRecordFound),
            )):const SizedBox(),
            allUserData()

          ],
        ),
      );
  },
),
    );
  }

  allUserData() {
    return Consumer<DirectoryProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child: ListView.builder(
                controller: provider.scrollControllerVertical,
                itemCount: provider.user.length,
                itemBuilder: (BuildContext context, int index) {
                  return
                    provider.user[index].type=="Directory"?
                    userItem(provider.user[index]):cardAdv(index,context,provider.user[index]);
                }),
          ),
        );
      },
    );
  }

  //not in use now
  verifyUserData() {
    return Consumer<DirectoryProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 185.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
              controller: provider.scrollControllerHorizantal,
              itemCount: provider.userVerify.length,
              itemBuilder: (BuildContext context, int index) {
                return itemVerified(provider.userVerify[index]);
              }),
        );
      },
    );
  }

  top_bar(BuildContext context,provider) {
    return Container(
      width: MediaQuery.of(context).size.width,
     // height: 87.h,
      height: provider.filterisVisible ? 170.h : 87.h,
      //padding: const EdgeInsets.only(bottom: 16),
      decoration: const ShapeDecoration(
        color: Color(0xFFC3262C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: Row(
        children: [
          widget.isBase==false?IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)):SizedBox.shrink(),

          provider.filterisVisible ? searchBoxFilter(): const SizedBox(),
        ],
      )
    );
  }

  searchBoxFilter() {
    return Consumer<DirectoryProvider>(
      builder: (context, provider, child) {
        return Container(
          transform: Matrix4.translationValues(
              0.0, provider.filterisVisible ? 00 : -25.0.h, 0.0),
          width: MediaQuery.of(context).size.width,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              serachBarFilter(),
              SizedBox(
                width: 8.w,
              ),

              filterIcon(),

            ],
          ),
        );
      },
    );
  }

  serachBar() {
    return Consumer<DirectoryProvider>(
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
    return Consumer<DirectoryProvider>(
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

          ],
        );
      },
    );
  }

  tabBar() {
    return Container(
      width: 335.w,
      height: 32.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0x332C363F),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x332C363F)),
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
              decoration: const ShapeDecoration(
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
                    S().myRoutes,
                    style: const TextStyle(
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
              decoration: const ShapeDecoration(
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
                    S().allRoutes,
                    style: const TextStyle(
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

  tagVerifiedUser() {
    return Container(
      margin: EdgeInsets.only(right: 20.w, left: 20.w),
      child: Row(
        children: [
          Textview(
            title: S().verifiedUsers,
            TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          SvgPicture.asset(Images.verified)
        ],
      ),
    );
  }


  cityTag(String tag) {
    return Container(
      height: 26.w,
      transform: Matrix4.translationValues(0.0, -20.0.h, 00),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tag,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xCC001E49),
              fontSize: 12.sp,
              fontFamily: AppConstant.FONTFAMILY,
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }

  itemVerified(TransportSearchData data) {
    return Container(
      width: 335.w,
     // height: 130.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x114A5568),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 38.w,
              height: 38.h,
              child: InkWell(
                onTap: (){
                  Utils().callFunction(data.mobileNumber.toString());
                },
                child: SvgPicture.asset(
                  Images.call,
                  height: 38.h,
                  width: 38.w,
                ),
              ),
            ),
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().profileDirectory(data.profilePicture!, "${data.firstName!} ${data.lastName!}", data.companyName!,verify: data.isPaid!)),


          //cityTag("Tag"),
          cityChip(data),
          buttonViewProfile(data),

        ],
      ),
    );
  }

  cityChip(TransportSearchData data){
    List<Widget>list=[];
    int length=data.listOfPreferredRoutes.length;
    if(length >2){
      length=2;
    }
    for(int i=0;i<length;i++){
      list.add(cityTag(data.listOfPreferredRoutes[i].routeSource!));
      list.add(cityTag(data.listOfPreferredRoutes[i].routeDestination!));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: list,
    );
  }

  buttonViewProfile(TransportSearchData data) {
    return InkWell(
      onTap: () {

        Navigator.pushNamed(context, AppRoutes.viewprofiledirectory,arguments: data);
      },
      child: Container(
        width: 291.w,
        height: 38.h,
        transform: Matrix4.translationValues(0.0, -10.0.h, 00),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0x33001E49)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S().viewProfile,
              style: const TextStyle(
                color: Color(0xFF001E49),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  allUserTag() {
    return Container(
      margin: EdgeInsets.only(left: 20.w,top: 0.h),
      child: Text(
        S().allUsers,
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

  userItem(TransportSearchData user) {
    return Consumer<DirectoryProvider>(
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseWidget().getImage(user.profilePicture!,
                          height: 32.h, width: 32.w),
                      SizedBox(
                        width: 14.5.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${user.firstName!} ${user.lastName!}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  height: 0,

                                ),

                              ),
                              SizedBox(width: 4.w,),
                              Visibility(visible: user.isPaid !=0?true:false,child: SvgPicture.asset(Images.verified,height: 12.h,width: 12.w,))

                            ],
                          ),
                          Container(
                            child: Text(
                              user.companyName!,
                              style: TextStyle(
                                color: const Color(0x99001E49),
                                fontSize: 10.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
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
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      
                      provider.getDetailsOfUserDirectory(user.id!,context);
                      //Navigator.pushNamed(context, AppRoutes.viewprofiledirectory,arguments: user);

                    },
                    child: SvgPicture.asset(Images.profilepicture)),
                SizedBox(width: 12.w),
                InkWell(
                    onTap: () {
                      Utils().callFunction("${user.mobileNumber}");
                    },
                    child: SvgPicture.asset(Images.call)),
              ],
            ),
          ),
        ],
      ),
    );
  },
);
  }



  routeSelect() {
    return Consumer<DirectoryProvider>(
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
                        margin: const EdgeInsets.only(top: 5),
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
    return Consumer<DirectoryProvider>(
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
                  side: BorderSide(width: 0.50.w, color: const Color(0x332C363F)),
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


  cardAdv(int index, BuildContext context, TransportSearchData load, {int userId = 0}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => imageDialogAdd(
                load.companyName, load.images!.first, context, load),
          );
        },
        child: Container(
          width: 335.w,
          // height: 255.h,
          padding: EdgeInsets.all(12.r),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x114A5568),
                blurRadius: 8.r,
                offset: const Offset(0, 3),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 100.w,
                  height: 18.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9462A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r)),
                  ),
                  child: Center(
                    child: Text(
                      load.type!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.w),
              imageLoad(load),

              InkWell(
                onTap: () async {
                  final url = Uri.parse(
                    // 'http://${load.website}',
                      '${load.website}');
                  await launchUrl(url);
                },
                child: BaseWidget().headingMobile(load.companyName!, load.mobileOrLandline.toString(), load.website!),
              ),
            ],
          ),
        ),
      ),
    );
  }


  imageLoad(TransportSearchData load) {
    if (load.images!.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 0.h,
          ),
        ],
      );
    } else if (load.images!.length == 1) {
      return Column(
        children: [
          BaseWidget().image(image: load.images!.first),
          SizedBox(
            height: 9.h,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget()
                  .carouseImage(List<String>.from(load.images!))),
          SizedBox(
            height: 9.h,
          ),
        ],
      );
    }
  }


  Widget imageDialogAdd(text, path, context, load) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          imageLoadAddA(load, context),
        ],
      ),
    );
  }

  imageLoadAddA(TransportSearchData load, BuildContext context) {
    if (load.images!.isEmpty) {
      return const Column(
        children: [
          SizedBox(
            height: 0,
          ),
        ],
      );
    } else if (load.images!.length == 1) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: load.images!.first,
              placeholder: (context, url) =>
                  SvgPicture.asset("logo.svg"),
              errorWidget: (context, url, error) => ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.height - 100,
                  )),
              fit: BoxFit.fill,
              width: 500.w,
              height: 500.h,
            ),
          ),
          const SizedBox(
            height: 9,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: Container(
                  child:/* CarouselSlider(
                    options: CarouselOptions(
                      padEnds: false,
                      pageSnapping: false,
                      enableInfiniteScroll: false,
                    ),
                    items: load.images!
                        .map((item) => Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: AllCards().imageLink(item)),
                      ),
                    ))
                        .toList(),*/Container(
              child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: AllCards().imageLink(load.images![0])),
    ),
                  ))),
          const SizedBox(
            height: 9,
          ),
        ],
      );
    }
  }


}
