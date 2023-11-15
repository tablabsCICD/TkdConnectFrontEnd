import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/request/genral_post.dart';
import 'package:tkd_connect/model/request/sposered_post.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/response/userdata.dart';
import '../../utils/sharepreferences.dart';

class GenralPostProvider extends BaseProvider{
  List<String>images=[];
  bool enbleButton=false;
  GenralPostProvider(super.appState);
  TextEditingController loadWeightController=TextEditingController();
  TextEditingController vehicleSizeController=TextEditingController();

  uploadImage(BuildContext context)async{
    String image=await postImage(context);
    images.add(image);
    notifyListeners();
  }


  enble(){
    if( loadWeightController.text.isNotEmpty &&  vehicleSizeController.text.isNotEmpty
    ){
      enbleButton=true;
    }else{
      enbleButton=false;
    }
    notifyListeners();

  }

  void createPost(BuildContext context)async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    GeneralPost generalPost=GeneralPost();
    generalPost.images=images;
    generalPost.description=loadWeightController.text;
    generalPost.title=vehicleSizeController.text;
    generalPost.typeName="Genral Post";
    generalPost.comment=0;
    generalPost.likes=0;
    generalPost.loggedUserName=user.content!.first!.id!;
    generalPost.disLikes=0;
    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.BASE_URL+"GeneralPost/save", generalPost.toJson());
      if(apiResponse.status==200){
        ToastMessage.show(context, "Post saved successfully");
        Navigator.pop(context);
      } else{
        ToastMessage.show(context, "Please Tye again");
      }
  }


  void createSponsedPost(BuildContext context)async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    SponserdPost generalPost=SponserdPost();
    generalPost.images=images;
    generalPost.description=loadWeightController.text;
    generalPost.title=vehicleSizeController.text;
    generalPost.typeName="Sponsored";
    generalPost.sponsorshipAmount=0;
    generalPost.sponsorshipId=0;
    generalPost.loggedUserName=user.content!.first!.loggedUserName!;
    generalPost.paymentStatus="Done";
    ApiResponse apiResponse=await ApiHelper().postParameter("http://ec2-3-111-144-125.ap-south-1.compute.amazonaws.com:8080/TKDConnect1/api/SponsorShip/save", generalPost.toJson());
    if(apiResponse.status==200){
      ToastMessage.show(context, "Post saved successfully");
      Navigator.pop(context);
    } else{
      ToastMessage.show(context, "Please Tye again");
    }
  }

}