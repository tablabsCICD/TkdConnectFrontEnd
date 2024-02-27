import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/generated/l10n.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/provider/dashboard/rating_provider.dart';
import 'package:tkd_connect/provider/group/group_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/rating_star.dart';
import 'package:tkd_connect/widgets/button.dart';

class SelectUserForGroupScreen extends StatefulWidget {
  bool isEdit;

  SelectUserForGroupScreen(this.isEdit);

  @override
  _SelectUserForGroupScreenState createState() =>
      _SelectUserForGroupScreenState();
}

class _SelectUserForGroupScreenState extends State<SelectUserForGroupScreen> {
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
      create: (BuildContext context) => GroupProvider(widget.isEdit),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      body: Consumer<GroupProvider>(builder: (context, model, child) {
      // getUserList(model);
        return model.isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  top_bar(context),
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
                              height: 90,
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
      bottomNavigationBar: Consumer<GroupProvider>(
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
              onClick: () {
                Navigator.pushNamed(context, AppRoutes.create_group,
                    arguments: provider);
              },
              isEnbale: provider.selectedUsers.length == 0 ? false : true),
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
    return Consumer<GroupProvider>(
      builder: (context, provider, child) {
        return Transform.translate(
          // e.g: vertical negative margin
          offset: const Offset(00, -25),
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
          ),
        );
      },
    );
  }

  listViewUser() {
    return Consumer<GroupProvider>(
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

  groupTile(int index, GroupProvider model) {
    String displayName = model.filterByName[index].firstName! +
        " " +
        model.filterByName[index].lastName!;
    if (displayName.length > 18) {
      displayName = displayName.substring(0, 18);
      displayName = displayName + "...";
    }
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                model.filterByName[index].profilePicture!.allMatches("null") ==
                        0
                    ? Image.network(
                        model.filterByName[index].profilePicture!,
                        height: 64,
                        width: 64,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 30.0,
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
                            Text(
                              displayName,
                              style: TextStyle(
                                color: Color(0xCC001E49),
                                fontSize: 16.sp,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
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
          ),
          Divider(),
        ],
      ),
    );
  }

  selectedUsers() {
    return Consumer<GroupProvider>(
      builder: (context, model, child) => ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        controller: horizantalControllet,
        itemCount: model.selectedUsers.length,
        itemBuilder: (BuildContext context, int index) => Container(
          height: 70,
          width: 100,
          child: Column(
            children: <Widget>[
              model.selectedUsers[index].profilePicture!.allMatches("null") == 0
                  ? Image.network(
                      model.selectedUsers[index].profilePicture!,
                      height: 64,
                      width: 64,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 64.0,
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
    );
  }

  callEditCheckBox(index, GroupProvider model) {
    return Visibility(
      visible: model.filterByName[index].addedIngroup == true ? false : true,
      child: Checkbox(
          value: model.filterByName[index].isSelected,
          onChanged: (value) {
            model.selectedUser(value, model.filterByName[index]);

            //horizantalControllet.jumpTo(horizantalControllet.position.maxScrollExtent+200);
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

  callCreateCheckBox(int index, GroupProvider model) {
    return Checkbox(
        value: model.filterByName[index].isSelected,
        onChanged: (value) {
          model.selectedUser(value, model.filterByName[index]);

          //horizantalControllet.jumpTo(horizantalControllet.position.maxScrollExtent+200);
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

  void getUserList(GroupProvider model) async{
    await model.getAllUserList(widget.isEdit);
  }
}
