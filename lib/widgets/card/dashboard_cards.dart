import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/model/response/my_post_bid_list.dart';
import 'package:tkd_connect/screen/edit_post/edit_post_base_screen.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/provider/dashboard/home_screen_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../constant/images.dart';
import '../../model/response/AllCard.dart';
import '../../provider/dashboard/delete_interface.dart';
import '../../route/app_routes.dart';
import '../../utils/utils.dart';
import 'base_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllCards {
  cardLoad(int index, BuildContext context, TruckLoad load, {int userId = 0}) {
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
          BaseWidget().heading(
              load.topicName!, getDateObject(load.postingTime), load.content!),
          load.userId == userId
              ? BaseWidget().deleteButton((val) {
                  if (val == 10) {
                  }else if(val==6){

                    Navigator.pushNamed(context, AppRoutes.editpost,arguments: load);
                  }
                  else {
                    Utils().openMenu(val, load, context);
                  }
                }, true)
              : BaseWidget().bidButton((val) {
                  Utils().openMenu(val, load, context);
                })
        ],
      ),
    );
  }

  cardLoadHome(int index, BuildContext context, TruckLoad load, int userId,
      DeletePostInf postDelete, HomeScreenProvider provider) {
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
              verify: load.isverified!,
              transporterOrAgent: load.transporterOrAgent!),
          BaseWidget().routes(load.source!, load.destination!),
          SizedBox(
            height: 12.h,
          ),
          imageLoad(load),
          BaseWidget().heading(
              load.topicName!, getDateObject(load.postingTime), load.content!),
          load.userId == userId
              ? BaseWidget().deleteButton((val) {
                  if (val == 10) {
                    postDelete.deleteOwnPost(load.id!, index);
                  } else {
                    if (load.dnd == 1) {
                      ToastMessage.show(context, "This is DND Post");
                    } else {
                      if (val == 6) {
                        //Navigator.pop(context);

                        Future.delayed(Duration(seconds: 1), () async {

                          PostBidData postBidData=PostBidData();
                          postBidData.genericCardsDto=GenericCardsDto();
                          postBidData.genericCardsDto!.id=load.id;
                          postBidData.genericCardsDto!.mobileNumber=load.mobileNumber;
                          postBidData.genericCardsDto!.companyName=load.companyName;
                          postBidData.genericCardsDto!.cargoType=load.typeOfCargo;
                          postBidData.genericCardsDto!.vehicleWeight=load.loadWeight;
                          postBidData.genericCardsDto!.vehicleSize=load.vehicleSize;
                          postBidData.genericCardsDto!.typeOfPayment=load.typeOfPayment;
                          postBidData.genericCardsDto!.source=load.source;
                          postBidData.genericCardsDto!.destination=load.destination;
                          postBidData.genericCardsDto!.dnd=load.dnd;
                          postBidData.genericCardsDto!.privatePost=load.privatePost;
                          int a= await Navigator.push(context, MaterialPageRoute(builder: (_)=> EditPostBase(postBidData)));

                          postDelete.refreshHomeScreen();


                        });

                      } else {
                        Utils().openMenu(val, load, context,
                            providerHome: provider);
                      }
                    }
                  }
                }, true)
              : BaseWidget().bidButton((val) {
                  if (load.dnd == 1) {
                    if(val ==0){
                      Utils()
                          .openMenu(val, load, context, providerHome: provider);
                    }else{
                      ToastMessage.show(context, "This is DND Post");
                    }

                  } else {


                    Utils()
                        .openMenu(val, load, context, providerHome: provider);
                  }
                })
        ],
      ),
    );
  }

  getDateObject(String? dateTime) {
    try {
      DateTime formatedDate = DateTime.parse(dateTime!);
      // print(formatedDate);
      var date1 = DateFormat("yyyy-MM-dd").format(formatedDate);
      var todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if (date1 == todayDate) {
        date1 = DateFormat("H:mm").format(formatedDate);
      }
      return date1;
    } catch (e) {
      return dateTime;
    }
  }

  cardLoadPrivateHome(int index, BuildContext context, TruckLoad load,
      int userId, DeletePostInf postDelete,HomeScreenProvider provider) {
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
          BaseWidget().heading(
              load.topicName!, getDateObject(load.postingTime), load.content!),

          load.userId == userId
              ? BaseWidget().deleteButton((val) {
                  if (val == 10) {
                    postDelete.deleteOwnPost(load.id!, index);
                  } else {


                  }
                }, true)
              : BaseWidget().bidButton((val) {
                  // Utils().openMenu(val, load, context);
                  if(val==0){
                    Utils().openMenu(val, load, context, providerHome: provider);
                  }else{
                    ToastMessage.show(context, "This is Private Post");
                  }

                })
        ],
      ),
    );
  }

  imageLoad(TruckLoad load) {
    if (load.postImages!.length == 0) {
      return Column(
        children: [
          SizedBox(
            height: 0.h,
          ),
        ],
      );
    } else if (load.postImages!.length == 1) {
      return Column(
        children: [
          BaseWidget().image(image: load.postImages!.first),
          SizedBox(
            height: 9.h,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget()
                  .carouseImage(new List<String>.from(load.postImages!))),
          SizedBox(
            height: 9.h,
          ),
        ],
      );
    }
  }



  generalPost(TruckLoad truckLoad, BuildContext context) {
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
              onTap: () {
                String des = "Type: General Post" +
                    "\n " +
                    "Title: " +
                    truckLoad.topicName! +
                    "\n " +
                    "Description: " +
                    truckLoad.content! +
                    "\n " +
                    "Link: " +
                    truckLoad.sharableLink!;
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
            child: BaseWidget().profileWithUser(truckLoad.companyLogo!,
                truckLoad.nameOfPerson!, truckLoad.companyName!,
                verify: truckLoad.isverified!,
                transporterOrAgent: truckLoad.transporterOrAgent!),
          ),
          // SizedBox(
          //   height: 12.h,
          // ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget().heading(truckLoad.topicName!,
                  getDateObject(truckLoad.postingTime), truckLoad.content!)),
          SizedBox(
            height: 5.h,
          ),

          imagePost(truckLoad, context),
        ],
      ),
    );
  }

  imagePost(TruckLoad load, BuildContext context) {
    if (load.postImages!.length == 0) {
      return Column(
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
              child: BaseWidget()
                  .likeComment(likeCount: 0, commentCount: 0, load, context))
        ],
      );
    } else if (load.postImages!.length == 1) {
      return Column(
        children: [
          BaseWidget().image(image: load.postImages!.first),
          SizedBox(
            height: 9.h,
          ),
          Container(
              //transform: Matrix4.translationValues(0.0, -5.0.h, 00),
              child: BaseWidget()
                  .likeComment(likeCount: 0, commentCount: 0, load, context))
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0.h, 00),
              child: BaseWidget()
                  .carouseImage(new List<String>.from(load.postImages!))),
          SizedBox(
            height: 9.h,
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -10.0.h, 00),
              child: BaseWidget()
                  .likeComment(likeCount: 0, commentCount: 0, load, context))
        ],
      );
    }
  }

  cardAdv(int index, BuildContext context, TruckLoad load, {int userId = 0}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => imageDialogAdd(
              load.companyName, load.postImages!.first, context, load),
        );
      },
      child: Container(
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
              onTap: () async {
                final url = Uri.parse(
                    // 'http://${load.website}',
                    '${load.website}');
                await launchUrl(url);
              },
              child: BaseWidget().headingMobile(load.companyName!, load.mobileNumber.toString(), load.website!),
            ),
          ],
        ),
      ),
    );
  }

  cardSellBuyPost(int index, BuildContext context, TruckLoad load,
      {int userId = 0}) {
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
                color: Color(0xffd0a232),
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
          SizedBox(height: 8.w),
          BaseWidget().profileWithUser(
              load.companyLogo!, load.nameOfPerson!, load.companyName!,
              verify: load.isverified!,
              transporterOrAgent: load.transporterOrAgent!),
          BaseWidget().headingWithDescription(
              load.topicName!,
              getDateObject(load.postingTime),
              load.mfgYear!,
              load.modelName!,
              load.estPrice!,
              false),
          SizedBox(height: 8.w),
          imageLoad(load),
          load.userId == userId
              ? BaseWidget().deleteButton((val) {
                  if (val == 10) {
                  } else {
                    Utils().openMenu(val, load, context);
                  }
                }, false)
              : BaseWidget().getInTouchButton((val) {
                  Utils().openMenu(val, load, context);
                })
        ],
      ),
    );
  }

  cardJobPost(int index, BuildContext context, TruckLoad load,
      {int userId = 0}) {
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
                color: Color(0xFFd35e61),
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
          BaseWidget().profileWithUser(
              load.companyLogo!, load.nameOfPerson!, load.companyName!,
              verify: load.isverified!,
              transporterOrAgent: load.transporterOrAgent!),
          BaseWidget().headingWithDescription("Job Title",
              getDateObject(load.postingTime), "-", load.topicName!, '', true),
          SizedBox(height: 8.w),
          BaseWidget().heading("Job Description", '', load.content!),
          load.userId == userId
              ? BaseWidget().deleteButton((val) {
                  if (val == 10) {
                  } else {
                    Utils().openMenu(val, load, context);
                  }
                }, false)
              : jobApply(load, context)
        ],
      ),
    );
  }

  Widget jobApply(TruckLoad load, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Utils().callFunction(load.mobileNumber.toString());
              /*String Message="I am writing to express my strong interest in the our department"+" From TKD Connect Application";
                Utils().openwhatsapp(context, load.mobileNumber!, Message);*/
            },
            child: Container(
              height: 38.h,
              //width: 203.w,//for save job
              width: 240.w,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50.w, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Call now',
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  SizedBox(width: 12.w),
          // SvgPicture.asset(Images.savejob),
          SizedBox(width: 12.w),
          InkWell(
              onTap: () {
                String Message =
                    "I am writing to express my strong interest in the our department" +
                        " From TKD Connect Application";
                Utils().openwhatsapp(context, load.mobileNumber!, Message);
              },
              child: SvgPicture.asset(Images.message_job)),
        ],
      ),
    );
  }

  Widget imageDialogAdd(text, path, context, load) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          imageLoadAddA(load, context),
        ],
      ),
    );
  }

  imageLoadAddA(TruckLoad load, BuildContext context) {
    if (load.postImages!.length == 0) {
      return Column(
        children: [
          SizedBox(
            height: 0,
          ),
        ],
      );
    } else if (load.postImages!.length == 1) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: load.postImages!.first,
              placeholder: (context, url) =>
                  SvgPicture.asset("assets/svg/logo.svg"),
              errorWidget: (context, url, error) => ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.height - 100,
                  )),
              fit: BoxFit.fill,
              width: 500.w,
              height: 500.h,
            ),
          ),
          SizedBox(
            height: 9,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                  padEnds: false,
                  pageSnapping: false,
                  enableInfiniteScroll: false,
                ),
                items: load.postImages!
                    .map((item) => Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: imageLink(item!)),
                          ),
                        ))
                    .toList(),
              ))),
          SizedBox(
            height: 9,
          ),
        ],
      );
    }
  }

  Widget imageLink(String link) {
    return CachedNetworkImage(
      imageUrl: link,
      placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
      errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
            fit: BoxFit.fill,
            width: 311,
            height: 200,
          )),
      fit: BoxFit.fill,
      width: 311,
      height: 200,
    );
  }
}
