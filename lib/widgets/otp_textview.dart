import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

class OtpTextView extends StatelessWidget{

 final TextEditingController otpController ;
 final Function onChnage;
 final hint;


   const OtpTextView({super.key, required this.otpController, required this.onChnage, this.hint});
  @override
  Widget build(BuildContext context) {
   return Container(
     height: 40.h,
     width: 44.w,
    decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
    side: BorderSide(width: 0.50.w, color: ThemeColor.border_grey),
    borderRadius: BorderRadius.circular(8.r),
    )),
    // padding: EdgeInsets.only(left: 20.w),



     child: TextFormField(
       controller: otpController,
       maxLength: 1,
       obscureText: false,
       keyboardType: TextInputType.number,
       autofocus: true,
       textAlignVertical:TextAlignVertical.center ,
       textAlign: TextAlign.center,

       style: TextStyle(
         color: Colors.black,
         fontSize: 14.sp,
         fontFamily: GoogleFonts.poppins().fontFamily,
         fontWeight: FontWeight.w400,



       ),

       decoration: InputDecoration(
         border: InputBorder.none,
         hintText: hint,
         counter: const Offstage(),
           contentPadding:  EdgeInsets.only(bottom: 8.h),
         hintStyle: TextStyle(
           color: Colors.black,
           fontSize: 14.sp,
           fontFamily: GoogleFonts.poppins().fontFamily,
           fontWeight: FontWeight.w400,

         )

    ),

       onChanged: (value){
         if(value.isNotEmpty){
           FocusScope.of(context).nextFocus();
         }else{
           FocusScope.of(context).previousFocus();
         }
         onChnage();
    },
     ),
   );

  }




}