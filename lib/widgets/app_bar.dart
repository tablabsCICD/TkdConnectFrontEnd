import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/widgets/textview.dart';

import '../constant/images.dart';

class ApplicationAppBar{

  appBarWithBack(BuildContext context,String title){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(Images.arrow_back)),
        Textview(
          title: title,
          TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox()
      ],
    );

  }


}