import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/utils/colors.dart';

class PlanWidget extends StatelessWidget{
  bool isSelected;
  String title;
  String amount;
  String image;
  String subtitle;
  Function? onClick;

  PlanWidget({super.key, required this.isSelected, required this.title, required this.amount, required this.image,required this.subtitle,this.onClick});


  @override
  Widget build(BuildContext context) {
    return Container(
     width: 335.w,
     height: 80.h,
     padding: EdgeInsets.only(left: 12.w,right: 12.w,top: 12.h,bottom: 12.h),
     clipBehavior: Clip.antiAlias,
     decoration: ShapeDecoration(
       color: isSelected ? ThemeColor.select_green_plan:ThemeColor.white,
       shape: RoundedRectangleBorder(
         side: BorderSide(width: 0.50.w, color: isSelected ?ThemeColor.select_green_plan:ThemeColor.white),
         borderRadius: BorderRadius.circular(16.r),
       ),
     ),
     child: Row(
       mainAxisSize: MainAxisSize.min,
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [

         SvgPicture.asset(image),

         Expanded(
           child: SizedBox(
             height: 52.h,
             child: Row(
               mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(
                   child: Container(

                     margin: EdgeInsets.only(left: 12.w),child: Column(
                       mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           title,
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 16.sp,
                             fontFamily: GoogleFonts.poppins().fontFamily,
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                         SizedBox(height: 4.h),
                         InkWell(
                           onTap: (){

                             onClick!();
                             // showModalBottomSheet<void>(
                             //     isScrollControlled: true,
                             //     context: context,
                             //     builder: (BuildContext context) {
                             //       return FractionallySizedBox(heightFactor: 0.9,child: PlanDetailsScreen());
                             //     });
                           },
                           child: Text(
                             'Click here',
                             style: TextStyle(
                               color: ThemeColor.red,
                               fontSize: 12.sp,
                               fontFamily: GoogleFonts.poppins().fontFamily,
                               fontWeight: FontWeight.w600,
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
                 Expanded(
                   child: Container(
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         SizedBox(
                           width: double.infinity,
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.end,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 '₹',
                                 textAlign: TextAlign.right,
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: 16.sp,
                                   fontFamily: GoogleFonts.poppins().fontFamily,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                               Text(
                                 amount,
                                 textAlign: TextAlign.right,
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: 16.sp,
                                   fontFamily: GoogleFonts.poppins().fontFamily,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ],
                           ),
                         ),
                         const SizedBox(height: 4),
                         Visibility(
                           visible: isSelected,
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                             decoration: ShapeDecoration(
                               color: const Color(0x19001E49),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Text(
                                   subtitle,
                                   style: const TextStyle(
                                     color: Color(0xCC001E49),
                                     fontSize: 10,
                                     fontFamily: 'Poppins',
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ],
     ),
   );
  }


}