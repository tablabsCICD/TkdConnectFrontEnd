import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/chat_list.dart';
import '../../model/response/search_data.dart';
import '../../model/response/transport_directory_search.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../screen/message/chat_screen.dart';

class MessageProvider extends BaseProvider{

  TextEditingController searchController=TextEditingController();

  MessageProvider():super(""){
    getChatList();
  }
  List<SearchData> userSearch=[];
  List<userAdded> userChat=[];
  List<userAdded> temChat=[];
  bool isUserVisbile=true;




  searchUser(String search) async{

    if(search.length>2){
      isUserVisbile=false;
      String myUrl = ApiConstant.CHAT_USER_LIST_COMPANY(search);
      ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
      userSearch.clear();
      if(apiResponse.status==200){
        SearchDataList transportSearchData=SearchDataList.fromJson(jsonDecode(apiResponse.response));
        userSearch.addAll(transportSearchData.data!);
      }
    }else{
      isUserVisbile=true;
    }

    //   String myUrl = ApiConstant.DIRECTORY(search);
    // ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    //   userSearch.clear();
    // if(apiResponse.status==200){
    //   TransportSearchModel transportSearchData=TransportSearchModel.fromJson(apiResponse.response);
    //   userSearch.addAll(transportSearchData.content);
    // }
    notifyListeners();

  }

  getChatList()async{
    Map<String,userAdded> map={};
    User user=await LocalSharePreferences().getLoginData();
    String myUrl = ApiConstant.CHAT_USER_LIST(user.content!.first.id);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    if(apiResponse.status==200){
      List<dynamic> list = List.from(apiResponse.response);
      if(list.length>0){
        for(int i=0;i<list.length;i++){
          //userChat.add(userAdded(list[i]["name2"], list[i]["loggedUserName2"], "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1702020994041-5dbfe0b8-3474-4351-b00a-813d8bb4a92e2170825283657788568.jpg"));

           if(list[i]["mobileNumber1"]==user.content!.first.mobileNumber){
             String profile="";
             if(list[i]["userProfile2"]==null){
               profile="";
             }else{
               profile=list[i]["userProfile2"];
             }
             map[list[i]["connectionKey"]]=userAdded(list[i]["name2"], list[i]["mobileNumber2"].toString(),  profile);

           }else{
             String profile="";
             if(list[i]["userProfile1"]==null){
               profile="";
             }else{
               profile=list[i]["userProfile1"];
             }
             map[list[i]["connectionKey"]]=userAdded(list[i]["name1"], list[i]["mobileNumber1"].toString(),profile );

           }
        }
      }
     userChat= map.entries.map((entry) => entry.value).cast<userAdded>().toList();
    }
    notifyListeners();
  }

  postChatAdded(SearchData data,BuildContext context) async{



    User user=await LocalSharePreferences().getLoginData();

    String currentUserId = user.content!.first.mobileNumber!.toString();
    String peerId = data.mobileNumber!.toString();
    String groupChatId="";
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    print('the groupId is ${groupChatId}');
    Map<String ,dynamic>parameter={
      "chat": "string",
      "connectionKey": groupChatId,
      "id":0,
      "dateAndTime": "2023-12-18T03:33:29.002Z",
      "loggedTime": "2023-12-18T03:33:29.002Z",
      "loggedUserName": user.content!.first.userName,
      "loggedUserName2": data.userName!,
      "mobileNumber1": user.content!.first.mobileNumber,
      "mobileNumber2": data.mobileNumber,
      "name1": user.content!.first.firstName!+" "+user.content!.first.lastName!,
      "name2": data.firstName!+" "+data.lastName!,
      "os": "string",
      "rating": 0,
      "userId": user.content!.first.id!,
      "userId2": data.id
    };

    ApiResponse apiResponse=await ApiHelper().postParameterDecode(ApiConstant.POST_CHAT, parameter);
      if(apiResponse.status==200){
      getNewaddedList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            arguments: ChatPageArguments(
              peerId: data.mobileNumber!.toString(),
              peerAvatar: "",
              peerNickname: data.firstName!+" "+data.lastName!,
            ),
          ),
        ),
      );

    }else{
     ToastMessage.show(context, "Please try");
    }
  }
  
  

  getNewaddedList()async{
    Map<String,userAdded> map={};
    User user=await LocalSharePreferences().getLoginData();
    String myUrl = ApiConstant.CHAT_USER_LIST(user.content!.first.id);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    if(apiResponse.status==200){
      List<dynamic> list = List.from(apiResponse.response);
      if(list.length>0){
        for(int i=0;i<list.length;i++){
          //userChat.add(userAdded(list[i]["name2"], list[i]["loggedUserName2"], "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1702020994041-5dbfe0b8-3474-4351-b00a-813d8bb4a92e2170825283657788568.jpg"));

          map[list[i]["connectionKey"]]=userAdded(list[i]["name2"], list[i]["loggedUserName2"], "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1702020994041-5dbfe0b8-3474-4351-b00a-813d8bb4a92e2170825283657788568.jpg");
        }
      }
      userChat.clear();
      userChat= map.entries.map((entry) => entry.value).cast<userAdded>().toList();
    }
    notifyListeners();
  }

}
class userAdded{
  final String name;
  final String userId;
  final String profile;

  userAdded(this.name, this.userId, this.profile);
}
