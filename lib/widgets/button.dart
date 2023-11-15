import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tkd_connect/utils/colors.dart';

class Button extends StatelessWidget {
 final double width;
 final double height;
 final  String title;
 final  TextStyle textStyle;
 final Function onClick;
 bool isEnbale;

 Button({super.key, this.isEnbale=true,required this.width, required this.height, required this.title, required this.textStyle, required this.onClick});


  @override
  Widget build(BuildContext context) {
   // return InkWell(
   //   onTap: (){
   //     onClick();
   //   },
   //   child: Container(
   //     width: width,
   //     height: height,
   //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
   //     decoration: ShapeDecoration(
   //       color: Color(0xFF001E49),
   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
   //     ),
   //     child: Row(
   //       mainAxisSize: MainAxisSize.min,
   //       mainAxisAlignment: MainAxisAlignment.center,
   //       crossAxisAlignment: CrossAxisAlignment.center,
   //       children: [
   //         Text(
   //           title,
   //           style: textStyle,
   //         ),
   //       ],
   //     ),
   //   ),
   // );
    return TextButton(
      onPressed: () {
        if(isEnbale){
          onClick();
        }else{
        }
      },

      child: Container(
        width: width,
        height: height,
        decoration:  ShapeDecoration(
            color: isEnbale?ThemeColor.theme_blue:ThemeColor.border_grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
         child:  Center(
          child: Text(
            title,
            style: textStyle,
          ),
        ),
      ),
    );
  }

}