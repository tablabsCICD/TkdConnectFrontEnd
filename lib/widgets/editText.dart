import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/utils/colors.dart';

class EditText extends StatelessWidget {
  final double width;
  final double height;
  final String hint ;
  final TextEditingController controller;
  TextInputType? keybordType=TextInputType.text;
  Function(String val)? onChange =(val){};
  Function()? onTap =(){};
  bool? readOnly=false;

   EditText({this.readOnly=false,this.onChange,this.onTap,super.key,this.keybordType ,required this.width, required this.height, required this.hint, required this.controller} );



  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
     // height: height,
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.w, color: ThemeColor.border_grey),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Expanded(
                child: SizedBox(
                  child: TextField(
                    controller: controller,
                    onTap: (){
                      onTap==null?null:
                      onTap!();
                    },
                    onChanged: (value){
                      onChange==null?null:
                      onChange!(value);

                    },
                    readOnly: readOnly!,
                    keyboardType: keybordType,
                    decoration: InputDecoration(
                      hintText: hint,

                      border: InputBorder.none,
                      hintStyle:TextStyle(
                        color: const Color(0x662C363F),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}



class EditTextError extends StatelessWidget {
  final double width;
  final double height;
  final String hint ;
  final TextEditingController controller;
  TextInputType? keybordType=TextInputType.text;
  Function(String val)? onChange =(val){};
  bool? readOnly=false;
  bool? validate;

  EditTextError({this.validate,this.readOnly=false,this.onChange,super.key,this.keybordType ,required this.width, required this.height, required this.hint, required this.controller} );



  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
     // height: height,
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50.w, color:validate!? ThemeColor.border_grey:ThemeColor.red),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Expanded(
                child: SizedBox(
                  child: TextField(
                    controller: controller,
                    onChanged: (value){
                      onChange!(value);

                    },
                    readOnly: readOnly!,
                    keyboardType: keybordType,

                    decoration: InputDecoration(
                        hintText: hint,


                        border: InputBorder.none,
                        hintStyle:TextStyle(
                          color: const Color(0x662C363F),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}