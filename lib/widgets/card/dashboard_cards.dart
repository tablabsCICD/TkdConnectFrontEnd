import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/provider/dashboard/home_screen_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../constant/images.dart';
import '../../model/response/AllCard.dart';
import '../../provider/dashboard/delete_interface.dart';
import '../../utils/utils.dart';
import 'base_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
class AllCards {


  cardLoad(int index, BuildContext context, TruckLoad load,{int userId=0}) {
    return Container(
      width: 335.w,
      // height: 255.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  load.mainTag!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          BaseWidget().profile(
              load.companyLogo!, load.nameOfPerson!, load.companyName!,
              verify: load.isPaid!),
          BaseWidget().routes(load.source!, load.destination!),
          SizedBox(
            height: 12.h,
          ),
          imageLoad(load),
          BaseWidget().heading(load.topicName!, getDateObject(load.postingTime), load.content!),


         load.userId==userId ?BaseWidget().deleteButton((val) {
           if(val==10){

           }else{
             Utils().openMenu(val, load, context);
           }

         }) :BaseWidget().bidButton((val) {
            Utils().openMenu(val, load, context);
          })
        ],
      ),
    );
  }





  cardLoadHome(int index, BuildContext context, TruckLoad load,int userId,DeletePostInf postDelete) {
    return Container(
      width: 335.w,
      // height: 255.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  Utils().mainTag(load.mainTag!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          BaseWidget().profileWithUser(
              load.companyLogo!, load.nameOfPerson!, load.companyName!,
              verify: load.isPaid!,transporterOrAgent: load.transporterOrAgent!),
          BaseWidget().routes(load.source!, load.destination!),
          SizedBox(
            height: 12.h,
          ),
          imageLoad(load),
          BaseWidget().heading(load.topicName!, getDateObject(load.postingTime), load.content!),


          load.userId==userId ?BaseWidget().deleteButton((val) {
            if(val==10){
                postDelete.deleteOwnPost(load.id!,index);
            }else{
              if(load.dnd==0){
                ToastMessage.show(context, "This is DND Post");
              }else{
                Utils().openMenu(val, load, context);
              }

            }

          }) :BaseWidget().bidButton((val) {
            if(load.dnd==0){
              ToastMessage.show(context, "This is DND Post");
            }else{
              Utils().openMenu(val, load, context);
            }
          })
        ],
      ),
    );
  }

  getDateObject(String? dateTime){
    try{
      DateTime formatedDate = DateTime.parse(dateTime!);
      print(formatedDate);
      var date1 = DateFormat("yyyy-MM-dd").format(formatedDate);
      var todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if(date1 == todayDate){
        date1 = DateFormat("H:mm").format(formatedDate);
      }
      return date1;
    }catch(e){
      return dateTime;
    }

  }

  cardLoadPrivateHome(int index, BuildContext context, TruckLoad load,int userId,DeletePostInf postDelete) {
    return Container(
      width: 335.w,
      // height: 255.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  load.mainTag!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // BaseWidget().profileWithUser(
          //     "load.companyLogo!", load.nameOfPerson!, load.companyName!,
          //     verify: load.isPaid!),
          BaseWidget().routes(load.source!, load.destination!),
          SizedBox(
            height: 12.h,
          ),
          imageLoad(load),
          BaseWidget().heading(load.topicName!, getDateObject(load.postingTime), load.content!),


          load.userId==userId ?BaseWidget().deleteButton((val) {
            if(val==10){
              postDelete.deleteOwnPost(load.id!,index);
            }else{

                ToastMessage.show(context, "This is Private Post");
              //Utils().openMenu(val, load, context);
            }

          }) :BaseWidget().bidButton((val) {
           // Utils().openMenu(val, load, context);
            ToastMessage.show(context, "This is Private Post");
          })
        ],
      ),
    );
  }


  imageLoad(TruckLoad load){
    if(load.postImages!.length==0){
      return    Column(
        children: [
          SizedBox(
            height: 0.h,
          ),

        ],
      );
    }else if(load.postImages!.length==1){
      return Column(
        children: [
          BaseWidget().image(image: load.postImages!.first),
          SizedBox(
            height: 9.h,
          ),
        ],
      );
    }else{

      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().carouseImage(new List<String>.from(load.postImages!))),
          SizedBox(
            height: 9.h,
          ),
        ],
      );
    }

  }


  generalPost(TruckLoad truckLoad,BuildContext context) {
    return Container(
      width: 335.w,

      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: (){
                String des=truckLoad.topicName!+"\n "+truckLoad.content!;
                Utils().callShareFunction(des);
              },
              child: Container(
                width: 38.w,
                height: 38.h,
                child: SvgPicture.asset(
                  Images.share_icon,
                  height: 38.h,
                  width: 38.w,
                ),
              ),
            ),
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().profile(truckLoad.companyLogo!, truckLoad.nameOfPerson!, truckLoad.companyName!,verify: truckLoad.isPaid!)),
          // SizedBox(
          //   height: 12.h,
          // ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().heading(truckLoad.topicName!, getDateObject(truckLoad.postingTime), truckLoad.content!)),
          SizedBox(
            height: 5.h,
          ),

          imagePost(truckLoad,context),

        ],
      ),
    );
  }

  imagePost(TruckLoad load,BuildContext context){
    if(load.postImages!.length==0){
      return    Column(
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -20.0.h, 00),
            width: 311.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 311.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50.w,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0x332C363F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),

          Container(
              transform: Matrix4.translationValues(0.0, -10.0.h, 00),
              child: BaseWidget().likeComment(likeCount: 0,commentCount: 0,load,context))
        ],
      );
    }else if(load.postImages!.length==1){
      return Column(
        children: [
          BaseWidget().image(image: load.postImages!.first),
          SizedBox(
            height: 9.h,
          ),
          Container(
            //transform: Matrix4.translationValues(0.0, -5.0.h, 00),
              child: BaseWidget().likeComment(likeCount: 0,commentCount: 0,load,context))
        ],
      );
    }else{

      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().carouseImage(new List<String>.from(load.postImages!))),
          SizedBox(
            height: 9.h,
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -10.0.h, 00),
              child: BaseWidget().likeComment(likeCount: 0,commentCount: 0,load,context))
        ],
      );
    }

  }



  cardAdd(int index, BuildContext context, TruckLoad load,{int userId=0}) {
    return Container(
      width: 335.w,
      // height: 255.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8.r,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100.w,
              height: 18.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: ShapeDecoration(
                color: Color(0xFFD9462A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              child: Center(
                child: Text(
                  load.type!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.w),

          imageLoad(load),
          InkWell(
            onTap: ()async{
              final url = Uri.parse(
                'http://${load.website}',
              );
             await  launchUrl(url);
            },
            child: BaseWidget().heading(load.companyName!, "", load.website!),
          )

        ],
      ),
    );
  }

}