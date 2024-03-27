import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/ChatList.dart';
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
    setUpTimedFetch();
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


    notifyListeners();

  }

  getChatList()async{
    userChat.clear();
    Map<String,userAdded> map={};
    User user=await LocalSharePreferences().getLoginData();
    String myUrl = ApiConstant.CHAT_USER_LIST_DATE_SORT(user.content!.first.id);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);

    if(apiResponse.status==200){
     // print('the ${apiResponse.response}');
      ChatListDate chatList=ChatListDate.fromJson(jsonDecode(apiResponse.response));
      if(chatList.data!.length!=0){
        for(int i=0;i<chatList.data!.length;i++){
          if(chatList.data![i].mobileNumber1 ==user.content!.first.mobileNumber){
            userAdded userChatAdded=userAdded(chatList.data![i].name2!,chatList.data![i].mobileNumber2!.toString(),chatList.data![i].userProfile2==null?"":chatList.data![i].userProfile2!,chatList.data![i].id!,chatList.data![i].userId2!);
            userChat.add(userChatAdded);
          }else{
            userAdded userChatAdded=userAdded(chatList.data![i].name1!,chatList.data![i].mobileNumber1!.toString(),chatList.data![i].userProfile1==null?"":chatList.data![i].userProfile1!,chatList.data![i].id!,chatList.data![i].userId!);
            userChat.add(userChatAdded);
          }
        }
      }
    notifyListeners();

    }else{

    }
    // if(apiResponse.status==200){
    //   List<dynamic> list = List.from(apiResponse.response);
    //   if(list.length>0){
    //     for(int i=0;i<list.length;i++){
    //        if(list[i]["mobileNumber1"]==user.content!.first.mobileNumber){
    //          String profile="";
    //          if(list[i]["userProfile2"]==null){
    //            profile="";
    //          }else{
    //            profile=list[i]["userProfile2"];
    //          }
    //          map[list[i]["connectionKey"]]=userAdded(list[i]["name2"], list[i]["mobileNumber2"].toString(),  profile);
    //
    //        }else{
    //          String profile="";
    //          if(list[i]["userProfile1"]==null){
    //            profile="";
    //          }else{
    //            profile=list[i]["userProfile1"];
    //          }
    //
    //          map[list[i]["connectionKey"]]=userAdded(list[i]["name1"], list[i]["mobileNumber1"].toString(),profile );
    //
    //        }
    //     }
    //   }
    //  userChat= map.entries.map((entry) => entry.value).cast<userAdded>().toList();
    // }
    notifyListeners();
  }

  getChatListWithoutDialog()async{
    userChat.clear();
    Map<String,userAdded> map={};
    User user=await LocalSharePreferences().getLoginData();
    String myUrl = ApiConstant.CHAT_USER_LIST_DATE_SORT(user.content!.first.id);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDilogDecodeGet(myUrl);

    if(apiResponse.status==200){
     // print('the ${apiResponse.response}');
      ChatListDate chatList=ChatListDate.fromJson(jsonDecode(apiResponse.response));
      if(chatList.data!.length!=0){
        for(int i=0;i<chatList.data!.length;i++){
          if(chatList.data![i].mobileNumber1 ==user.content!.first.mobileNumber){
            userAdded userChatAdded=userAdded(chatList.data![i].name2!,chatList.data![i].mobileNumber2!.toString(),chatList.data![i].userProfile2==null?"":chatList.data![i].userProfile2!,chatList.data![i].id!,chatList.data![i].userId2!);
            userChat.add(userChatAdded);
          }else{
            userAdded userChatAdded=userAdded(chatList.data![i].name1!,chatList.data![i].mobileNumber1!.toString(),chatList.data![i].userProfile1==null?"":chatList.data![i].userProfile1!,chatList.data![i].id!,chatList.data![i].userId!);
            userChat.add(userChatAdded);
          }
        }
      }
      notifyListeners();

    }else{

    }
    // if(apiResponse.status==200){
    //   List<dynamic> list = List.from(apiResponse.response);
    //   if(list.length>0){
    //     for(int i=0;i<list.length;i++){
    //        if(list[i]["mobileNumber1"]==user.content!.first.mobileNumber){
    //          String profile="";
    //          if(list[i]["userProfile2"]==null){
    //            profile="";
    //          }else{
    //            profile=list[i]["userProfile2"];
    //          }
    //          map[list[i]["connectionKey"]]=userAdded(list[i]["name2"], list[i]["mobileNumber2"].toString(),  profile);
    //
    //        }else{
    //          String profile="";
    //          if(list[i]["userProfile1"]==null){
    //            profile="";
    //          }else{
    //            profile=list[i]["userProfile1"];
    //          }
    //
    //          map[list[i]["connectionKey"]]=userAdded(list[i]["name1"], list[i]["mobileNumber1"].toString(),profile );
    //
    //        }
    //     }
    //   }
    //  userChat= map.entries.map((entry) => entry.value).cast<userAdded>().toList();
    // }
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
              id: data.id!,
              peerId: data.mobileNumber!.toString(),
              peerAvatar: data.profilePicture.toString(),
              peerNickname: data.firstName!+" "+data.lastName!,
              notificationId: data.id!
            ),
          ),
        ),
      );

    }else{
     ToastMessage.show(context, "Please try");
    }
  }
  
  

  getNewaddedList()async{
    userChat.clear();
    Map<String,userAdded> map={};
    User user=await LocalSharePreferences().getLoginData();
    String myUrl = ApiConstant.CHAT_USER_LIST_DATE_SORT(user.content!.first.id);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);

    if(apiResponse.status==200){
      print('the ${apiResponse.response}');
      ChatListDate chatList=ChatListDate.fromJson(jsonDecode(apiResponse.response));
      if(chatList.data!.length!=0){
        for(int i=0;i<chatList.data!.length;i++){
          if(chatList.data![i].mobileNumber1 ==user.content!.first.mobileNumber){
            userAdded userChatAdded=userAdded(chatList.data![i].name2!,chatList.data![i].mobileNumber2!.toString(),chatList.data![i].userProfile2==null?"":chatList.data![i].userProfile2!,chatList.data![i].id!,chatList.data![i].userId2!);
            userChat.add(userChatAdded);
          }else{
            userAdded userChatAdded=userAdded(chatList.data![i].name1!,chatList.data![i].mobileNumber1!.toString(),chatList.data![i].userProfile1==null?"":chatList.data![i].userProfile1!,chatList.data![i].id!,chatList.data![i].userId!);
            userChat.add(userChatAdded);
          }
        }
      }
      notifyListeners();

    }else{

    }
    notifyListeners();
  }

  late Timer time;
  setUpTimedFetch() {
   time= Timer.periodic(Duration(milliseconds: 5000), (timer) {
      getChatListWithoutDialog();

    });
  }

  stopTimer(){
    time.cancel();
  }

}
class userAdded{
  final String name;
  final String userId;
  final String profile;
  final int id;
  final int notificationUserId;

  userAdded(this.name, this.userId, this.profile, this.id,this.notificationUserId);
}
