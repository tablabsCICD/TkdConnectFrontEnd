import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/request/create_group.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/search_data.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:http/http.dart' as http;
import '../../model/api_response.dart';
import '../../network/api_helper.dart';

class GroupProvider extends  BaseProvider{
  GroupProvider() : super('Ideal'){
    getGroupListByUserId();
    getAllUserList(false);
  }
  int selectedPage=0;

  List<GroupData> groupListByUserId = [];
  List<GroupData> tempGroupListByUserId = [];
  List<GroupMember> groupMemberList = [];
  bool isLoadDone=false;
  bool buttonEnable = false;
  ScrollController scrollControllerVertical = ScrollController();
  TextEditingController searchController=TextEditingController();
  TextEditingController groupNameController=TextEditingController();

  getGroupListByUserId() async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.GET_GROUP_LIST(user.content!.first.id);
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
        getGroupListByUserId();
      }
    });
  }

  groupSearch(String query){
    print(query);
    groupListByUserId.clear();
    notifyListeners();
    tempGroupListByUserId.forEach((element) {
      if (element.groupName!.toLowerCase().contains(query.toLowerCase())) {
        groupListByUserId.add(element);
      }
    });
    debugPrint('Final Leads : ${groupListByUserId.length}');
    notifyListeners();
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

  callSetState(){
    notifyListeners();
  }

  bool isLoading=false;
  bool isFirstLoading=false;
  List<UserData> allUserList = [];
  List<UserData>filterByName=[];
  List<UserData>selectedUsers=[];
  List<GroupMember>listAddedMember=[];
  bool create_Group=false;
  String imageUrl='https://cdn.pixabay.com/photo/2016/03/23/22/26/user-1275780_1280.png';
 // List<GroupData?>listGroup=[];
  String changeImageUrl='';

  getAllUserList(bool isFromEdit) async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();

    selectedUsers=[];
    isLoading = true;
    notifyListeners();
    if(allUserList.length==0){
      String myUrl = ApiConstant.BASE_URL +'companyRegistration?page=${0}&size=6000';
      print(myUrl);
      var responseBody=await ApiHelper().apiWithoutDilogDecodeGet(myUrl);
      print(responseBody.response);
      isFirstLoading= false;
      var type = User.fromJson(responseBody.response);
      allUserList.addAll(type.content!);
    }
    isLoading = false;
    //filterByName.addAll(allUserList);
    if(isFromEdit==true){
      for(int i=0;i<allUserList.length;i++){
        allUserList[i].addedIngroup=false;
        for(int j=0;j<listAddedMember.length;j++){
          if(allUserList[i].id==listAddedMember[j].userId){
            allUserList[i].addedIngroup=true;
          }
        }

        if(allUserList[i].id != user.content!.first.id){
          filterByName.add(allUserList[i]);
        }

      }
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

  GroupData? currentGroup;
  seletedGroupObject(GroupData groupData){
    currentGroup=groupData;
  }

  uploadProfileImage(BuildContext context)async{
    changeImageUrl =await postImage(context);
    notifyListeners();
  }

  filterUser(String name) async {
    if(name.length > 2) {
      filterByName.clear();
      notifyListeners();
      /* for(int i=0;i<allUserList.length;i++){
        if(allUserList[i].firstName!.toLowerCase().contains(name.toLowerCase())==true||allUserList[i].lastName!.toLowerCase().contains(name.toLowerCase())==true){
          filterByName.add(allUserList[i]);
        }
      }*/
      String myUrl = ApiConstant.CHAT_USER_LIST_COMPANY(name);
      print(myUrl);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
      print(apiResponse.response);
      if (apiResponse.status == 200) {
        SearchDataList searchDataList = SearchDataList.fromJson(
            jsonDecode(apiResponse.response));

        for(int i=0;i<searchDataList.data!.length-1;i++){
         SearchData element = searchDataList.data![i];
         UserData userData = UserData(id: element.id,
             addedIngroup: false,
             alternativeNumber: element.alternativeNumber,
             aadharCard: element.aadharCard,
             companyName: element.companyName,
             country: element.country,
             companyLogo: element.companyLogo,
             companyAddress: element.companyAddress,
             companyId: element.companyId,
             city: element.city,
             deviceId: element.deviceId,
             emailId: element.emailId,
             firstName: element.firstName,
             isUserVerifiedByCompany: element.isUserVerifiedByCompany,
             isPaid: element.isPaid,
             idOfMainBranch: element.idOfMainBranch,
             isSelected: false,
             loggedUserName: element.loggedUserName,
             loggedTime: element.loggedTime,
             lastName: element.lastName,
             landlineNumber: element.landlineNumber,
             mobileNumber: element.mobileNumber,
             numberOfTimesRating: element.numberOfTimesRating,
             mainBranch: element.mainBranch,
             otp: element.otp,
             os: element.os,
             profilePicture: element.profilePicture,
             preferredRouresEntered: element.preferredRouresEntered,
             password: element.password,
             paidStartDate: element.paidStartDate,
             ratings: element.ratings,
             state: element.state,
             transporterOrAgent: element.transporterOrAgent,
             userName: element.userName,
             verified: element.verified,
             validTill: element.validTill,
             website: element.website
         );
         filterByName.add(userData);
        }
      /*  searchDataList.data!.forEach((element) {
          UserData userData = UserData(id: element.id,
              addedIngroup: false,
              alternativeNumber: element.alternativeNumber,
              aadharCard: element.aadharCard,
              companyName: element.companyName,
              country: element.country,
              companyLogo: element.companyLogo,
              companyAddress: element.companyAddress,
              companyId: element.companyId,
              city: element.city,
              deviceId: element.deviceId,
              emailId: element.emailId,
              firstName: element.firstName,
              isUserVerifiedByCompany: element.isUserVerifiedByCompany,
              isPaid: element.isPaid,
              idOfMainBranch: element.idOfMainBranch,
              isSelected: false,
              loggedUserName: element.loggedUserName,
              loggedTime: element.loggedTime,
              lastName: element.lastName,
              landlineNumber: element.landlineNumber,
              mobileNumber: element.mobileNumber,
              numberOfTimesRating: element.numberOfTimesRating,
              mainBranch: element.mainBranch,
              otp: element.otp,
              os: element.os,
              profilePicture: element.profilePicture,
              preferredRouresEntered: element.preferredRouresEntered,
              password: element.password,
              paidStartDate: element.paidStartDate,
              ratings: element.ratings,
              state: element.state,
              transporterOrAgent: element.transporterOrAgent,
              userName: element.userName,
              verified: element.verified,
              validTill: element.validTill,
              website: element.website
          );
          filterByName.add(userData);
        });*/
      } else {
        filterByName.addAll(allUserList);
      }
    }
    notifyListeners();
  }

  selectedUser(bool? value,UserData userObj){
    userObj.isSelected=value;

    if(value==true){
      selectedUsers.add(userObj);
    }else{
      selectedUsers.remove(userObj);
    }
    notifyListeners();
  }

  callCreateGroupApi(int? userId,String groupName,BuildContext context)async{
    isLoading=true;
    showLoader(context);
    String date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());

    Map<String,dynamic>data={
      'createByUserId':userId,
      'groupName':groupName,
      'isPrivate':0,
      'imageUrl':imageUrl,
      'date':date

    };
    String myUrl = ApiConstant.CREATE_GROUP;
    print("Create Group Url : $myUrl");
    ApiResponse apiResponse=await ApiHelper().postParameter(myUrl, data);
    print(apiResponse.response);
    if(apiResponse.status==200){
      GroupCreateModel model=GroupCreateModel.fromJson(apiResponse.response);
     callGroupMember(model.id,userId,context,false);
    }else{
      isLoading=false;
      showLoader(context);
      notifyListeners();
    }
  }

  void callGroupMember(int? groupId,int? userId,BuildContext context,bool isFrom) async{
    String date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    List<GroupMember>selectedUserId=[];
    for(int i=0;i<selectedUsers.length;i++){
      String? dpName= selectedUsers[i].firstName!+" "+selectedUsers[i].lastName!;
      selectedUserId.add(GroupMember(displayName:dpName,userId: selectedUsers[i].id));
    }
    ApiHelper apiHelper=ApiHelper();
    Map<String,dynamic>parameter={
      'addedByUserId':userId,
      'groupId':groupId,
      'date':date,
      'listOfUsers':selectedUserId,

    };
    var response=await apiHelper.postParameter(ApiConstant.ADD_GROUP_MEMBER,parameter);
    if(response==200){
      isLoading=false;
      create_Group=true;

      if(isFrom==true){
        getGroupMember(groupId!);
      }else{
        await getAllGroup(userId, context);
        showLoader(context);
        goToNextPage(context);
      }

      //notifyListeners();
    }else{
      isLoading=false;
      showLoader(context);
      notifyListeners();

    }

  }


  showLoader(context){
    if(isLoading){
      //Loader().showLoaderDialog(context);
      EasyLoading.show(status: "Loading");
    }else{
      //Loader().dismissLoader(context);
      EasyLoading.dismiss();
    }
  }
  goToNextPage(BuildContext context){
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });


  }

  getAllGroup(int? userId,context)async{
    print('the id is +${userId}');
    groupListByUserId.clear();
    isLoading=true;
    //showLoader(context);
    ApiHelper apiHelper=ApiHelper();
    var response=await apiHelper.apiGet(ApiConstant.GET_GROUP_LIST(userId));
    GroupListResponse groupListModel=GroupListResponse.fromJson(response.response);
    groupListByUserId.addAll(groupListModel.content!);
    isLoading=false;
    //showLoader(context);
    notifyListeners();
  }

  getGroupMember(int groupId)async{
    listAddedMember.clear();
    isLoading=true;
    //showLoader(context);
    ApiHelper apiHelper=ApiHelper();
    var response=await apiHelper.apiWithoutDecodeGet(ApiConstant.GROUP_MEMBER_LIST+groupId!.toString());
    GroupMemberListResponse groupListModel=GroupMemberListResponse.fromJson(response.response);

    listAddedMember.addAll(groupListModel.content!);
    isLoading=false;
    //showLoader(context);
    notifyListeners();

  }

  removeMemberFromGroup(int memberId,int index)async{
    ApiHelper apiHelper=ApiHelper();
    var res=await http.delete(Uri.parse("${ApiConstant.REMOVE_GROUP_MEMBER}"+"${memberId.toString()}"));
    if(res.statusCode==200){
      listAddedMember.removeAt(index);
      notifyListeners();
    }
  }


  deleteGroup(int groupId,int index)async{
    ApiHelper apiHelper=ApiHelper();
    String myUrl = "${ApiConstant.DELETE_GROUP}"+"${groupId.toString()}";
    print(myUrl);
    var res=await http.delete(Uri.parse(myUrl));
    print(res.body);
    if(res.statusCode==200){
      groupListByUserId.removeAt(index);
      notifyListeners();
    }
  }





}