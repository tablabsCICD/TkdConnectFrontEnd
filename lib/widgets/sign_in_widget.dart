import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../generated/l10n.dart';

class AlredayAccountWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
       width: 335.w,
       height: 24.h,
       child: Row(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             width: 335.w,
             child: Row(
               mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Textview(
                   title: S().already_have_account,
                   TextStyle(
                     color: Colors.black,
                     fontSize: 14.sp,
                     fontFamily: GoogleFonts.poppins().fontFamily,
                     fontWeight: FontWeight.w400,
                   ),
                 ),
                 InkWell(
                   onTap: (){
                     Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                   },
                   child: Textview(
                     title: ' ${S().signIn}',
                     TextStyle(
                       color: Colors.red,
                       fontSize: 14.sp,
                       fontFamily: GoogleFonts.poppins().fontFamily,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
               ],
             ),
           ),

         ],
       ));
  }


}