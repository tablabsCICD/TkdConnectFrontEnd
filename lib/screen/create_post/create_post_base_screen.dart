import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/screen/create_post/post_genral.dart';
import 'package:tkd_connect/screen/create_post/post_load.dart';
import 'package:tkd_connect/screen/create_post/post_sponsered.dart';
import 'package:tkd_connect/screen/create_post/post_vehicale.dart';
import '../../generated/l10n.dart';
import '../../utils/colors.dart';
import '../../widgets/app_bar.dart';

class CreatePostBase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatePostBase();
  }


}

class _CreatePostBase extends State<CreatePostBase>{
  bool isLoad=true;
  bool isVehicle=false;
  bool isGeneral=false;
  bool isSponsered=false;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     backgroundColor:ThemeColor.baground,
     body: SafeArea(

         child:Container(
           width: MediaQuery.of(context).size.width,
           color: ThemeColor.baground,
           margin: EdgeInsets.all(20),
           child: Column(

             children: [
               SizedBox(height: 20.h,),
               ApplicationAppBar().appBarWithBack(context, S().createPost),
               SizedBox(height: 20.h,),
               tabs(),
               Visibility(visible: isLoad,child: PostLoadScreen()),
               Visibility(visible: isVehicle,child: PostVehicleScreen()) ,
               Visibility(visible: isGeneral,child: PostGenralScreen()),
               Visibility(visible: isSponsered,child: PostSponseredScreen())

               // Expanded(
               //   child: PageView(
               //     /// [PageView.scrollDirection] defaults to [Axis.horizontal].
               //     /// Use [Axis.vertical] to scroll vertically.
               //     physics: NeverScrollableScrollPhysics(),
               //     controller: controller,
               //     onPageChanged: (page){
               //      // onPageChanges(page);
               //       controller.jumpToPage(page);
               //     },
               //     children: <Widget>[
               //       PostLoadScreen(),
               //       PostVehicleScreen(),
               //       PostGenralScreen(),
               //       PostSponseredScreen()
               //
               //     ],
               //   ),
               // ),

             ],
           ),

         ) ),

   );
  }


  tabs(){
    return Container(
      width: 335.w,
      height: 32.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0x332C363F),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.75, color: Color(0x332C363F)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabItem(isLoad,S().loads,(){
             isLoad=true;
             isVehicle=false;
             isGeneral=false;
             isSponsered=false;
            // controller.jumpToPage(0);
             setState(() {

             });
          }),
          tabItem(isVehicle,S().vehicle,(){
            isLoad=false;
            isVehicle=true;
            isGeneral=false;
            isSponsered=false;
            //controller.jumpToPage(1);
            setState(() {

            });


          }),
          tabItem(isGeneral,S().general,(){
            isLoad=false;
            isVehicle=false;
            isGeneral=true;
            isSponsered=false;
            //controller.jumpToPage(2);
            setState(() {

            });

          }),
          tabItem(isSponsered,S().sponsered,(){
            isLoad=false;
            isVehicle=false;
            isGeneral=false;
            isSponsered=true;
            //controller.jumpToPage(3);
            setState(() {

            });

          }),
        ],
      ),
    );
  }

  tabItem(bool isSelect,String title,Function onClick){
    return  Expanded(
      child: InkWell(
        onTap: (){
          onClick();
        },
        child: Container(
          height: double.infinity,
         // padding:  EdgeInsets.symmetric(horizontal: 12.h),
          decoration: ShapeDecoration(
            color: isSelect?Color(0x19001E49):ThemeColor.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: isSelect?Color(0x332C363F):ThemeColor.white),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ThemeColor.subColor,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: isSelect?FontWeight.w600:FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}