import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/screen/dashboard/home/new_home_screen.dart';
import 'package:tkd_connect/screen/more/more_screen.dart';
import 'package:tkd_connect/screen/news/allNews.dart';
import 'package:tkd_connect/utils/colors.dart';

import '../../generated/l10n.dart';
import '../directory/directory_screen.dart';
import '../my_bids/my_bids_base_screen.dart';

class BaseDashboard extends StatefulWidget{
  const BaseDashboard({super.key});

  @override
  State<StatefulWidget> createState() {

    return _BaseDashboard();
  }


}

class _BaseDashboard extends State<BaseDashboard>{
   PageController controller = PageController();
   bool isHome=true;
   bool isMyBid=false;
   bool isDrectory=false;
   bool isNews=false;
   bool isMore=false;
   bool isButtonVisible=true;
   NewHomeScreen homeScreen=NewHomeScreen();

    int maintain=0;
  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       body:WillPopScope(
         onWillPop: onWillPop,child: PageView(
           controller: controller,
           onPageChanged: (page){
             onPageChanges(page);
           },
           children: <Widget>[
             homeScreen,
             const MyBidsBaseScreen(),
             DirectoryScreen(isBase:true),
            AllNewsScreen(isBase:true),
             const MoreScreen()
           ],
         ),
       ),
       
     
       bottomNavigationBar: tabs(),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
       floatingActionButton: Visibility(
         visible: isButtonVisible,
         child: InkWell(
           onTap: ()async{
             var ob= await Navigator.pushNamed(context,AppRoutes.create_post);
             if(ob==1){
                homeScreen.refreshHome();
             }
           },
           child: Container(
             width: 155.w,
             height: 38.h,
             padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
             decoration: ShapeDecoration(
               color: ThemeColor.theme_blue,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
             ),
             child: Row(
               mainAxisSize: MainAxisSize.min,
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Text(
                   S().createPost,
                   style: TextStyle(
                     color: ThemeColor.progress_color,
                     fontSize: 12.sp,
                     fontFamily: GoogleFonts.poppins().fontFamily,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 SizedBox(
                   width: 2.w,
                 ),
                 SizedBox(
                   width: 16.w,
                   height: 16.w,
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       SizedBox(
                         width: 16.w,
                         height: 16.w,
                         child: Stack(children: [
                           SvgPicture.asset(Images.add,height: 16.h,width: 16.w,)
     
                         ]),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
         ),
   );
  }


  tabs(){
    return Container(
      width: 375.w,
      height: 80.h,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              onPageChanges(0);
            },
            child: selectedTab(isHome,S().home,Images.home),
          ),
          InkWell(
            onTap: (){
              onPageChanges(1);
            },
            child: selectedTab(isMyBid,S().myQuotes,Images.bid),
          ),
          InkWell(
            onTap: (){
              onPageChanges(2);
            },
            child: selectedTab(isDrectory,S().directory,Images.directory),
          ),
          InkWell(
            onTap: (){
              onPageChanges(3);
            },
            child: selectedTab(isNews,S().allNews,Images.message),
          ),

          InkWell(
            onTap: (){
              onPageChanges(4);
            },
            child: selectedTab(isMore,S().more,Images.more),
          )
        ],
      ),
    );

  }

  onPageChanges(int page){
    maintain=page;
    switch (page){
      case 0:
        isHome=true;
        isMyBid=false;
        isNews=false;
        isDrectory=false;
        isMore=false;
        isButtonVisible=true;
            break;

      case 1:
        isHome=false;
        isMyBid=true;
        isNews=false;
        isDrectory=false;
        isMore=false;
        isButtonVisible=false;
        break;


      case 2:
        isHome=false;
        isMyBid=false;
        isNews=false;
        isDrectory=true;
        isMore=false;
        isButtonVisible=false;
        break;

      case 3:
        isHome=false;
        isMyBid=false;
        isNews=true;
        isDrectory=false;
        isMore=false;
        isButtonVisible=false;
        break;

      case 4:
        isHome=false;
        isMyBid=false;
        isNews=false;
        isDrectory=false;
        isMore=true;
        isButtonVisible=false;
        break;
    }

    setState(() {

    });
    controller.jumpToPage(page);
  }


  selectedTab(bool isSelect,String title,String image){
    return  Container(
      height: 55.h,
      width: 75.w,
      padding:  EdgeInsets.only(top: 9.h),

      decoration: BoxDecoration(
        border: Border(

          top: BorderSide(width: 1.w, color: isSelect?ThemeColor.red:ThemeColor.white),

        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(image,height: 24.h,width: 24.h,color: isSelect?ThemeColor.red:ThemeColor.subColor,),
           SizedBox(height: 4.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelect?ThemeColor.red:ThemeColor.subColor,
              fontSize: 10.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: isSelect?FontWeight.w600:FontWeight.w400,
              letterSpacing: 0.40,

            ),
          ),
        ],
      ),
    );
  }

   Future<bool> onWillPop() {
     double? page =controller.page;
     if(maintain==0){
       SystemNavigator.pop();
     }else{
       onPageChanges(maintain-1);
     }
     return Future.value(false);
   }

}