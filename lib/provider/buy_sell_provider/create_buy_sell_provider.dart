import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/response/post_upload.dart';
import '../../model/response/userdata.dart';
import '../../route/app_routes.dart';

class CreateBuySellProvider extends BaseProvider{
  List<String>reqirement=["Buy","Sell"];
  String selectedRequriment="Select One";
  String destinationCity="Select One";
  String selectedCondition = 'Select One';
  String selectedMakerName = 'Select One';
  String selectedVehicleSize = 'Select One';
  String selectedYear = 'Select One';
  bool isSellSelected=false;
  late User user;
  TextEditingController vehicleSizeController=TextEditingController();
  TextEditingController loadWeightController=TextEditingController();
  TextEditingController specialInstructionController=TextEditingController();
  TextEditingController mobileNumberController=TextEditingController();
  TextEditingController emailIdController=TextEditingController();
  TextEditingController companyNameController=TextEditingController();
  List<String> makerList = <String>[
    'TATA',
    'Ashok Leyland',
    'Mahindra',
    'Isuzu',
    'Bharat Benz',
    'Volva',
    'Other'
  ];
  List<String> conditionList = <String>['Average', 'Good', 'Excellent'];
  List<String> yearList = <String>[
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000',
  ];
  List<String> vehicleSizeList = <String>[
    '32ft Closer Container',
    '24ft Closed Vehicles',
    '20ft Closed Vehicles',
    '20ft Closed',
    '20ft Open',
    '15ft Closed',
    '15ft Open',
    '13ft Closed',
    '13ft Open',
    '24ft Single XL',
    '24ft Double XL',
    '24ft Multi XL',
    '32ft Single XL',
    '32ft Double XL',
    '32ft Multi XL',
    'Trailer',
    'Other'
  ];
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController modelName = TextEditingController();
  TextEditingController vehicleRno = TextEditingController();
  TextEditingController kiloMeter = TextEditingController();

 // CreateBuySellProvider(super.appState);
  CreateBuySellProvider():super("Ideal"){

    getUser();
  }

  selectedRequrimentType(int index){
    selectedRequriment=reqirement[index];
    if(index==1){
      isSellSelected=true;
    }else{
      isSellSelected=false;
    }
    //enble();
    notifyListeners();
  }
  selectedDestinationCity(String city){
    destinationCity=city;
    //enble();
    notifyListeners();
  }
  selectedMakerType(int index){
    selectedMakerName=makerList[index];
    //enble();
    notifyListeners();

  }
  selectedConditionType(int index){
    selectedCondition=conditionList[index];
    //enble();
    notifyListeners();

  }
  selectedvehicleSizeType(int index){
    selectedVehicleSize=vehicleSizeList[index];
    //enble();
    notifyListeners();

  }
  selectedyearType(int index){
    selectedYear=yearList[index];
    //enble();
    notifyListeners();

  }

  void getUser() async{
    user=await LocalSharePreferences().getLoginData();
    companyNameController.text=user.content!.first.companyName!;
    emailIdController.text=user.content!.first.emailId!;
    mobileNumberController.text=user.content!.first.mobileNumber!.toString();
    notifyListeners();
  }




  createBuySell(BuildContext context) async {

    Map<String, dynamic> data = {
      "additionalInformation": specialInstructionController.text,
      "agentName": "${user.content!.first.firstName!} ${user.content!.first.lastName!}",
      "bodyType": specialInstructionController.text,
      "buySelltype": selectedRequriment,
      "city": destinationCity,
      "conditionOfTyres": selectedCondition,
      "conditionOfVehicle": selectedCondition,
      "contactNumber": mobileNumberController.text,
      "date": "2022-01-22T11:29:53.473Z",
      "estimatedPrice": price.text,
      "id": 0,
      "image1": "",
      "image2": " ",
      "image3": " ",
      "image4": " ",
      "insaurancePaidUpto": selectedYear,
      "loggedTime": "2022-01-22T11:29:53.473Z",
      "loggedUserName": user.content!.first.userName,
      "mainTag": selectedRequriment,
      "maker": selectedMakerName,
      "mfgYear": selectedYear,
      "model": modelName.text,
      "negotiable": 0,
      "os": " ",
      "ownerName": "${user.content!.first.firstName!} ${user.content!.first.lastName!}",
      "postingTime": "2022-01-22T11:29:53.473Z",
      "privatePost": 0,
      "tableName": "Buy/Sell",
      "topicName": "string",
      "type": selectedRequriment,
      "userId":user.content!.first.id,
      "vehicleRegistrationNumber": vehicleRno.text,
      "yearOfBuying": selectedYear
    };
    print(jsonEncode(data));
    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.POST_BUY_SELL, data);
    if(apiResponse.status==200){

      PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      }else{
        ToastMessage.show(context, "Post Sumbited Successfully");
        Navigator.pop(context);
      }
    }else{
      ToastMessage.show(context, "Please try again");
    }

    notifyListeners();
  }

bool isPrise=true;
bool isModelName=true;
bool isKilo=true;
bool isrlNo=true;
  checkValidation(BuildContext context){
    if(selectedRequriment=="Select One"){
      ToastMessage.show(context, "Please select type");
    }else{
      if(destinationCity=="Select One"){
        ToastMessage.show(context, "Please select city");
      }else{
        if(selectedMakerName=="Select One"){
          ToastMessage.show(context, "Please select maker name");
        }else{
          if(selectedYear=="Select One"){
            ToastMessage.show(context, "Please select  manufacturing year");
          }else{
            if(selectedVehicleSize=="Select One"){
              ToastMessage.show(context, "Please select selected vehicle size");
            }else{
              if(selectedCondition=="Select One"){
                ToastMessage.show(context, "Please select selected vehicle condition");
              }else{

                if(modelName.text.isNotEmpty){
                  isModelName=true;
                    if(price.text.isNotEmpty){
                      isPrise=true;
                      if(reqirement=="Sell"){
                        if(kiloMeter.text.isNotEmpty){
                          isKilo=true;
                          if(vehicleRno.text.isNotEmpty){
                            isrlNo=true;
                            createBuySell(context);
                          }else{
                            isrlNo=false;
                          }
                        }else{
                          isKilo=false;
                        }

                      }else{
                        createBuySell(context);

                      }

                    }else{
                      isPrise=false;
                    }
                 }else{
                  isModelName=false;

                }


              }
            }
          }
        }
      }
    }
  }



}