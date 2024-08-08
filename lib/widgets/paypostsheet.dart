import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/widgets/button.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../constant/images.dart';

class PayPostSheet extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Textview(TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontFamily:GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w900,
            ), title: "Subscription"),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Textview( TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w500,

              ), title: "You have completed your free post. If you wish to post just one post, it has changed to 199 or you may subscribe for unlimited post.."),
            ),

            SvgPicture.asset(Images.intro_one,width: 200,),

            Button(width: 300.w, height: 40.h, title: "Click to See Plan", textStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,

            ), onClick: (){

              Navigator.pushNamed(context, AppRoutes.registration_plan_details);


            }),

            Button(width: 300.w, height: 40.h, title: "Click Here to one post for 199", textStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,

            ), onClick: (){

              Navigator.pop(context,true);


            })
          ],

        ),


      ),



    );
  }
}