import 'dart:convert';

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
import 'package:tkd_connect/utils/sharepreferences.dart';
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
      create: (BuildContext context) => GroupProvider(0),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Consumer<GroupProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                color: ThemeColor.baground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseWidget().appBar(context, "Groups"),
                    serachBar(),
                   /* SizedBox(
                      height: 12.h,
                    ),
                    alGroupTag(),*/
                    provider.groupListByUserId.length == 0 && provider.isLoadDone
                        ? Center(child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(S().noRecordFound),
                    ))
                        : SizedBox(),
                    allGroupData()

                  ],
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerFloat,
              floatingActionButton: InkWell(
                onTap: () async {
                  var result = await Navigator.pushNamed(context, AppRoutes.select_group_member,arguments: false);
                  if(result==1){
                    provider.callSetState();
                  }
                },
                child: Container(
                  width: 155.w,
                  height: 38.h,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  decoration: ShapeDecoration(
                    color: ThemeColor.theme_blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Create Group',
                        style: TextStyle(
                          color: ThemeColor.progress_color,
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts
                              .poppins()
                              .fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Container(
                        width: 16.w,
                        height: 16.w,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 16.w,
                              height: 16.w,
                              child: Stack(children: [
                                SvgPicture.asset(
                                  Images.add, height: 16.h, width: 16.w,)

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
          );
        }
    );
  }

  allGroupData() {
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
              controller: provider.scrollControllerVertical,
              itemCount: provider.groupListByUserId.length,
              itemBuilder: (BuildContext context, int index) {
                return groupItem(provider.groupListByUserId[index],provider,index);
              }),
        );
      },
    );
  }

   serachBar() {
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return Container(
          // transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
          margin: EdgeInsets.all(20),
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
                                  provider.groupSearch(value);
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
        );
      },
    );
  }

   alGroupTag() {
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

  groupItem(GroupData groupData, GroupProvider provider, int index) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(groupData.date!);
    // Format DateTime as string
    String formattedDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    print(formattedDate);

    return InkWell(
      onTap: () async {
        provider.currentGroup = await LocalSharePreferences.localSharePreferences.getCurrentGroupData();
        Navigator.pushNamed(context, AppRoutes.group_info,arguments: groupData);
      },
      child: Container(
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
                        BaseWidget().getImageclip(groupData.imageUrl!,
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
                                formattedDate,
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
                  Container(
                    width: 24.w,
                    height: 24.h,
                    child: Stack(children: [
                      InkWell(onTap: () async {
                        LocalSharePreferences().setString(AppConstant.CURRENT_GROUP, jsonEncode(groupData));
                        var result = await Navigator.pushNamed(context, AppRoutes.select_group_member,arguments: true);
                        if(result==1){
                          provider.callSetState();
                        }
                      }, child: SvgPicture.asset(Images.edit,height: 20,width: 20,))

                    ]),
                  ),
                  SizedBox(width: 12.w),
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Group',style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),),
                              content: Text('Are you sure you want to delete this group?',style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('Cancel',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,),),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.deleteGroup(groupData.id!, index);
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red, fontSize: 12.sp,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w600,),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(Images.delete)),
                ],
              ),
            ),
          ],
        ),
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
