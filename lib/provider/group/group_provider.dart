import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/screen/my_route/select_one_city.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../model/api_response.dart';
import '../../model/request/route_request.dart';
import '../../model/response/transport_directory_search.dart';
import '../../network/api_helper.dart';
import '../../screen/my_route/select_city.dart';

class GroupProvider extends  BaseProvider{
  int? userId;
  GroupProvider(this.userId) : super('Ideal'){
   // pagenationVerical();
    getGroupListByUserId(userId!);
  }
  int selectedPage=0;

  List<GroupData> groupListByUserId = [];
  List<GroupData> tempGroupListByUserId = [];
  List<GroupMember> groupMemberList = [];
  bool isLoadDone=false;

  ScrollController scrollControllerVertical = ScrollController();
  TextEditingController searchController=TextEditingController();

  getGroupListByUserId(int userId) async {
    String myUrl = ApiConstant.GET_GROUP_LIST(userId);
    print("Get Group List By User Id : $myUrl");
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);
    if(apiResponse.status==200){
      GroupListResponse groupListResponse=GroupListResponse.fromJson(apiResponse.response);
      groupListByUserId.clear();
      groupListByUserId.addAll(groupListResponse.content as Iterable<GroupData>);
      tempGroupListByUserId.addAll(groupListResponse.content as Iterable<GroupData>);
    }
    notifyListeners();
  }

  createGroup(BuildContext context,String groupName,String img,bool isPrivate) async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    Map<String,dynamic> data = {
      "createByUserId": user.content!.first.id,
      "date": "",
      "groupName": groupName,
      "imageUrl": img,
      "isPrivate": isPrivate
    };
    String myUrl = ApiConstant.CREATE_GROUP;
    print("Create Group Url : $myUrl");
    ApiResponse apiResponse=await ApiHelper().postParameter(myUrl, data);
    if(apiResponse.status==200){
      ToastMessage.show(context, "Post saved successfully");
      notifyListeners();
      Navigator.pop(context,1);
    } else{
      ToastMessage.show(context, "Please Tye again");
    }
  }


  updateGroup(BuildContext context,String groupName,String img,bool isPrivate,int groupId) async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    Map<String,dynamic> data = {
      "createByUserId": user.content!.first.id,
      "date": "",
      "id": groupId,
      "groupName": groupName,
      "imageUrl": img,
      "isPrivate": isPrivate
    };
    String myUrl = ApiConstant.CREATE_GROUP;
    print("Update Group Url : $myUrl");
    ApiResponse apiResponse=await ApiHelper().postParameter(myUrl, data);
    if(apiResponse.status==200){
      ToastMessage.show(context, "Post saved successfully");
      notifyListeners();
      Navigator.pop(context,1);
    } else{
      ToastMessage.show(context, "Please Tye again");
    }
  }




  pagenationVerical(){
    scrollControllerVertical.addListener(() {
      if (scrollControllerVertical.position.pixels ==
          scrollControllerVertical.position.maxScrollExtent) {
        getGroupListByUserId(userId!);
      }
    });
  }


  getBySearchData() async {
    if(searchController.text.length>2){
      String myUrl = ApiConstant.DIRECTORY(searchController.text);
      ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
      if(apiResponse.status==200){
        GroupListResponse groupListResponse=GroupListResponse.fromJson(apiResponse.response);
        groupListByUserId.clear();
        groupListByUserId.addAll(groupListResponse.content as Iterable<GroupData>);
      }
    }else{
      groupListByUserId.clear();
      groupListByUserId.addAll(tempGroupListByUserId);
    }
    notifyListeners();
  }





}