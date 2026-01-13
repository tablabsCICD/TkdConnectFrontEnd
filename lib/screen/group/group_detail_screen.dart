import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/provider/group/group_provider.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../widgets/common_app_bar.dart';
 // <<< ADDED

class GroupInfo extends StatefulWidget {
  GroupData groupData;
  GroupInfo(this.groupData, {super.key});

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          GroupProvider(widget.groupData.id!, context),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          CommonAppBar(
            title: "Group Details",
            isTitle: true,
            isBack: true,
            isSearchBar: false,
            isFilter: false,
            onBackTap: () => Navigator.pop(context),
          ),

          const SizedBox(height: 10),
          groupName(),
          const SizedBox(height: 30),
          particepent(),
          const SizedBox(height: 20),

          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: selectedUserList(),
            ),
          ),
        ],
      ),
    );
  }

  bool buttonEnable = false;

  groupName() {
    DateTime dateTime =
    DateTime.fromMillisecondsSinceEpoch(widget.groupData.date!);
    String formattedDate =
        "${dateTime.year}-${dateTime.month}-${dateTime.day}";

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 20),
          child: ClipOval(
            child: BaseWidget().getImageclip(
              widget.groupData.imageUrl!,
              height: 40.h,
              width: 40.w,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.groupData.groupName!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              formattedDate,
              style: TextStyle(
                color: const Color(0x99001E49),
                fontSize: 14.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  particepent() {
    return Container(
      height: 40,
      color: Colors.black12,
      child: Center(
        child: Text(
          "Members in group",
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  selectedUserList() {
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: provider.memberList.length,

          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            const Icon(Icons.account_circle, size: 30),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.memberList[index].displayName!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  provider.memberList[index].contact.toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  provider.memberList[index].location!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text(
                                    'Remove Member From Group',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to remove this member?',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: ThemeColor.theme_blue,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        provider.removeMemberFromGroup(
                                          provider.memberList[index].id!,
                                          index,
                                        );
                                        Navigator.pop(ctx);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: SvgPicture.asset(Images.delete),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
