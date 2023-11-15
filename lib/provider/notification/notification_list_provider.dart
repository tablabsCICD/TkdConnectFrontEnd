import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';

import '../../model/response/notification_list.dart';

class NotificationListProvider extends BaseProvider{
  int page=0;
  ScrollController scrollController = ScrollController();
  NotificationListProvider() : super('Ideal'){
    pagenation();
    getAllNotificationList();
  }


  List<NotificationModel> notificationList = [];
  getAllNotificationList() async {

    User user=await LocalSharePreferences().getLoginData();

    String myUrl = ApiConstant.BASE_URL +'Notifications/forSpecificUser/${user.content!.first.id}?page=${page}';
    print(myUrl);
    ApiResponse req = await ApiHelper().apiWithoutDecodeGet(myUrl);

    if(req.status == 200) {

      NotificationListModel notificationListModel=NotificationListModel.fromJson(req.response);
      notificationList.addAll(notificationListModel.content!);
      print('the status code is ${notificationList.length}');
      page=page+1;
      notifyListeners();
    }
  }


  pagenation(){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
       getAllNotificationList();

      }
    });
  }

}