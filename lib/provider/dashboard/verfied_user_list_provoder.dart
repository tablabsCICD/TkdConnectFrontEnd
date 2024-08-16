import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/group_member_list.dart';
import '../../model/response/verified_user.dart';
import '../../network/api_helper.dart';
import '../base_provider.dart';

class VerifiedUserProvider extends BaseProvider {
  bool isEdit;
  String sourceCity;
  List<GroupMember> groupMemberList = [];
  List<UserVerifiedData> allUserList = [];
  List<UserVerifiedData>filterByName=[];
  List<UserVerifiedData>selectedUsers=[];
  String changeImageUrl='';
  TextEditingController searchController=TextEditingController();
  VerifiedUserProvider(this.isEdit,this.sourceCity) : super('Ideal'){
    getListOfVefiyUser();
  }





  getListOfVefiyUser() async {
    String myUrl = ApiConstant.GET_USER_SOURCE_LIST(sourceCity);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    if(apiResponse.status==200){
      VerifiedUser verifiedUser =VerifiedUser.fromJson(jsonDecode(apiResponse.response));
      allUserList.addAll(verifiedUser.data!);
      filterByName.addAll(allUserList);
   }
    notifyListeners();
  }

  void filterUser(String text) {
    


  }

  void selectedUser(bool? value, UserVerifiedData filterByName) {
    filterByName.isSelected=value;
    if(value==true){
      selectedUsers.add(filterByName);
    }else{
      selectedUsers.remove(filterByName);
    }
    notifyListeners();

  }




}