
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:tkd_connect/constant/images.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/widgets/rating_dailog.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../model/response/AllCard.dart';
import '../screen/dashboard/home/place_bid_screen.dart';


class Utils {

  void requestReview(BuildContext context) async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
     // inAppReview.requestReview();
      final RateMyApp rateMyApp = RateMyApp(
          minDays: 0,
          minLaunches: 1,
          remindDays: 0,
          remindLaunches: 1,
          googlePlayIdentifier: 'com.pdk.tkd'
      );
      rateMyApp.init().then((value) {
        if(rateMyApp.shouldOpenDialog){
          rateMyApp.conditions.forEach((element) { if(element is DebuggableCondition){
            print(element.valuesAsString);
          }
          });
          rateMyApp.showRateDialog(
              context,
              title: 'Rate This App.',
              message: 'If you like this app, please take a little bit of your time to review it! \nIt really help us and it shouldn\'t take you more than a minute',
              rateButton: "RATE",
              laterButton: "MAYBE LATER",
              ignoreNativeDialog: true,
              dialogStyle: DialogStyle(titleStyle: TextStyle(color: Colors.green,
                fontSize: 16.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,),messageStyle: TextStyle(color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,)),
              onDismissed: (){
                rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
              },
            listener: (button){
                switch(button){
                  case RateMyAppDialogButton.rate:print("Clicked on rate");
                  break;
                  case RateMyAppDialogButton.later:print("Clicked on Later");
                  break;
                  case RateMyAppDialogButton.no:print("Clicked on No");
                  break;
                }
                return true;
            }
          );
        }
      });
    } else {
        final String packageName = 'com.pdk.tkd';
        final String appId = 'your_app_id';
        final String url = Platform.isAndroid
            ? 'https://play.google.com/store/apps/details?id=$packageName'
            : 'https://apps.apple.com/app/your_app_name/id$appId';

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }

    }
  }

  callFunction(String mobile)async{

    final call = Uri.parse('tel:+91$mobile');
    if (await canLaunchUrl(call)) {
    launchUrl(call);
    } else {
    throw 'Could not launch $call';
    }
  }

  callShareFunction(String des){
    Share.share(des);

  }


  callRatingAndReview(context,TruckLoad load){

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.58, child: RatingDialog(load));
        });

  }

  Future openwhatsapp(BuildContext context,int number,String text,) async{
    final link = WhatsAppUnilink(
      phoneNumber: "+91 ${number}",
      text: text,
    );
    await launch('$link');
  }

  openMenu(int a,TruckLoad load,BuildContext context)async{
    if(a==0){
      showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
                heightFactor: 0.6,
                child: PlaceBidScreen( truckLoad: load,));
          });

    }else{
      String description= "${load
          .mobileNumber
          .toString()}'Type : ${load.type}, \nSubject : ${load.content}, \nSource : ${load.source}, \nDestination : ${load.destination}, \nLink : https://api.tkdost.com/bids/?id=${load.id}'";

      switch (a){
        case 1:
          Utils().openwhatsapp(context, load.mobileNumber!,description);
          return;
        case 2:
          await Utils().callFunction("${load.mobileNumber}");
          return;

        case 3:
          Utils().callShareFunction(description);
          return;

        case 4:
          User user=await LocalSharePreferences().getLoginData();
          Utils().callRatingAndReview(context,load);
          return;  
      }
    }

  }

  getSelectedPackageImage(int val){
    switch(val){
      case 0:
            return Images.pearls;

      case 10:
        return Images.pearls_blue;

      case 20:
        return Images.pearls_red;
      case 30:
        return Images.pearls_black;
    }

  }

  getSelectedPackageName(int val){
    switch(val){
      case 0:
        return "Clear";

      case 10:
        return "Blue";

      case 20:
        return "Red";
      case 30:
        return "Black";
    }

  }

 String getTranport(int val){
    switch(val){
      case 0:
        return "Transporters";

      case 1:
        return "Agents/Brokers";

      case 2:
        return "PACKERS AND MOVERS";
      case 3:
        return "MANUFACTURERS";
      case 4:
        return "DISTRIBUTORS";
      case 5:
        return "CLEARING AND FORWARDING AGENTS";
      default:
        return "";
    }



  }

  String mainTag(String tag){
    switch(tag){
      case 'Full load available':
        return 'Full load available';
      case 'Part load available':
        return 'Part load available';
      case 'Full load required':
        return 'Full vehicle required';
      case 'Part load required':
        return 'Part vehicle required';


      case '':

    }


    return "";
  }



}