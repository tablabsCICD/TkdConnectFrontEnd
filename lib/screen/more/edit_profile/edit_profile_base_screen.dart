import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/edit_profile/edit_profile_provider.dart';
import 'package:tkd_connect/screen/more/edit_profile/personal_info.dart';
import 'package:tkd_connect/screen/more/edit_profile/plan_selected.dart';
import 'package:tkd_connect/screen/plan/plan_details_screen.dart';
import 'package:tkd_connect/screen/plan/select_plan_screen.dart';

import '../../../constant/images.dart';
import '../../../generated/l10n.dart';
import '../../../model/response/route_model.dart';
import '../../../utils/colors.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/button.dart';
import '../../../widgets/editText.dart';
import '../../../widgets/textview.dart';
import 'company_info.dart';

class EditProfileBaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileBaseState();
  }
}

class _EditProfileBaseState extends State<EditProfileBaseScreen> {
  bool isPersonalInfo = true;
  bool isCompanyInfo = false;
  bool isSubscribe = false;
   @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => EditProfileProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      body: SafeArea(child: Consumer<EditProfileProvider>(
        builder: (context, provider, child) {
          return Container(
            width: MediaQuery.of(context).size.width,

            // margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 70.h,
                  color: ThemeColor.baground,
                  child: ApplicationAppBar()
                      .appBarWithBack(context, S().editProfile),
                ),
                SizedBox(
                  height: 20.h,
                ),
                tabs(),
                Visibility(
                    visible:isPersonalInfo,
                    child: PersonalInfoScreen(editProfileProvider: provider,)),
                Visibility(
                    visible: isCompanyInfo,
                    child: _buildPages(context)),
                Visibility(
                    visible:isSubscribe,
                    child: SelectPlanScreenEdit(provider: provider,)),

              ],
            ),
          );
        },
      )),
      bottomNavigationBar: bootonButton(),
    );
  }
  bootonButton() {
    return Consumer<EditProfileProvider>(
  builder: (context, provider, child) {
  return Padding(
      padding: EdgeInsets.only(bottom: 20.h, left: 10.w, right: 10.w),
      child: Button(
        width: MediaQuery.of(context).size.width,
        height: 49.h,
        title:S().saveChange,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        onClick: () {
          provider.saveChanges(context);
        },
        isEnbale: true,
      ),
    );
  },
);
  }

  tabs() {
    return Consumer<EditProfileProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 335.w,
          height: 32.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0x332C363F),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0x332C363F)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: EdgeInsets.all(1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tabItem(isPersonalInfo, S().personalInfo, () {
               isPersonalInfo= true;
               isCompanyInfo = false;
               isSubscribe = false;
               setState(() {

               });
              }),
              tabItem(isCompanyInfo, S().businessInfo, () {
                isPersonalInfo= false;
                isCompanyInfo = true;
                isSubscribe = false;
                setState(() {

                });
              }),
              // tabItem(isSubscribe, 'Subscription', () {
              //   isPersonalInfo= false;
              //   isCompanyInfo = false;
              //   isSubscribe = true;
              //   setState(() {
              //
              //   });
              // }),
            ],
          ),
        );
      },
    );
  }

  tabItem(bool isSelect, String title, Function onClick) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.h),
          color: isSelect ? Color(0x19001E49) : ThemeColor.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ThemeColor.subColor,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: isSelect ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  profile() {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(32),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0x192C363F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  child: Stack(children: []),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }





  _buildPages(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (context, provider, child) {
        return Container(


          child: Expanded(
            child: ListView(
              padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 20.h),

              children: [
                SizedBox(height: 28.h,),
                labelText(S().companyName),
                SizedBox(height: 4.h,),
                editView(S().egFristName, provider.companyNameController),
                SizedBox(height: 12.h,),

                labelText(S().location),
                SizedBox(height: 4.h,),
                editView(S().egPune, provider.locationController),
                SizedBox(height: 12.h,),

                labelText("Type of Company"),
                SizedBox(height: 4.h,),
                editView("eg.Software", TextEditingController()),
                SizedBox(height: 28.h,),

                SizedBox(
                  width: 335.w,
                  child: Textview(
                    title: S().addRoutes,
                    TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 4.h,),
                SizedBox(
                  width: 335.w,
                  child: Textview(
                    title: S().clickAddRoutes,
                    TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 16.h,),


                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 195.h, minHeight: 0.0),
                    child: listviewCity()),

                SizedBox(height: 24.h,),
                addRoute(),
              ],


            ),
          ),
        );
      },
    );
  }


  labelText(String label) {
    return Container(
      width: 332.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts
                  .poppins()
                  .fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  editView(String hint, TextEditingController controller) {
    return Consumer<EditProfileProvider>(
  builder: (context, provider, child) {
  return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        // provider.checkValidation();
      },
    );
  },
);
  }


  listviewCity() {
    return Consumer<EditProfileProvider>(
      builder: (context, provider, child) {
        return ListView.builder(

          itemCount: provider.routeList.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return routeItem(provider.routeList[i],i);
          },
        );
      },
    );
  }

  routeItem(RouteData routeRequest, int index) {
    return Consumer<EditProfileProvider>(
  builder: (context, provider, child) {
  return Container(
      width: 335.w,
      height: 40.65.h,
      //padding: EdgeInsets.only(left: 20.w,right: 20.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 37.65.h,
              width: 247.w,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x332C363F)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        routeRequest.routeSource!,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xCC001E49),
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts
                              .poppins()
                              .fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SvgPicture.asset(Images.return_route),
                  SizedBox(width: 16.w),

                  Expanded(
                    child: SizedBox(
                      child: Text(
                        routeRequest.routeDestination!,
                        style: TextStyle(
                          color: Color(0xCC001E49),
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts
                              .poppins()
                              .fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20.w,),
          Container(
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
                  child: Stack(children: [
                    InkWell(onTap: () {

                      provider.editRoute(context, index);

                    }, child: SvgPicture.asset(Images.edit))

                  ]),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w,),
          Container(
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
                  child: Stack(children: [

                    InkWell(onTap: () {

                     provider.deleteRoute(index);

                    }, child: SvgPicture.asset(Images.delete))

                  ]),
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

  addRoute() {
    return Consumer<EditProfileProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            provider.showBootomSheet(context);

          },
          child: SvgPicture.asset(Images.additional_label),
        );
      },
    );
  }
}
