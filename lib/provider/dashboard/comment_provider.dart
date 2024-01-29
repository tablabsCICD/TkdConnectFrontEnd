import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:http/http.dart' as http;
import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/comment_response.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';

class CommentProvider extends BaseProvider {
  BuildContext context;
  int postId;
  int countComment=0;
  int countLike=0;
  bool isLoading=true;
  CommentProvider(
      this.context,this.postId
      ):super("Ideal"){

    getCommentByPostId(context,postId);
    pagenation(context);
  }

  int selectedPage=0;
  List<Comments> commentList = [];
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController=ScrollController();


  getCommentByPostId(BuildContext context,int PostId) async {
    User user=await LocalSharePreferences().getLoginData();
    ApiResponse apiResponse=await ApiHelper().apiGet(ApiConstant.GETCOMMENTS(PostId));
    if(apiResponse.status==200){
      CommentResponse commentResponse=CommentResponse.fromJson(apiResponse.response);
      countComment=commentResponse.data!.commentCount!;
      countLike=commentResponse.data!.generalPost!.likes!;
      commentList.clear();
      commentList.addAll(commentResponse.data!.comments as Iterable<Comments>);
      selectedPage++;
      isLoading=false;
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Try Again");
    }
  }



  createCommentApi(int postId, String comment)async{

    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    EasyLoading.show(status: "Loading");
    String url=ApiConstant.BASE_URL+"comments";

    print('the url $url');

    Map<String, dynamic> requestParameter = {
      "comment": comment,
      "date": "string",
      "discussionId": postId,
      "firstName": user.content!.first.firstName,
      "lastName": user.content!.first.lastName,
      "userId": user.content!.first.id!
    };
    print(requestParameter);
    /*  ApiResponse apiResponse=await ApiHelper().postParameter(url, requestParameter);
    print(apiResponse.status);*/
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestParameter));
    EasyLoading.dismiss();
    if(response.statusCode==200){
      commentController.clear();
      notifyListeners();
        getCommentByPostId(context, postId);

    } else{
      print("Comment not save successfully");
    }
    notifyListeners();

  }

  likeIncreamentApi(int postId, BuildContext context)async{

    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    EasyLoading.show(status: "Loading");
    String url=ApiConstant.BASE_URL+"GeneralPost/incrementLike?postId=${postId}";

    print('the url $url');

    var req = await http.post(Uri.parse(url));
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      if(response['success']==true){
        print(response['message']);
        countLike=countLike+1;

      }else{
        print(response['message']);
      }
      EasyLoading.dismiss();
      notifyListeners();
    }
  }


  pagenation(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        selectedPage++;
        getCommentByPostId(context,postId);

      }
    });
  }

}