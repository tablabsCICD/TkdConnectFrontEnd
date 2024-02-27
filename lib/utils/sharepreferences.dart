import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';

import '../model/response/userdata.dart';
class LocalSharePreferences{
  static final LocalSharePreferences localSharePreferences = LocalSharePreferences._internal();
  factory LocalSharePreferences() {
    return localSharePreferences;
  }
  LocalSharePreferences._internal();
  setString(String key,String val)async{
   SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key,val);
  }
  setBool(String key,bool val)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(key,val);
  }
  Future<String> getString(String key)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_prefs.getString(key)==null){
      return "";
    }
    return  _prefs.getString(key)!;
  }

 Future<bool> getBool(String key)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
   bool val =false;
   if(_prefs.getBool(key)!=null){
     val=_prefs.getBool(key)!;
   }
    return val;
  }

  Future<User> getLoginData() async{
   String data  = await getString(AppConstant.LOGIN_KEY);
   User datas=User.fromJson(jsonDecode(data));
   return datas;
  }

  Future<GroupData> getCurrentGroupData() async{
    String data  = await getString(AppConstant.CURRENT_GROUP);
    GroupData groupData=GroupData.fromJson(jsonDecode(data));
    return groupData;
  }

  Future<List<GroupMember>> getGroupMemberList() async{
    String data  = await getString(AppConstant.GROUP_MEMBER);
    GroupMemberListResponse groupMemberListResponse=GroupMemberListResponse.fromJson(jsonDecode(data));
    List<GroupMember> groupMemberList = groupMemberListResponse.content!;
    return groupMemberList;
  }

  Future<bool> logOut()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
   // _prefs.clear();
    setBool(AppConstant.LOGIN_BOOl, false);
    return true;
  }

  setLanguage(String langCode)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("Lang",langCode);
  }

  Future<String> getLangCode()async{
    String val="no";
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_prefs.getString("Lang")!=null){
      val=_prefs.getString("Lang")!;
    }
    return val;
  }


}