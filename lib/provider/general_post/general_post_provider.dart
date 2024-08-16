import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/response/general_post_model.dart';
import 'package:tkd_connect/provider/base_provider.dart';

class GeneralPostProvider extends BaseProvider{

  int selectedPage=0;

  ScrollController scrollController=ScrollController();
  List<GeneralPost>generalPostList=[];

  GeneralPostProvider() : super("Ideal") {
    getAllPost();
  }

  getAllPost()async {
    String myUrl = '${ApiConstant.BASE_URL}/GeneralPost/getAll';
    print("Get All General Post : $myUrl");
    var req = await http.get(Uri.parse(myUrl));
    var response = json.decode(req.body);
    print(response);
    if (response != null) {
      List<dynamic>listData = List.from(response);
      generalPostList.clear();
      for (int i = 0; i < listData.length; i++) {
        GeneralPost generalPost = GeneralPost();
        generalPost.title = listData[i]['title'];
        generalPost.typeName = listData[i]['typeName'];

        generalPost.description = listData[i]['description'];
        generalPost.likes = listData[i]['likes'];

        generalPost.comment = listData[i]['comment'];
        generalPost.typeName = listData[i]['typeName'];

        generalPost.userId = listData[i]['userId'];
        generalPost.id = listData[i]['id'];
        generalPostList.add(generalPost);
      }
      print(listData.length);
      selectedPage++;
      notifyListeners();
    } else {
    }
  }

  getCommentList(int postId)async {
    String myUrl = '${ApiConstant.BASE_URL}/GeneralPost/getAll';
    print("Get All General Post : $myUrl");
    var req = await http.get(Uri.parse(myUrl));
    var response = json.decode(req.body);
    print(response);
    if (response != null) {
      List<dynamic>listData = List.from(response);
      generalPostList.clear();
      for (int i = 0; i < listData.length; i++) {
        GeneralPost generalPost = GeneralPost();
        generalPost.title = listData[i]['title'];
        generalPost.typeName = listData[i]['typeName'];

        generalPost.description = listData[i]['description'];
        generalPost.likes = listData[i]['likes'];

        generalPost.comment = listData[i]['comment'];
        generalPost.typeName = listData[i]['typeName'];

        generalPost.userId = listData[i]['userId'];
        generalPost.id = listData[i]['id'];
        generalPostList.add(generalPost);
      }
      print(listData.length);
      selectedPage++;
      notifyListeners();
    } else {
    }
  }
}