import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/provider/group/create_group_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../provider/dashboard/verfied_user_list_provoder.dart';

class SelectUserForPostScreen extends StatefulWidget {
  bool isEdit;
  String source;

  SelectUserForPostScreen(this.isEdit,this.source);

  @override
  _SelectUserForPostScreen createState() =>
      _SelectUserForPostScreen();
}

class _SelectUserForPostScreen extends State<SelectUserForPostScreen> {
  TextEditingController _controller = TextEditingController();
  ScrollController horizantalControllet = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => VerifiedUserProvider(widget.isEdit,widget.source),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColor.baground,
        body: Consumer<VerifiedUserProvider>(builder: (context, model, child) {
          // getUserList(model);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseWidget().appBar(context, "Users"),
              serachBar(),
              Visibility(
                visible: model.selectedUsers.length == 0 ? false : true,
                child: Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: selectedUsers(),
                          height: 60.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              listViewUser(),
            ],
          );
        }),
        bottomNavigationBar: Consumer<VerifiedUserProvider>(
          builder: (context, provider, child) => Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Button(
                width: 327.w,
                height: 49.h,
                title: S().next,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
                onClick: () async {
                  if(widget.isEdit){
                   /* var result = await Navigator.pushNamed(context, AppRoutes.edit_group,
                        arguments: provider.selectedUsers);
                    if(result==1){
                      Navigator.pop(context,1);*/
                   Navigator.pop(context,[]);

                  }else{
                    // var result = await Navigator.pushNamed(context, AppRoutes.create_group,
                    //     arguments: provider.selectedUsers);
                    // if(result==1){
                    //   Navigator.pop(context,1);
                    // }

                    Navigator.pop(context,provider.selectedUsers);
                  }
                },
                isEnbale: provider.selectedUsers.length == 0 ? false : true),
          ),
        ),
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
    return Consumer<VerifiedUserProvider>(
      builder: (context, provider, child) {
        return Container(
          // transform: Matrix4.translationValues(0.0, -25.0.h, 0.0),
          margin: EdgeInsets.all(20.w),
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
                                  provider.filterUser(
                                      provider.searchController.text);
                                },
                                decoration: InputDecoration(
                                    hintText: "Search users ",
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
                                  fontFamily:
                                  GoogleFonts.poppins().fontFamily,
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

  listViewUser() {
    return Consumer<VerifiedUserProvider>(
      builder: (context, model, child) => model.filterByName.isEmpty?Expanded(child: Text("No user found for this source list")): Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.filterByName.length,
            itemBuilder: (context, index) {
              return InkWell(onTap: () {}, child: groupTile(index, model));
            }),
      ),
    );
  }

  groupTile(int index, VerifiedUserProvider model) {
    String displayName = model.filterByName[index].firstName! +
        " " +
        model.filterByName[index].lastName!;
    if (displayName.length > 18) {
      displayName = displayName.substring(0, 18);
      displayName = displayName + "...";
    }
    return Container(
      width: 375.w,
      height: 90.h,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
        children: <Widget>[
          BaseWidget().getImageclip(
            model.filterByName[index].profilePicture.toString(),
            height: 34,
            width: 34,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[

                      Padding(
                        padding:  EdgeInsets.only(top: 3.h),
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: Color(0xCC001E49),
                            fontSize: 14.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                      widget.isEdit
                          ? callEditCheckBox(index, model)
                          : callCreateCheckBox(index, model),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  selectedUsers() {
    return Consumer<VerifiedUserProvider>(
      builder: (context, model, child) => ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        controller: horizantalControllet,
        itemCount: model.selectedUsers.length,
        itemBuilder: (BuildContext context, int index) => Container(
          height: 50.h,

          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(

              children: <Widget>[


                BaseWidget().getImageclip(
                  model.selectedUsers[index].profilePicture.toString(),
                  height: 34,
                  width: 34,
                ),
                Text(
                  model.selectedUsers[index].firstName!,
                  style: TextStyle(
                    color: Color(0xCC001E49),
                    fontSize: 14.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  callEditCheckBox(index, VerifiedUserProvider model) {
    return Visibility(
      visible: model.filterByName[index].isAdded == true ? true : true,
      child: Checkbox(
          value: model.filterByName[index].isSelected,
          activeColor: Color(0xFFC3262C),
          checkColor: Colors.white,
          onChanged: (value) {
           // model.selectedUser(value, model.filterByName[index]);

            if (value == true) {
              horizantalControllet.animateTo(
                  horizantalControllet.position.maxScrollExtent + 200,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn);
            } else {
              horizantalControllet.animateTo(
                  horizantalControllet.position.maxScrollExtent,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.slowMiddle);
            }
          }),
    );
  }

  callCreateCheckBox(int index, VerifiedUserProvider model) {
    return Checkbox(
        value: model.filterByName[index].isSelected,
        activeColor: Color(0xFFC3262C),
        checkColor: Colors.white,
        onChanged: (value) {
          model.selectedUser(value, model.filterByName[index]);

          horizantalControllet.jumpTo(horizantalControllet.position.maxScrollExtent+200);
          if (value == true) {
            horizantalControllet.animateTo(
                horizantalControllet.position.maxScrollExtent + 200,
                duration: Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn);
          } else {
            horizantalControllet.animateTo(
                horizantalControllet.position.maxScrollExtent,
                duration: Duration(milliseconds: 400),
                curve: Curves.slowMiddle);
          }
        });
  }

  // void getUserList(VerifiedUserProvider model) async{
  //   await model.getAllUserList(widget.isEdit);
  // }
}
