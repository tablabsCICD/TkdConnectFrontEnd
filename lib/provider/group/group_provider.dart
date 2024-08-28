import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/api_response.dart';
import '../../network/api_helper.dart';
import 'package:http/http.dart' as http;

class GroupProvider extends  BaseProvider{
  int groupId;
  BuildContext context;
  GroupProvider(this.groupId,this.context) : super('Ideal'){
    getGroupListByUserId();
    if(groupId!=0){
      getGroupMember(context,groupId);
    }
    }


  int selectedPage=0;

  GroupData? currentGroup;
  List<GroupData> groupListByUserId = [];
  List<GroupData> tempGroupListByUserId = [];
  List<GroupMember> groupMemberList = [];
  bool isLoadDone=false;
  bool buttonEnable = false;
  ScrollController scrollControllerVertical = ScrollController();
  TextEditingController searchController=TextEditingController();
  TextEditingController groupNameController=TextEditingController();

  callSetState()async{
    await getGroupListByUserId();
    notifyListeners();
  }

  getGroupListByUserId() async {
    EasyLoading.show(status: "Loading");
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.GET_GROUP_LIST(user.content!.first.id);
    print("Get Group List By User Id : $myUrl");
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);
    EasyLoading.dismiss();
    if(apiResponse.status==200){
      GroupListResponse groupListResponse=GroupListResponse.fromJson(apiResponse.response);
      groupListByUserId.clear();
      groupListByUserId.addAll(groupListResponse.content as Iterable<GroupData>);
      tempGroupListByUserId.addAll(groupListResponse.content as Iterable<GroupData>);

    }
    isLoadDone=true;
    notifyListeners();
  }

  pagenationVerical(){
    scrollControllerVertical.addListener(() {
      if (scrollControllerVertical.position.pixels ==
          scrollControllerVertical.position.maxScrollExtent) {
        getGroupListByUserId();
      }
    });
  }

  groupSearch(String query){
    print(query);
    groupListByUserId.clear();
    notifyListeners();
    for (var element in tempGroupListByUserId) {
      if (element.groupName!.toLowerCase().contains(query.toLowerCase())) {
        groupListByUserId.add(element);
      }
    }
    debugPrint('Final Leads : ${groupListByUserId.length}');
    notifyListeners();
  }

  removeMemberFromGroup(int memberId,int index)async{
    ApiHelper apiHelper=ApiHelper();
    var res=await http.delete(Uri.parse(ApiConstant.REMOVE_GROUP_MEMBER.toString()+"$memberId"));
    if(res.statusCode==200){
      memberList.removeAt(index);
      notifyListeners();
    }
  }

  deleteGroup(int groupId,int index)async{
    ApiHelper apiHelper=ApiHelper();
    String myUrl = ApiConstant.DELETE_GROUP.toString()+"$groupId";
    print(myUrl);
    var res=await http.delete(Uri.parse(myUrl));
    print(res.body);
    if(res.statusCode==200){
      groupListByUserId.removeAt(index);
      notifyListeners();
    }
  }

  List<GroupMember> memberList = [];
  getGroupMember(BuildContext context,int groupId)async{
    memberList.clear();
    ApiHelper apiHelper=ApiHelper();
    EasyLoading.show(status: "Loading");
    ApiResponse response=await apiHelper.apiWithoutDecodeGet(ApiConstant.GROUP_MEMBER_LIST+groupId.toString());
    if(response.status==200){
      GroupMemberListResponse groupListModel=GroupMemberListResponse.fromJson(response.response);
      LocalSharePreferences().setString(AppConstant.GROUP_MEMBER, jsonEncode(groupListModel.content));
      memberList.addAll(groupListModel.content!);
    }else{
      ToastMessage.show(context, "Please try again");
    }

    EasyLoading.dismiss();
    notifyListeners();
  }
}