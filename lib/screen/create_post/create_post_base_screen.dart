import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/screen/create_post/post_genral.dart';
import 'package:tkd_connect/screen/create_post/post_load.dart';
import 'package:tkd_connect/screen/create_post/post_sponsered.dart';
import 'package:tkd_connect/screen/create_post/post_vehicale.dart';
import '../../constant/images.dart';
import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';
import '../../utils/colors.dart';
import '../../widgets/app_bar.dart';

class CreatePostBase extends StatefulWidget {
  const CreatePostBase({super.key});

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
  int currentPage=0;
  List<String>listImages=[Images.load_post,Images.vehicle_load,Images.general_post];
  late User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     backgroundColor:ThemeColor.baground,
     body: SafeArea(

         child:Container(
           width: MediaQuery.of(context).size.width,
           color: ThemeColor.baground,
           margin: const EdgeInsets.all(20),
           child: Column(

             children: [
               //SizedBox(height: 20.h,),
               ApplicationAppBar().appBarWithBack(context, S().createPost),
               SizedBox(height: 20.h,),
               SvgPicture.asset(
                 listImages[currentPage],
                 height: 133.h,
                 width: 200.w,
               ),
               SizedBox(height: 10.h,),
               tabs(),
               Visibility(visible: isLoad,child: const PostLoadScreen()),
               Visibility(visible: isVehicle,child: const PostVehicleScreen()) ,
               Visibility(visible: isGeneral,child: const PostGenralScreen()),
               Visibility(visible: isSponsered,child: const PostSponseredScreen())

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
        color: const Color(0x332C363F),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.75, color: Color(0x332C363F)),
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
             currentPage=0;
             setState(() {

             });
          }),
          AppConstant.USERTYPE==AppConstant.TRANSPOTER || AppConstant.AGENT==AppConstant.USERTYPE || AppConstant.MANUFACTURE==AppConstant.USERTYPE ?   tabItem(isVehicle,S().vehicle,(){
            isLoad=false;
            isVehicle=true;
            isGeneral=false;
            isSponsered=false;
            currentPage=1;
            //controller.jumpToPage(1);
            setState(() {

            });


          }):const SizedBox(),
          tabItem(isGeneral,S().general,(){
            isLoad=false;
            isVehicle=false;
            isGeneral=true;
            isSponsered=false;
            currentPage=2;
            //controller.jumpToPage(2);
            setState(() {

            });

          }),
          // tabItem(isSponsered,S().sponsered,(){
          //   isLoad=false;
          //   isVehicle=false;
          //   isGeneral=false;
          //   isSponsered=true;
          //   //controller.jumpToPage(3);
          //   setState(() {
          //
          //   });
          //
          // }),
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
              side: BorderSide(color: isSelect?const Color(0x332C363F):ThemeColor.white),
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