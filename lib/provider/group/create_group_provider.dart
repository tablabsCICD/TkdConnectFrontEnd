
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/request/create_group.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/search_data.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

class CreateGroupProvider extends BaseProvider{

  CreateGroupProvider(this.isEdit) : super('Ideal'){
    getAllUserList(isEdit);
  }

  bool isEdit;
  bool buttonEnable = false;

  List<GroupMember> groupMemberList = [];
  List<SearchData> allUserList = [];
  List<SearchData>filterByName=[];
  List<SearchData>selectedUsers=[];
  List<GroupMember>listAddedMember=[];
  GroupData? currentGroup;
  bool create_Group=false;
  String imageUrl='https://cdn.pixabay.com/photo/2016/03/23/22/26/user-1275780_1280.png';
  String changeImageUrl='';

  TextEditingController searchController=TextEditingController();
  TextEditingController groupNameController=TextEditingController();

  getAllUserList(bool isFromEdit) async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    selectedUsers=[];
    notifyListeners();
    EasyLoading.show(status: "Loading");
    if(allUserList.isEmpty){
     // String myUrl = ApiConstant.BASE_URL +'companyRegistration?page=${0}&size=1000';
      String myUrl = ApiConstant.CHAT_USER_LIST_COMPANY(' ');
      print(myUrl);
      var responseBody=await ApiHelper().apiWithoutDilogDecodeGet(myUrl);
      EasyLoading.dismiss();
      var type = SearchDataList.fromJson(json.decode(responseBody.response));
      allUserList.addAll(type.data!);
      print("All Users ${allUserList.length}");
    }
    if(isFromEdit==true){
      currentGroup = await LocalSharePreferences.localSharePreferences.getCurrentGroupData();
      await getGroupMember(currentGroup!.id!);
      print(listAddedMember.length);
      print("All Added ${listAddedMember.length}");
      for(int i=0;i<allUserList.length;i++){
        allUserList[i].addedIngroup=false;
        for(int j=0;j<listAddedMember.length;j++){
          if(allUserList[i].id==listAddedMember[j].userId){
            allUserList[i].addedIngroup=true;
            selectedUsers.add(allUserList[i]);
          }
        }
        if(allUserList[i].id != user.content!.first.id){
          filterByName.add(allUserList[i]);
        }
      }
      print("All Users ${selectedUsers.length}");

    }else{
      for(int i=0;i<allUserList.length;i++){
        allUserList[i].isSelected=false;
        if(allUserList[i].id != user.content!.first.id){
          filterByName.add(allUserList[i]);
        }
      }
    }
    notifyListeners();
  }

  getGroupMember(int groupId)async{
    listAddedMember.clear();
    ApiHelper apiHelper=ApiHelper();
    var response=await apiHelper.apiWithoutDecodeGet(ApiConstant.GROUP_MEMBER_LIST+groupId.toString());
    GroupMemberListResponse groupListModel=GroupMemberListResponse.fromJson(response.response);
    LocalSharePreferences().setString(AppConstant.GROUP_MEMBER, jsonEncode(groupListModel.content));
    listAddedMember.addAll(groupListModel.content!);
    for(int i=0;i<allUserList.length;i++){
      allUserList[i].addedIngroup=false;
      allUserList[i].isSelected= false;
      for(int j=0;j<listAddedMember.length;j++){
        if(allUserList[i].id==listAddedMember[j].userId){
          allUserList[i].addedIngroup=true;
          allUserList[i].isSelected = true;
          selectedUsers.add(allUserList[i]);
        }
      }
    }
    notifyListeners();
  }

  createGroupApi(int? userId,String groupName,List<SearchData> memberList,BuildContext context)async{
    String date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    Map<String,dynamic>data={
      'createByUserId':userId,
      'groupName':groupName,
      'isPrivate':0,
      'imageUrl':changeImageUrl,
      'date':date
    };
    String myUrl = ApiConstant.CREATE_GROUP;
    print("Create Group Url : $myUrl");
    ApiResponse apiResponse=await ApiHelper().postParameter(myUrl, data);
    print(apiResponse.response);
    if(apiResponse.status==200){
      GroupCreateModel model=GroupCreateModel.fromJson(apiResponse.response);
      callGroupMember(model.id,userId,context,false,memberList);
    }else{
      notifyListeners();
    }
  }

  callGroupMember(int? groupId,int? userId,BuildContext context,bool isFrom,List<SearchData> memberList) async{
    String date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    List<GroupMember>selectedUserId=[];
    print("selected users ${memberList.length}");
    for(int i=0;i<memberList.length;i++){
      String? dpName= "${memberList[i].firstName!} ${memberList[i].lastName!}";
      selectedUserId.add(GroupMember(displayName:dpName,userId: memberList[i].id,email: memberList[i].emailId,location: memberList[i].city,contact: memberList[i].mobileNumber));
    }
    print("selected group member ${selectedUserId.length}");
    ApiHelper apiHelper=ApiHelper();
    Map<String,dynamic>parameter={
      'addedByUserId':userId,
      'groupId':groupId,
      'date':date,
      'listOfUsers':selectedUserId,
    };

    var response=await apiHelper.postParameter(ApiConstant.ADD_GROUP_MEMBER,parameter);
    if(response.status==200){
      create_Group=true;
      if(isFrom==true){
       // getGroupMember(groupId!);
        ToastMessage.show(context, "group edited successfully");

      }else{
        ToastMessage.show(context, "group created successfully");
      }
      goToNextPage(context);

    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  goToNextPage(BuildContext context){
    int count = 0;
   /* Navigator.popUntil(context, (route) {
      return count++ == 2;
    });*/
    Navigator.pop(context,1);
  }

  uploadProfileImage(BuildContext context)async{
    changeImageUrl =await postImage(context);
    notifyListeners();
  }

  Future<void> setData() async {
    currentGroup = await LocalSharePreferences.localSharePreferences.getCurrentGroupData();
    groupNameController.text = currentGroup!.groupName!;
    changeImageUrl = currentGroup!.imageUrl!;
    notifyListeners();
  }

  filterUser(String name) async {
    if(name.length > 2) {
      filterByName.clear();
      String myUrl = ApiConstant.CHAT_USER_LIST_COMPANY(name);
      print(myUrl);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
      print(apiResponse.response);
      if (apiResponse.status == 200) {
        SearchDataList searchDataList = SearchDataList.fromJson(
            jsonDecode(apiResponse.response));
        for(int i=0;i<searchDataList.data!.length;i++){
          SearchData element = searchDataList.data![i];
          filterByName.add(element);
        }
      } else {
        filterByName.addAll(allUserList);
      }
    }
    notifyListeners();
  }

  selectedUser(bool? value,SearchData userObj){
    userObj.isSelected=value;
    if(value==true){
      selectedUsers.add(userObj);
    }else{
      selectedUsers.remove(userObj);
    }
    notifyListeners();
  }

  seletedGroupObject(GroupData groupData){
    currentGroup=groupData;
    LocalSharePreferences().setString(AppConstant.CURRENT_GROUP, jsonEncode(groupData));
  }

  callUpdateGroupApi(int? userId,String groupName,List<SearchData> memberList,BuildContext context)async{
    String date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    currentGroup = await LocalSharePreferences.localSharePreferences.getCurrentGroupData();
    Map<String,dynamic>data={
      'createByUserId':userId,
      'groupName':groupName,
      'isPrivate':0,
      'imageUrl':changeImageUrl,
      'date':date,
      'id': currentGroup!.id!
    };
    String myUrl = ApiConstant.UPDATE_GROUP;
    print("update Group Url : $myUrl");
    ApiResponse apiResponse=await ApiHelper().apiPut(myUrl, data);
    print(apiResponse.response);
    if(apiResponse.status==200){
      GroupCreateModel model=GroupCreateModel.fromJson(apiResponse.response);
      callGroupMember(model.id,userId,context,true,memberList);
    }else{
      notifyListeners();
    }
  }


}
