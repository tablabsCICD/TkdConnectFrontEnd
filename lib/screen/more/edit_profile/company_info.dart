import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/provider/edit_profile/edit_profile_provider.dart';

import '../../../constant/images.dart';
import '../../../generated/l10n.dart';
import '../../../model/request/route_request.dart';
import '../../../model/response/route_model.dart';
import '../../../provider/registration_provider/company_details_provider.dart';
import '../../../widgets/editText.dart';
import '../../../widgets/textview.dart';

class CompanyInfoScreen extends StatefulWidget {
  EditProfileProvider editProfileProvider;

  CompanyInfoScreen({super.key, required this.editProfileProvider});

  @override
  State<StatefulWidget> createState() {
    return _CompanyInfoState();
  }

}

class _CompanyInfoState extends State<CompanyInfoScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.editProfileProvider.getRouteListByUserId();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => widget.editProfileProvider,
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
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
                    title:S().addRoutes,
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
    return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        // provider.checkValidation();
      },
    );
  }


  listviewCity() {
    return Consumer<EditProfileProvider>(
      builder: (context, provider, child) {
        return Flexible(
          child: ListView.builder(

            itemCount: provider.routeList.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return routeItem(provider.routeList[i],i);
            },
          ),
        );
      },
    );
  }

  routeItem(RouteData routeRequest, int index) {
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

                      widget.editProfileProvider.editRoute(context, index);

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

                      widget.editProfileProvider.deleteRoute(index);

                    }, child: SvgPicture.asset(Images.delete))

                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
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