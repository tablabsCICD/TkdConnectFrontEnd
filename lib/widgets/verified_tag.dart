
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/utils/colors.dart';

class VerifiedTag {


  onVeriedTag(){
   return Center(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)
          ),
          border: Border.all(
            width: 0.5,
            color: ThemeColor.red,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Verified',
              style: TextStyle(
                color: ThemeColor.theme_blue, // Customize text color
                fontWeight: FontWeight.bold,
                fontSize: 8.sp,
                fontFamily: AppConstant.FONTFAMILY

              ),
            ),
          ],
        ),
      ),
    );
  }

}