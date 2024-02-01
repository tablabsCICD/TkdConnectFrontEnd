import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/search_provider/search_provider.dart';
import 'package:tkd_connect/utils/utils.dart';

import '../../constant/images.dart';
import '../../model/response/transport_directory_search.dart';
import '../../route/app_routes.dart';
import '../../widgets/card/base_widgets.dart';

class SearchUserScreen extends StatefulWidget {
  SearchProvider searchProvider;
  String serachVal;

  SearchUserScreen(
      {super.key, required this.searchProvider, required this.serachVal});

  @override
  State<StatefulWidget> createState() {
    return _SearchUserState();
  }
}

class _SearchUserState extends State<SearchUserScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.searchProvider.callUser(widget.serachVal);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => widget.searchProvider,
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        return Container(
          child: Expanded(
            child:
            provider.user.length==0 && provider.isLoadingUser ? Text("No User Found"):
            ListView.builder(
                itemCount: widget.searchProvider.user.length,
                itemBuilder: (BuildContext context, int index) {
                  return userItem(widget.searchProvider.user[index]);
                }),
          ),
        );
      },
    );
  }

  userItem(TransportSearchData user) {
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
                                user.firstName! + " " + user.lastName!,
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

                      Navigator.pushNamed(context, AppRoutes.viewprofiledirectory,arguments: user);
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
  }
}
