import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../generated/l10n.dart';
import '../../model/response/userdata.dart';

class HelpSupportProvider extends BaseProvider{
  String dropValue=S().chooseATopic;
  String remaningText="300 ${S().charactersMax}";
  bool enableButton =false;

  TextEditingController textEditingController=TextEditingController();


  HelpSupportProvider(super.appState);



  changeDropDown(String val){
    dropValue=val;
    notifyListeners();
  }

  sumbitTicket(BuildContext context)async{
    if(dropValue==S().chooseATopic){
      ToastMessage.show(context, S().pleaseSelectTopic);
    }else{
      User user=await LocalSharePreferences().getLoginData();
      final now = DateTime.now();

      if(textEditingController.text.isNotEmpty){
        Map<String,dynamic>parameter={
          "concern": textEditingController.text,
          "id": 0,
          "loggedUserName": "${user.content!.first.userName}",
          "topic": dropValue
        };

        ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.HELPSUPPORTIKET,parameter);
        print('the code is ${apiResponse.status}${apiResponse.response}');
        if(apiResponse.status==200){
          ToastMessage.show(context, "Ticket send successfully");
          dropValue=S().chooseATopic;
          textEditingController.clear();
          notifyListeners();
        }else{
          ToastMessage.show(context, "Please try again");
        }


      }else{
        ToastMessage.show(context, "Please Explain your concern");
      }


    }
    validation();
    notifyListeners();
  }

  countText(){
    int tot=300-textEditingController.text.length;
    remaningText="$tot ${S().charactersRemaining}";
    validation();
    notifyListeners();
  }

  validation(){
    if(dropValue!=S().chooseATopic&&textEditingController.text.isNotEmpty){
      enableButton=true;
    }else{
      enableButton=false;
    }

  }



}