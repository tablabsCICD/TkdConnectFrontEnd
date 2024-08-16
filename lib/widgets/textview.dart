import 'package:flutter/material.dart';

class Textview extends StatelessWidget {
 final String title;

 TextStyle style= const TextStyle(
   color: Colors.white,
   fontSize: 8,
   fontFamily: 'Poppins',
   fontWeight: FontWeight.w600,
 );

   Textview(this.style,{super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return
      Text(
        title,
        style: style,
      );
  }


}