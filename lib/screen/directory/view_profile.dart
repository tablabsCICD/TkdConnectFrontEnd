import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/utils/utils.dart';

import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/transport_directory_search.dart';
import '../../widgets/card/base_widgets.dart';

class ViewProfileDirectory extends StatelessWidget {
  final TransportSearchData data;

  const ViewProfileDirectory({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: ThemeColor.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topBar(),
              SizedBox(
                height: 22.h,
              ),
              // marginContainer(aboutCompany(), 22.h, 0),
              // marginContainer(discriptionCompny(), 4.h, 0),
              InkWell(
                onTap: () {
                  Utils().callFunction("${data.mobileNumber}");
                },
                child: marginContainer(titleTag(S().mobileNumber), 24.h, 0),
              ),

              InkWell(
                onTap: () {
                  Utils().callFunction("${data.mobileNumber}");
                },
                child: marginContainer(
                    emailLink(data.mobileNumber.toString()), 6.h, 0),
              ),

              // marginContainer(titleTag(S().traffic), 24.h, 0),
              // marginContainer(
              //     emailLink("traffic@shreejitranslogistics.com"), 6.h, 0),
              marginContainer(titleTag(S().accounts), 24.h, 0),
              InkWell(
                onTap: () {
                  Utils().openEmail(context, "${data.emailId}");
                },
                child: marginContainer(emailLink(data.emailId!), 6.h, 0),
              ),

              marginContainer(operatingRouteTag(), 24.h, 0),
              marginContainer(cityChip(), 6.h, 0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: marginContainer(callButton(), 10.h, 20.h),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green.shade800,
            onPressed: () {
              Utils().openwhatsapp(context, data.mobileNumber!,
                  "Hi We send message from from TKD connect application ");
            },
            child: const FaIcon(FontAwesomeIcons.whatsapp),
          ),
        ],
      ),
    );
  }

  callButton() {
    return InkWell(
      onTap: () {
        Utils().callFunction(data.mobileNumber.toString());
      },
      child: Container(
        width: 335.w,
        height: 49.h,
        decoration: ShapeDecoration(
          color: const Color(0xFF001E49),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Utils().callFunction(data.mobileNumber.toString());
              },
              child: Text(
                S().contact,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            SizedBox(
              width: 16.w,
              height: 16.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child:
                        Stack(children: [SvgPicture.asset(Images.call_white)]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  marginContainer(Widget child, double top, double bottom) {
    return Container(
      margin:
          EdgeInsets.only(left: 20.w, right: 20.w, top: top, bottom: bottom),
      child: child,
    );
  }

  topBar() {
    return Container(
        width: 375.w,
        height: 226.h,
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        decoration: ShapeDecoration(
          color: ThemeColor.red,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            BaseWidget()
                .getImage(data.companyLogo!, width: 80.w, height: 112.h),
            nameWithVerfiyTag(),
            Text(
              data.companyName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            RatingBar.builder(
              itemSize: 10,
              initialRating: data.ratings == null || data.ratings==0.0
                  ? 0.0
                  : data.ratings!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(
                  horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: ThemeColor.red,
                size: 5,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(
              height: 6.h,
            ),
            InkWell(
              onTap: (){
                Utils().openWebsite(data.website.toString());
              },
              child: Text(
                data.website!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              data.companyAddress!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: AppConstant.FONTFAMILY,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ],
        ));
  }

  nameWithVerfiyTag() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${data.firstName!} ${data.lastName!}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: AppConstant.FONTFAMILY,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Visibility(
            visible: data.isPaid != 0 ? true : false,
            child: SvgPicture.asset(Images.verified))
      ],
    );
  }

  aboutCompany() {
    return Text(
      S().aboutCompany,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  discriptionCompny() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam in dapibus ex, id aliquet lorem. Aliquam ornare lacus augue, eu auctor libero ullamcorper sit amet. Pellentesque a lectus id lorem consectetur suscipit vel tristique ante.',
      style: TextStyle(
        color: const Color(0x99001E49),
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w400,
        height: 0,
      ),
    );
  }

  operatingRouteTag() {
    return Text(
      S().operatingRoutes,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  Widget cityChip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.listOfPreferredRoutes.length, (i) {
        final route = data.listOfPreferredRoutes[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cityTag(route.routeSource!),
              const SizedBox(width: 6),
              const Text("<->", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              cityTag(route.routeDestination!),
            ],
          ),
        );
      }),
    );
  }

  cityTag(String cityName) {
    return Container(
      height: 26.w,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            cityName,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xCC001E49),
              fontSize: 12.sp,
              fontFamily: AppConstant.FONTFAMILY,
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }

  titleTag(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  emailLink(String email) {
    return Text(
      email,
      style: TextStyle(
        color: const Color(0xFFC3262C),
        fontSize: 12.sp,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }
}
