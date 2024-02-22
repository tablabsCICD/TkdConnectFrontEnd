import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/provider/group/group_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/transport_directory_search.dart';
import '../../provider/directory/directory_provider.dart';
import '../../provider/mybids/my_bids_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/card/base_widgets.dart';

class GroupScreen extends StatefulWidget {
  int userId;
  GroupScreen({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return _GroupScreenState();
  }
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GroupProvider(widget.userId),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<GroupProvider>(
  builder: (context, provider, child) {
  return Container(
        color: ThemeColor.baground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            top_bar(context),
            serachBar(),
            tabBar(),
            allUserTag(),
            provider.groupListByUserId.length==0 && provider.isLoadDone?Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(S().noRecordFound),
            )):SizedBox(),
            allUserData()

          ],
        ),
      );
  },
),
    );
  }

  allUserData() {
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child: ListView.builder(
                controller: provider.scrollControllerVertical,
                itemCount: provider.groupListByUserId.length,
                itemBuilder: (BuildContext context, int index) {
                  return groupItem(provider.groupListByUserId[index]);
                }),
          ),
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
          // Expanded(
          //   child: Container(
          //     height: double.infinity,
          //     padding: const EdgeInsets.symmetric(horizontal: 12),
          //     decoration: ShapeDecoration(
          //       color: Colors.white,
          //       shape: RoundedRectangleBorder(
          //         side: BorderSide(color: Color(0x332C363F)),
          //       ),
          //     ),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Favourites',
          //           style: TextStyle(
          //             color: Color(0xCC001E49),
          //             fontSize: 12,
          //             fontFamily: 'Poppins',
          //             fontWeight: FontWeight.w400,
          //             height: 0,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
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

  serachBar() {
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return Transform.translate(
          // e.g: vertical negative margin
          offset: const Offset(00,-25),
          child: Container(
            // transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
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
                                child: TextField(
                                  controller: provider.searchController,
                                  onChanged: (value) {
                                   // provider.searchUser(value);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Search groups ",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0x662C363F),
                                        fontSize: 14.sp,
                                        fontFamily:
                                        GoogleFonts.poppins().fontFamily,
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
            ),
          ),
        );
      },
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
        color: Color(0xFFF4F6F6),
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
              color: Color(0xCC001E49),
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
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
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
              child: BaseWidget().profileDirectory(data.profilePicture!, data.firstName!+" "+data.lastName!, data.companyName!,verify: data.isPaid!)),


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
            side: BorderSide(width: 1, color: Color(0x33001E49)),
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
              style: TextStyle(
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
        "All Groups",
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

  groupItem(GroupData groupData) {
    return Container(
      width: 375.w,
      height: 67.h,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                      BaseWidget().getImage(groupData.imageUrl!,
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
                                groupData.groupName!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  height: 0,

                                ),

                              ),
                              SizedBox(width: 4.w,),
                             // Visibility(visible: groupData.isPaid !=0?true:false,child: SvgPicture.asset(Images.verified,height: 12.h,width: 12.w,))

                            ],
                          ),
                          Container(
                            child: Text(
                              groupData.date!.toString(),
                              style: TextStyle(
                                color: Color(0x99001E49),
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

                      Navigator.pushNamed(context, AppRoutes.viewprofiledirectory,arguments: groupData);

                    },
                    child: SvgPicture.asset(Images.profilepicture)),
                SizedBox(width: 12.w),
                InkWell(
                    onTap: () {
                    //  Utils().callFunction("${groupData.mobileNumber}");
                    },
                    child: SvgPicture.asset(Images.call)),
              ],
            ),
          ),
        ],
      ),
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


}
