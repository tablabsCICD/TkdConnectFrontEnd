import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/dashboard/rating_provider.dart';
import 'package:tkd_connect/provider/group/group_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/rating_star.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';
import 'package:tkd_connect/widgets/editText.dart';

class GroupInfo extends StatefulWidget {
  GroupData groupData;
  GroupInfo(this.groupData);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          GroupProvider(widget.groupData.id!,context),
      builder: (context, child) => _buildPage(context),
    ); }

  _buildPage(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
            backgroundColor: ThemeColor.baground,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseWidget().appBar(context, "Group Details"),
                SizedBox(height: 10,),
                groupName(),
                SizedBox(height: 30,),
                particepent(),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: selectedUserList(),),
              ],
            ),


          )

    );

  }

  bool buttonEnable = false;
  groupName() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.groupData.date!);
    String formattedDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 20),
          child: ClipOval(
            child: Material(
              color: Colors.grey, // Button color
              child: InkWell(
                splashColor: Colors.grey, // Splash color
                onTap: () async{
                 /*await provider.uploadProfileImage(context);
                  setState(() {
                  });*/
                },
                child: BaseWidget().getImageclip(widget.groupData.imageUrl!,
                    height: 40.h, width: 40.w),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  particepent() {
    return Container(
      height: 40,
      color: Colors.black12,
      child: Center(child: Text("Members in group",style: TextStyle(fontSize: 14.sp,
        fontFamily: AppConstant.FONTFAMILY,
        fontWeight: FontWeight.w600,))),
    );
  }



  selectedUserList(){
    return Consumer<GroupProvider>(
        builder: (context, provider, child) {
      return ListView.builder(
        // controller: _scrollController,
          shrinkWrap: true,
          itemCount: provider.memberList.length,
          itemBuilder: (context, index) {
            return InkWell(onTap: () {}, child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            size: 30.0,
                          ),
                          SizedBox(width: 10,),
                          Text(
                              provider.memberList[index].displayName!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w600,
                              ))
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Remove Member From Group',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,
                                ),),
                                content: Text('Are you sure you want to remove member from group?',style: TextStyle(
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
                                      provider.removeMemberFromGroup(provider.memberList[index].id!, index);
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
                        child: SvgPicture.asset(Images.delete)
                      )
                    ],
                  ),
                ),
                Divider()
              ],
            ));
          });
    });
  }


}