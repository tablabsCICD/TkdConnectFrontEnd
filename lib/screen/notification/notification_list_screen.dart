import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/provider/notification/notification_list_provider.dart';
import 'package:tkd_connect/screen/deeplink/deeplinkscreen.dart';
import 'package:tkd_connect/utils/colors.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../model/response/notification_list.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NotificationListScreen();
  }

}

class _NotificationListScreen extends State<NotificationListScreen> {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NotificationListProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(child: Container(
        color: ThemeColor.baground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseWidget().appBar(context, "Notifications"),
            SizedBox(height: 20.h,),
            Consumer<NotificationListProvider>(
              builder: (context, provider, child) {
                return  provider.notificationList.isNotEmpty?  listView() : const Expanded(child: Center(child: Text("Notification not found"),));
              },
            )
          ],
        ),
      )),


    );
  }

  listView() {
    return Consumer<NotificationListProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
              controller: provider.scrollController,
              itemCount: provider.notificationList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: notificationIteam(provider.notificationList[index]),
                );
              }),
        );
      },
    );
  }


  notificationIteam(NotificationModel model) {
    return InkWell(
      onTap: (){

          if(model.tableName=="FullTruckLoad"){

            int id =model.tableId!;
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DeepLink(id: id.toString(), type: 'post',)));

          }

      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,

        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Color(0x192C363F)),
            top: BorderSide(color: Color(0x192C363F)),
            right: BorderSide(color: Color(0x192C363F)),
            bottom: BorderSide(width: 1, color: Color(0x192C363F)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
               // height: 60.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BaseWidget().getImage("", height: 32.h, width: 32.w),

                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    model.title!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontFamily: AppConstant.FONTFAMILY,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                model.message!,
                                style: TextStyle(
                                  color: const Color(0x99001E49),
                                  fontSize: 10.sp,
                                  fontFamily: AppConstant.FONTFAMILY,
                                  fontWeight: FontWeight.w400,

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Spacer(),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    model.dateAndTime!,
                    style: TextStyle(
                      color: const Color(0x99001E49),
                      fontSize: 10.sp,
                      fontFamily: AppConstant.FONTFAMILY,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
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