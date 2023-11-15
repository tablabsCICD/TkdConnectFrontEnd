import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tkd_connect/constant/images.dart';

class DropDown extends StatelessWidget{
 final Function onClick;
 final String hint;

  const DropDown({super.key, required this.onClick, required this.hint});


  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: ()async{
        onClick();

      },
     child: Container(
       width: 335,
       height: 52,
       padding: const EdgeInsets.symmetric(horizontal: 12),
       decoration: ShapeDecoration(
         color: Colors.white,
         shape: RoundedRectangleBorder(
           side: BorderSide(width: 1, color: Color(0x332C363F)),
           borderRadius: BorderRadius.circular(8),
         ),
       ),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             width: double.infinity,
             child: Row(
               mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Expanded(
                   child: SizedBox(
                     child: Text(
                       hint,
                       style: TextStyle(
                         color: hint.allMatches("Select One")==0?Color(0x662C363F):Colors.black,
                         fontSize: 14,
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w400,
                         height: 0,
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(width: 8),
                 Container(
                   width: 24,
                   height: 24,
                   child: Stack(children: [
                       SvgPicture.asset(Images.dwon_arrow)
                       ]),
                 ),
               ],
             ),
           ),
         ],
       ),
     ),
   );
  }

}

