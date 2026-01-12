import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/model/request/rating_request.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/rating_model.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';
import 'home_screen_provider.dart';

class RatingProvider extends BaseProvider {
  BuildContext context;
  bool isLoading=true;
  RatingProvider(
      this.context
      ):super("Ideal");

  int rating = 0;
  TextEditingController commentController = TextEditingController();
  bool buttonEnable=false;

  changeRating(int rating){
    this.rating = rating;
    notifyListeners();
  }

  callSetState(){
    notifyListeners();
  }


  postRatingRaviews(BuildContext context, TruckLoad? load) async {
    final dashBoardProvider = Provider.of<HomeScreenProvider>(context, listen: false);
    User user=await LocalSharePreferences().getLoginData();
    String myUrl = ApiConstant.BASE_URL+"/companyRegistration/${load!.userId}";
    print(myUrl);
    User? userData;
    var req = await ApiHelper().apiGet(myUrl);
    print('the response is ${req.response}');
    if(req.status== 200){      // try{
      userData=User.fromJson(req.response);}

    RatingRequest ratingRequest = RatingRequest();
    ratingRequest.rating = rating;
    ratingRequest.userId = user.content!.first.id;
    ratingRequest.review = commentController.text;
    ratingRequest.companyId = userData!.content!.first.companyId;

    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.GIVE_RATING_REVIEWS,ratingRequest.toJson());
    if(apiResponse.status==200){
      print(apiResponse.response);
      RatingModel ratingModel=RatingModel.fromJson(apiResponse.response);
      ToastMessage.show(context, ratingModel.message.toString());
      ToastMessage.show(context, "Rating submitted");
      dashBoardProvider.callDashboradApi(context,0);

      isLoading=false;
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Try Again");
    }
  }
}