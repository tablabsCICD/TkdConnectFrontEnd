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

import '../../widgets/common_app_bar.dart';

class SelectUserForGroupScreen extends StatefulWidget {
  bool isEdit;

  SelectUserForGroupScreen(this.isEdit, {super.key});

  @override
  _SelectUserForGroupScreenState createState() =>
      _SelectUserForGroupScreenState();
}

class _SelectUserForGroupScreenState extends State<SelectUserForGroupScreen> {
  final TextEditingController _controller = TextEditingController();
  ScrollController horizantalControllet = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CreateGroupProvider(widget.isEdit),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: Consumer<CreateGroupProvider>(builder: (context, model, child) {
      // getUserList(model);
        return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CommonAppBar(
                    title: "Users",
                    isBack: true,
                    isTitle: true,
                    isSearchBar: true,      // ✅ enable search
                    isFilter: false,
                    onBackTap: () => Navigator.pop(context),
                    searchController: model.searchController,
                    onSearchChanged: (value) => model.filterUser(value),
                  ),
                  SizedBox(height: 30,),
                  Visibility(
                    visible: model.selectedUsers.isEmpty ? false : true,
                    child: Container(
                      color: Colors.black12,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
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
      bottomNavigationBar: Consumer<CreateGroupProvider>(
        builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Button(
              width: 327.w,
              height: 49.h,
              title: S().Next,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
              onClick: () async {
                if(widget.isEdit){
                 var result = await Navigator.pushNamed(context, AppRoutes.edit_group,
                      arguments: provider.selectedUsers);
                 if(result==1){
                   Navigator.pop(context,1);
                 }
                }else{
                  var result = await Navigator.pushNamed(context, AppRoutes.create_group,
                      arguments: provider.selectedUsers);
                  if(result==1){
                    Navigator.pop(context,1);
                  }
                }
              },
              isEnbale: provider.selectedUsers.isEmpty ? false : true),
        ),
      ),
    );
  }

  top_bar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 87.h,
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
      child: const SizedBox(),
    );
  }



  listViewUser() {
    return Consumer<CreateGroupProvider>(
      builder: (context, model, child) => Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.filterByName.length,
            itemBuilder: (context, index) {
              return InkWell(onTap: () {}, child: groupTile(index, model));
            }),
      ),
    );
  }

  groupTile(int index, CreateGroupProvider model) {
    String displayName = "${model.filterByName[index].firstName!} ${model.filterByName[index].lastName!}";
    if (displayName.length > 18) {
      displayName = displayName.substring(0, 18);
      displayName = "$displayName...";
    }
    return Container(
      width: 375.w,
      height: 90.h,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
        children: <Widget>[
          BaseWidget().getImageclipGroup(
          model.filterByName[index].companyLogo ==null ?"":
            model.filterByName[index].companyLogo.toString(),
            height: 45,
            width: 45,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                color: const Color(0xCC001E49),
                                fontSize: 14.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                            ),
                            Text(
                              model.filterByName[index].mobileNumber.toString(),
                              style: TextStyle(
                                color: const Color(0xCC001E49),
                                fontSize: 12.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                            ),
                            Text(
                              model.filterByName[index].city??"",
                              style: TextStyle(
                                color: const Color(0xCC001E49),
                                fontSize: 12.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                            ),
                          ],
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
    return Consumer<CreateGroupProvider>(
      builder: (context, model, child) => ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        controller: horizantalControllet,
        itemCount: model.selectedUsers.length,
        itemBuilder: (BuildContext context, int index) => SizedBox(
          height: 80.h,
          width: 100.w,
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
                  "${model.selectedUsers[index].firstName!} ${model.selectedUsers[index].lastName!}",
                  style: TextStyle(
                    color: const Color(0xCC001E49),
                    fontSize: 12.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                ),
                Text(
                  model.selectedUsers[index].mobileNumber.toString(),
                  style: TextStyle(
                    color: const Color(0xCC001E49),
                    fontSize: 10.sp,
                    fontFamily: AppConstant.FONTFAMILY,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  model.selectedUsers[index].city??"",
                  style: TextStyle(
                    color: const Color(0xCC001E49),
                    fontSize: 10.sp,
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

  callEditCheckBox(index, CreateGroupProvider model) {
    return Visibility(
      visible: model.filterByName[index].addedIngroup == true ? true : true,
      child: Checkbox(
          value: model.filterByName[index].isSelected,
          activeColor: const Color(0xFFC3262C),
          checkColor: Colors.white,
          onChanged: (value) {
            model.selectedUser(value, model.filterByName[index]);

            if (value == true) {
              horizantalControllet.animateTo(
                  horizantalControllet.position.maxScrollExtent + 200,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn);
            } else {
              horizantalControllet.animateTo(
                  horizantalControllet.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.slowMiddle);
            }
          }),
    );
  }

  callCreateCheckBox(int index, CreateGroupProvider model) {
    return Checkbox(
        value: model.filterByName[index].isSelected,
        activeColor: const Color(0xFFC3262C),
        checkColor: Colors.white,
        onChanged: (value) {
          model.selectedUser(value, model.filterByName[index]);

          //horizantalControllet.jumpTo(horizantalControllet.position.maxScrollExtent+200);
          if (value == true) {
            horizantalControllet.animateTo(
                horizantalControllet.position.maxScrollExtent + 200,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn);
          } else {
            horizantalControllet.animateTo(
                horizantalControllet.position.maxScrollExtent,
                duration: const Duration(milliseconds: 400),
                curve: Curves.slowMiddle);
          }
        });
  }

  void getUserList(CreateGroupProvider model) async{
    await model.getAllUserList(widget.isEdit);
  }
}
