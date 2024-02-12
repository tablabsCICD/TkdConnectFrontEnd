import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/screen/my_route/select_city.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/editText.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../../generated/l10n.dart';
import '../../model/request/route_request.dart';
import '../../provider/registration_provider/company_details_provider.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';
import '../../widgets/sign_in_widget.dart';

class CompanyDetailsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CompanyDetailsScreen();
  }

}

class _CompanyDetailsScreen extends State<CompanyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CompanyDetailsProvider("Ideal"),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Consumer<CompanyDetailsProvider>(
          builder: (context, provider, child) {
            return Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: ThemeColor.baground,
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,

                children: [

                  SizedBox(height: 21.5.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: (){
                        Navigator.pop(context);
                      },child: SvgPicture.asset(Images.arrow_back)),
                      Textview(
                        title: '${S().businessDetails}',
                        TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: GoogleFonts
                              .poppins()
                              .fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox()
                    ],
                  ),

                  SizedBox(height: 21.h,),
                  progressBar(),
                  SizedBox(height: 24.h,),
                  labelText(S().companyName),
                  SizedBox(height: 4.h,),
                  editView("${S().egFristName}",provider.companyNameController,provider),
                  SizedBox(height: 12.h,),

                  labelText(S().location),
                  SizedBox(height: 4.h,),
                  editView(S().egPune,provider.locationController,provider),
                  SizedBox(height: 12.h,),

                  //labelText("Type of Company"),

                  SizedBox(height: 4.h,),
                  //editView("eg.Software",provider.companyTypeController,provider),
                  popUpmenu((val){

                  },context),
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
                        fontFamily: AppConstant.FONTFAMILY,
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

                  SizedBox(height: 31.h,),

                  Consumer<CompanyDetailsProvider>(
                    builder: (context, provider, child) {
                      return Button(
                          isEnbale: provider.isEnbale,
                          width: 335.w, height: 49.h,
                          title: S().Next,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),

                          onClick: () {
                        provider.saveData(context);
                            // Navigator.pushReplacementNamed(
                            //     context, AppRoutes.registration_plan_details);
                          });
                    },
                  ),
                  SizedBox(height: 60.h,),
                  AlredayAccountWidget(),


                ],

              ),


            );
          },
        ),
      ),
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

  progressBar() {
    return Container(
      width: 335.w,
      height: 6.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 335.w,
              height: 6.h,
              decoration: ShapeDecoration(
                color: Color(0x4CB7B7B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 234.50.w,
              height: 6.h,
              decoration: ShapeDecoration(
                color: Color(0xFF1DD19E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  editView(String hint, TextEditingController controller,
      CompanyDetailsProvider provider) {
    return EditText(
      width: 335.w,
      height: 52.h,
      hint: hint,
      controller: controller,
      onChange: (val) {
        provider.checkValidation();
      },
    );
  }

  routeItem(RouteRequest routeRequest, int index) {
    return Container(
      width: 335.w,
      height: 40.65.h,

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
                        routeRequest.startLocation,
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
                        routeRequest.endLocation,
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


  listviewCity() {
    return Consumer<CompanyDetailsProvider>(
      builder: (context, provider, child) {
        return ListView.builder(

          itemCount: provider.listRoute.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return routeItem(provider.listRoute[i], i);
          },
        );
      },
    );
  }

  addRoute() {
    return Consumer<CompanyDetailsProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            //showBootomSheet();
            provider.showBootomSheet(context);
          },
          child: SvgPicture.asset(Images.additional_label),
        );
      },
    );
  }


  popUpmenu(Function(String) onMenuTap, BuildContext context) {
    return Consumer<CompanyDetailsProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton(
          position: PopupMenuPosition.values[1],
          constraints:
          BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: dropList(context)),
          onSelected: (dynamic val) {
            //onMenuTap(val);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                provider.changeDropDown("${S().agentBroker}",0);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      '${S().agentBroker}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      width: 13.w,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("${S().transporter}",1);
                },
                child: Row(
                  children: [
                    Text(
                      '${S().transporter}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("${S().packersAndMovers}",0);
                },
                child: Row(
                  children: [
                    Text(
                      '${S().packersAndMovers}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),

            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("${S().manufacturerDistributorTrade}",3);
                },
                child: Row(
                  children: [
                    Text(
                      '${S().manufacturerDistributorTrade}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("${S().truckDriver}",6);
                },
                child: Row(
                  children: [
                    Text(
                      '${S().truckDriver}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                ))
          ],
        );
      },
    );
  }



  dropList(BuildContext context) {
    return Consumer<CompanyDetailsProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0x332C363F)),
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
                          Expanded(
                            child: SizedBox(
                              child: Text(
                               provider.valName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 24,
                            height: 24,
                            child: Stack(children: [
                              SvgPicture.asset(Images.dwon_arrow)
                            ]),
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

}