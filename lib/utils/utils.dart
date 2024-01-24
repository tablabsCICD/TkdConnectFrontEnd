
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tkd_connect/constant/images.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../model/response/AllCard.dart';
import '../screen/dashboard/home/place_bid_screen.dart';

class Utils {


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
      }
    }

  }

  getSelectedPackageImage(int val){
    switch(val){
      case 0:
            return Images.pearls;

      case 20:
        return Images.pearls_blue;

      case 30:
        return Images.pearls_red;
      case 40:
        return Images.pearls_black;
    }

  }

  getSelectedPackageName(int val){
    switch(val){
      case 0:
        return "Clear";

      case 20:
        return "Blue";

      case 30:
        return "Red";
      case 40:
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

}