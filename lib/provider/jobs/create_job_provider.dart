import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../generated/l10n.dart';
import '../../screen/jobs/experience_screen.dart';

class CreateJobProvider extends BaseProvider{
  CreateJobProvider(super.appState);

  TextEditingController positionController=TextEditingController();
  TextEditingController JobTitileController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController salController=TextEditingController();
  bool buttonActive=false;
  String expFrom=S().from;
  String expTo=S().to;
  bool expUpdate=false;
  String selectSal="Select salary";

  List<String>salary=["1 LPA ","1LAP - 2LPA","2LAP - 3LPA","4LAP - 5LPA","6LAP - 7LPA","8LAP - 9LPA","9LAP - 10LPA","10LAP - Above"];


  showExpDialog(BuildContext context)async{
    String? cityName= await showModalBottomSheet<String?>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9,
              child: ExperienceScreen());
        });
    if(cityName!=null){
      expFrom=cityName!.split(",").first;
      expTo=cityName!.split(",").last;
      expUpdate=true;
      buttonEnble();
      notifyListeners();
    }
  }



  buttonEnble(){
    if(positionController.text.isNotEmpty && descriptionController.text.isNotEmpty && JobTitileController.text.isNotEmpty && salController.text.isNotEmpty){
      if(expFrom==S().from && expTo==S().to){
        buttonActive=false;
      }else{
        buttonActive=true;
      }

    }else{
      buttonActive=false;
    }
    notifyListeners();
  }

  onSubitJobPost(BuildContext context)async{
    LocalSharePreferences localSharePreferences=LocalSharePreferences();
    User user=await localSharePreferences.getLoginData();
    Map<String, dynamic> data = {
      "companyName": user.content!.first.companyName,
      "contactNumber":user.content!.first.mobileNumber,
      "emailId": user.content!.first.emailId,
      "experience": expTo+"-"+expFrom,

      "isSalaryNegotiable":  1 ,
      "isSelected": 0,
      "jobDepartment": JobTitileController.text,
      "jobDescription": descriptionController.text,
      "jobLocation": "city",
      "jobType": positionController.text,
      "loggedTime":'',// DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now()), //+" "+DateTime.now().hour.toString() +":" +DateTime.now().minute.toString() ,
      "loggedUserName": user.content!.first.userName,
      "mainTag": "Job Seeker",
      "message": descriptionController.text,
      "os": "App",
      "postingTime": '',//DateTime.now(),// DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now()), // +" "+DateTime.now().hour.toString() +":" +DateTime.now().minute.toString() ,
      "loggedUserName": user.content!.first.userName,
      "privatePost": 0,
      "removedDate": '' ,
      "salary": salController.text,
      "tableName": " ",
      "topicName": " ",
      "type": "Job Seeker",
      "userId":user.content!.first.id
    };
    print('the respo ${json.encode(data)}');
    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.POST_JOB, data);
    if(apiResponse.status==200){
      ToastMessage.show(context, "Post job successfull");
      Navigator.pop(context,1);

    }else{
      ToastMessage.show(context, "Please try again");
    }


  }

  selectedJob(a){
    selectSal=salary[a];
    salController.text=salary[a];
    notifyListeners();
  }











}