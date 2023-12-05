import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/screen/create_post/post_genral.dart';
import 'package:tkd_connect/screen/create_post/post_load.dart';
import 'package:tkd_connect/screen/create_post/post_sponsered.dart';
import 'package:tkd_connect/screen/create_post/post_vehicale.dart';
import 'package:tkd_connect/screen/my_post/my_post.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../utils/colors.dart';
import '../../widgets/app_bar.dart';

class MyPostBase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPostBase();
  }


}

class _MyPostBase extends State<MyPostBase>{
  bool isLoad=true;
  bool isGeneralPost=false;
  bool isBuySell=false;
  bool isJob=false;
  PageController controller = PageController();
  int currentPage=0;
  List<String>listImages=[Images.load_post,Images.vehicle_load,Images.general_post];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:ThemeColor.baground,
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: ThemeColor.baground,
        margin: EdgeInsets.all(20),
        child: Column(

          children: [
            SizedBox(height: 20.h,),
            ApplicationAppBar().appBarWithBack(context, S().myPost),
            SizedBox(height: 20.h,),
            tabs(),
            SizedBox(height: 20.h,),
            Visibility(visible: isLoad,child: MyPostScreen()),
            Visibility(visible: isGeneralPost,child: PostVehicleScreen()) ,
            Visibility(visible: isBuySell,child: PostGenralScreen()),
            Visibility(visible: isJob,child: PostSponseredScreen())


          ],
        ),

      ),

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
            isGeneralPost=false;
            isBuySell=false;
            isJob=false;
            // controller.jumpToPage(0);
            currentPage=0;
            setState(() {

            });
          }),
          tabItem(isGeneralPost,S().general,(){
            isLoad=false;
            isGeneralPost=true;
            isBuySell=false;
            isJob=false;
            currentPage=1;
            //controller.jumpToPage(1);
            setState(() {

            });


          }),
          tabItem(isBuySell,S().buy+"/"+S().sell,(){
            isLoad=false;
            isGeneralPost=false;
            isBuySell=true;
            isJob=false;
            currentPage=2;
            //controller.jumpToPage(2);
            setState(() {

            });

          }),
          tabItem(isJob,S().jobs,(){
            isLoad=false;
            isGeneralPost=false;
            isBuySell=false;
            isJob=true;
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
            color: isSelect?ThemeColor.theme_blue:ThemeColor.white,
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
                  color: isSelect?ThemeColor.progress_color:ThemeColor.subColor,
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