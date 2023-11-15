import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/utils/colors.dart';

class EditTextMobile extends StatelessWidget {
  final double width;
  final double height;
  final String hint ;
  final TextEditingController controller;
  TextInputType? keybordType=TextInputType.text;
  Function(String val)? onChange =(val){};

  EditTextMobile({this.onChange,super.key,this.keybordType ,required this.width, required this.height, required this.hint, required this.controller} );



  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 12.h),

      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.w, color: ThemeColor.border_grey),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: TextField(

        controller: controller,
        onChanged: (value){
          onChange!(value);

        },
        maxLength: 10,

        keyboardType: keybordType,
        decoration: InputDecoration(
            hintText: hint,
            counter: Offstage(),
            border: InputBorder.none,
            hintStyle:TextStyle(
              color: Color(0x662C363F),
              fontSize: 14.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,

            )
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,

        ),
      ),
    );
  }


}