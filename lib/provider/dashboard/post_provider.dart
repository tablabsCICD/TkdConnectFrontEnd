import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/request/post_load.dart';
import '../../model/response/search_data.dart';
import '../../model/response/userdata.dart';
import '../../model/response/verified_user.dart';
import '../../screen/create_post/select_userlist_for_post.dart';
import '../../widgets/bottomsheet.dart';

class PostLoadProvider extends BaseProvider {
  List<String>reqirement=["Full Load","Part Load"];
  List<String>reqirementVehicale=["Full Load Vehicle","Part Load Vehicle"];
  List<String> requirementList = <String>['I Want Vehicle', 'I Have Vehicle'];
  List<String> cargoList = <String>['Wooden Case','Cartons','Drums','Gunny Bags',"Machinery",'Other'];
  List<String> paymentList = <String>['Immediate','Fortnight','Weekly','Others'];
  List<String>images=[];
  String selectedRequriment="Select One";
  String selectedCargo="Select One";
  String selectedPayment="Select One";
  String selectedGroup="Select Group";
  String sourceCity="Select One";
  String destinationCity="Select One";

  TextEditingController vehicleSizeController=TextEditingController();
  TextEditingController loadWeightController=TextEditingController();
  TextEditingController specialInstructionController=TextEditingController();
  TextEditingController mobileNumberController=TextEditingController();
  TextEditingController emailIdController=TextEditingController();
  bool enbleButton=false;
  bool vehicaleSize=true;
  bool loadWieght=true;
  bool dnd=false;
  bool hideMyID=false;

  String selectOption="Select Option";

  PostLoadProvider() : super('Ideal'){

    initData();
  }
  initData()async{
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    emailIdController.text=user.content!.first!.emailId!;
    mobileNumberController.text=user.content!.first!.mobileNumber!.toString();

  }
  uploadImage(BuildContext context)async{
    String image=await postImage(context);
    images.add(image);
    print('the images is ${images.length}');
    notifyListeners();
  }

  List<GroupData> groupListByUserId = [];
  List<String> groupListName = [];
  List<String> listOptionShow= ["All User","Select Group","Verified user"];
  List<GroupMember>listAddedMember=[];
  List<int> addedMemberIdList = [];

  getGroupListByUserId() async {
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.GET_GROUP_LIST(user.content!.first.id);
    print("Get Group List By User Id : $myUrl");
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);
    if(apiResponse.status==200){
      GroupListResponse groupListResponse=GroupListResponse.fromJson(apiResponse.response);
      groupListByUserId.clear();
      groupListName.clear();
      groupListByUserId.addAll(groupListResponse.content as Iterable<GroupData>);
      groupListByUserId.forEach((element) {groupListName.add(element.groupName!); });

    }
    notifyListeners();
  }

  getGroupMember(int groupId)async{
    listAddedMember.clear();
    addedMemberIdList.clear();
    ApiHelper apiHelper=ApiHelper();
    String myUrl = ApiConstant.GROUP_MEMBER_LIST+groupId!.toString();
    print(myUrl);
    var response=await apiHelper.apiWithoutDecodeGet(myUrl);

    GroupMemberListResponse groupListModel=GroupMemberListResponse.fromJson(response.response);
    listAddedMember.addAll(groupListModel.content!);
    listAddedMember.forEach((element) { addedMemberIdList.add(element.id!);});
    print(addedMemberIdList.length);
    notifyListeners();
  }

  createPost(BuildContext context)async{
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad=PostLoad();
    postLoad.contactNumber= user.content!.first!.mobileNumber! ;
    postLoad.destination= destinationCity;
    postLoad.dnd =dnd?1:0;
    postLoad.emailId=user.content!.first!.emailId!;
    postLoad.fullLoadChoice="I Have Vehicle";

    postLoad.instructions= specialInstructionController.text;
    postLoad.loadWeight= loadWeightController.text;
    postLoad.loggedUserName= user.content!.first!.userName;
    postLoad.mainTag= selectedRequriment;
    postLoad.os= 'App';
    postLoad.otherDetails= specialInstructionController.text;
    postLoad.source=sourceCity;
    postLoad.partLoad= selectedRequriment == 'Part Load' ? 1 : 0;
    postLoad.privatePost= hideMyID ? 1 : 0;
    postLoad.rating= 5;
  //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type= selectedRequriment;
    postLoad.typeOfCargo= selectedCargo;
    postLoad.typeOfPayment=selectedPayment;
    postLoad.vehicleSize= vehicleSizeController.text;
    postLoad.tableName="Full Load";
    postLoad.topicName= "Full Load Truck";
    postLoad.image=images;
    postLoad.listOfUserIds=addedMemberIdList;

    postLoad.id=0;
    ApiResponse response=await ApiHelper().postParameter(ApiConstant.BASE_URL+"fullTruckLoad", postLoad.toJson());
    print('the resopnse is ${json.encode(postLoad.toJson())}');
    print('the resopnse is ${response.status}');
    if(response.status==200){
      ToastMessage.show(context, "Post submitted successfully!");
      Navigator.pop(context);
      Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }
  createVehiclePost(BuildContext context)async{
    User user=await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad=PostLoad();
    postLoad.contactNumber= user.content!.first.mobileNumber! ;
    postLoad.destination= destinationCity;
    postLoad.dnd =dnd?1:0;
    postLoad.emailId=user.content!.first.emailId!;
    postLoad.fullLoadChoice="I Want Vehicle";

    postLoad.instructions= specialInstructionController.text;
    postLoad.loadWeight= loadWeightController.text;
    postLoad.loggedUserName= user.content!.first.userName;
    postLoad.mainTag= selectedRequriment;
    postLoad.os= 'App';
    postLoad.otherDetails= specialInstructionController.text;
    postLoad.source=sourceCity;
    postLoad.partLoad=selectedRequriment == 'Part Load Vehicle' ? 1 : 0;
    postLoad.privatePost= hideMyID ? 1 : 0;
    postLoad.rating= 5;
    //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type=selectedRequriment;
    postLoad.typeOfCargo= selectedCargo;
    postLoad.typeOfPayment=selectedPayment;
    postLoad.vehicleSize= vehicleSizeController.text;
    postLoad.tableName="Full Load";
    postLoad.topicName= "Full Load Truck";
    postLoad.image=images;
    postLoad.listOfUserIds=addedMemberIdList;

    ApiResponse response=await ApiHelper().postParameter(ApiConstant.BASE_URL+"fullTruckLoad", postLoad.toJson());
    if(response.status==200){
        ToastMessage.show(context, "Post submitted successfully!");
        Navigator.pop(context);
      Navigator.pop(context,1);
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }
  enble(){
    if(vehicleSizeController.text.isNotEmpty && loadWeightController.text.isNotEmpty && emailIdController.text.isNotEmpty && mobileNumberController.text.isNotEmpty
    && specialInstructionController.text.isNotEmpty && checkdropDown(selectedCargo)&& checkdropDown(selectedRequriment) && checkdropDown(selectedPayment)
    && checkdropDown(sourceCity) && checkdropDown(destinationCity)
    ){
      enbleButton=true;
    }else{
      enbleButton=false;
    }
    notifyListeners();
  }
  checkdropDown(String val){
    if(val.allMatches("Select One")==0){
      return false;
    }else{
      return true;
    }
  }
  selectedRequrimentType(int index){

    selectedRequriment=reqirement[index];
    enble();
    notifyListeners();

  }
  selectedRequrimentVehicaleType(int index){
    selectedRequriment=reqirementVehicale[index];
    enble();
    notifyListeners();

  }
  selectedCargoType(int index){
    selectedCargo=cargoList[index];
    enble();
    notifyListeners();
  }
  selectedPaymentType(int index){
    selectedPayment=paymentList[index];
    enble();
    notifyListeners();

  }

  selecteGroup(int index) async {
    addedMemberIdList.clear();
    selectedGroup=groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);

  }

  selecteOptiontoShow(int index,BuildContext context) async {

    notifyListeners();
    switch (index){

      case 0:
        addedMemberIdList.clear();
        selectOption=listOptionShow[index];
        return;
      case 1:

            if(groupListName.isEmpty) {
              await getGroupListByUserId();
            }
            ItemBottomSheet itemBottomSheet = ItemBottomSheet();
            int a = await itemBottomSheet.showIteamHieght(
                context,groupListName, "Select Group");
             selecteGroup(a);
            selectOption=listOptionShow[index];
             notifyListeners();
        return;

      case 2:

        if(sourceCity=="Select One"){
          ToastMessage.show(context, "Please select the source city ");
        }else{

          List<UserVerifiedData> verfiedUserList=await Navigator.push(context, MaterialPageRoute(builder: (_)=>SelectUserForPostScreen(false,sourceCity)));
          if(verfiedUserList !=null){
            addedMemberIdList.clear();
            for(int i=0;  i<verfiedUserList.length; i++){

              addedMemberIdList.add(verfiedUserList[i].id!);

            }
            selectOption=listOptionShow[index];
          }


        }


        return;

    }



  }





  selectedSourceCity(String city){
    sourceCity=city;
    enble();
    notifyListeners();

  }
  selectedDestinationCity(String city){
    destinationCity=city;
    enble();
    notifyListeners();
  }
  checkValidation(BuildContext context){
    if(vehicleSizeController.text.isEmpty){
      vehicaleSize=false;
    }else{
      vehicaleSize=true;
    }
    if(loadWeightController.text.isEmpty){
      loadWieght=false;
    }else{
      loadWieght=true;
    }
    String ;
    String selectedPayment="Select One";

    String ;
    if(selectedRequriment=="Select One"){
      ToastMessage.show(context, "Please Select Load Type");
    }else{
      if(sourceCity=="Select One"){
        ToastMessage.show(context, "Please Select From city");
      }else{
        if(destinationCity=="Select One"){
          ToastMessage.show(context, "Please Select To city");
        }else{
         if(selectedCargo=="Select One"){
           ToastMessage.show(context, "Please Select Cargo Type");
         }else{

           if(loadWieght && vehicaleSize){
             createPost(context);
           }else{
             ToastMessage.show(context, "Please fill the all information");
           }
         }

        }
      }

    }
    notifyListeners();
  }
  checkVehicaleValidation(BuildContext context){
    if(vehicleSizeController.text.isEmpty){
      vehicaleSize=false;
    }else{
      vehicaleSize=true;
    }
    if(loadWeightController.text.isEmpty){
      loadWieght=false;
    }else{
      loadWieght=true;
    }
    if(selectedRequriment=="Select One"){
      ToastMessage.show(context, "Please Select Load Type");
    }else{
      if(sourceCity=="Select One"){
        ToastMessage.show(context, "Please Select From city");
      }else{
        if(destinationCity=="Select One"){
          ToastMessage.show(context, "Please Select To city");
        }else{
          if(selectedCargo=="Select One"){
            ToastMessage.show(context, "Please Select Cargo Type");
          }else{

            if(loadWieght && vehicaleSize){
              createVehiclePost(context);
            }else{
              ToastMessage.show(context, "Please fill the all information");
            }
          }

        }
      }
    }
    notifyListeners();
  }

  dndChange(bool val){
    dnd=val;
    notifyListeners();
  }


  hideMyId(bool val){
    hideMyID=val;
    notifyListeners();
  }

}