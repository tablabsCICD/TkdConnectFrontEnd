import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/AllCard.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/model/response/my_post_bid_list.dart';
import 'package:tkd_connect/model/response/verified_user.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/screen/create_post/select_userlist_for_post.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/bottomsheet.dart';

import '../../model/request/post_load.dart';
import '../../model/response/userdata.dart';

class EditPostLoadProvider extends BaseProvider {
  List<String> reqirement = ["Full Load", "Part Load"];
  List<String> reqirementVehicale = ["Full Load Vehicle", "Part Load Vehicle"];
  List<String> requirementList = <String>['I Want Vehicle', 'I Have Vehicle'];
  List<String> cargoList = <String>[
    'Wooden Case',
    'Cartons',
    'Drums',
    'Gunny Bags',
    "Machinery",
    'Other'
  ];
  List<String> paymentList = <String>[
    'Immediate',
    'Fortnight',
    'Weekly',
    'Others'
  ];
  List<String> images = [];
  String selectedRequriment = "Select One";
  String selectedCargo = "Select One";
  String selectedPayment = "Select One";
  String selectedGroup = "Select Group";
  String sourceCity = "Select One";
  String destinationCity = "Select One";

  TextEditingController vehicleSizeController = TextEditingController();
  TextEditingController loadWeightController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  bool enbleButton = false;
  bool vehicaleSize = true;
  bool loadWieght = true;
  bool dnd = false;
  bool hideMyID = false;
  PostBidData postBidData;

  EditPostLoadProvider(this.postBidData) : super('Ideal') {
    initData();
  }

  initData() async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    emailIdController.text = user.content!.first.emailId!;
    mobileNumberController.text = user.content!.first.mobileNumber!.toString();
    selectedCargo = postBidData.genericCardsDto!.cargoType!;
    loadWeightController.text = postBidData.genericCardsDto!.vehicleWeight!;
    await getTruckLoadById(postBidData.genericCardsDto!.id!);
    notifyListeners();
  }

  uploadImage(BuildContext context) async {
    String image = await postImage(context);
    images.add(image);
    print('the images is ${images.length}');
    notifyListeners();
  }

  List<GroupData> groupListByUserId = [];
  List<String> groupListName = [];
  List<GroupMember> listAddedMember = [];
  List<int> addedMemberIdList = [];

  getGroupListByUserId() async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.GET_GROUP_LIST(user.content!.first.id);
    print("Get Group List By User Id : $myUrl");
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);
    if (apiResponse.status == 200) {
      GroupListResponse groupListResponse =
          GroupListResponse.fromJson(apiResponse.response);
      groupListByUserId.clear();
      groupListName.clear();
      groupListByUserId
          .addAll(groupListResponse.content as Iterable<GroupData>);
      for (var element in groupListByUserId) {
        groupListName.add(element.groupName!);
      }
    }
    notifyListeners();
  }

  getGroupMember(int groupId) async {
    listAddedMember.clear();
    addedMemberIdList.clear();
    ApiHelper apiHelper = ApiHelper();
    String myUrl = ApiConstant.GROUP_MEMBER_LIST + groupId.toString();
    print(myUrl);
    var response = await apiHelper.apiWithoutDecodeGet(myUrl);
    print(response.response);
    GroupMemberListResponse groupListModel =
        GroupMemberListResponse.fromJson(response.response);
    listAddedMember.addAll(groupListModel.content!);
    for (var element in listAddedMember) {
      addedMemberIdList.add(element.id!);
    }
    print(addedMemberIdList.length);
    notifyListeners();
  }

  List<String> addedUserListIdInPost=[];
  List<int> addedUserListInPost=[];
  List<UserData> addedUsers = [];
  getUserListFromString(String userList)async{
    if(userList.isNotEmpty){
      addedUserListIdInPost = userList.split(',').map((e) => e.trim()).toList();
      print(addedUserListIdInPost);
      for (var element in addedUserListIdInPost)  {
        UserData userData = await getUserById(int.parse(element));
        addedUserListInPost.add(int.parse(element));
        print(userData.id);
        print(userData.firstName);
        addedUsers.add(userData);
      }
    }
    return addedUserListIdInPost;
  }

  getUserById(int userId) async {
    ApiHelper apiHelper = ApiHelper();
    String myUrl = "${ApiConstant.BASE_URL}/companyRegistration/$userId";
    print(myUrl);
    ApiResponse response = await apiHelper.apiWithoutDecodeGet(myUrl);
    print(response.response);
    if(response.status==200){
      var result = User.fromJson(response.response);
      UserData userData = result.content!.first;
      return userData;
    }else{
      return null;
    }
  }

  getTruckLoadById(int id) async {
    ApiHelper apiHelper = ApiHelper();
    String myUrl = ApiConstant.FULL_LOAD_BY_ID + id.toString();
    print(myUrl);
    var response = await apiHelper.apiWithoutDecodeGet(myUrl);
    print(response.response);
    var result = TruckLoadType.fromJson(response.response);
    TruckLoad truckLoad = result.content.first;
    vehicleSizeController.text = truckLoad.vehicleSize!;

    specialInstructionController.text = truckLoad.otherDetails!;
    selectedGroup = 'Select any one';

    selectedPayment = truckLoad.typeOfPayment!;
    selectedRequriment = truckLoad.type!;
    sourceCity = truckLoad.source!;
    destinationCity = truckLoad.destination!;
    dnd = truckLoad.dnd == 0 ? false : true;
    hideMyID = truckLoad.privatePost == 0 ? false : true;
    var userList = getUserListFromString(truckLoad.userList!);
    addedMemberIdList = addedUserListInPost;
    notifyListeners();
  }

  editPost(BuildContext context) async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.content!.first.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.content!.first.emailId!;
    postLoad.fullLoadChoice = "I Have Vehicle";
    postLoad.instructions = specialInstructionController.text;
    postLoad.loadWeight = loadWeightController.text;
    postLoad.loggedUserName = user.content!.first.userName;
    postLoad.mainTag = selectedRequriment;
    postLoad.os = 'App';
    postLoad.otherDetails = specialInstructionController.text;
    postLoad.source = sourceCity;
    postLoad.partLoad = selectedRequriment == 'Part Load' ? 1 : 0;
    postLoad.privatePost = hideMyID ? 1 : 0;
    postLoad.rating = 5;
    //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type = selectedRequriment;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = images;
    postLoad.listOfUserIds = addedMemberIdList;
    postLoad.id = postBidData.genericCardsDto!.id;
    ApiResponse response = await ApiHelper()
        .apiPut("${ApiConstant.BASE_URL}UpdatePost", postLoad.toJson());
    print('the request is ${json.encode(postLoad.toJson())}');
    print('the resopnse is ${response.response}');
    if (response.status == 200) {
      ToastMessage.show(context, "Post edited successfully!");
      Navigator.pop(context);
      Navigator.pop(context, 1);
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  editVehiclePost(BuildContext context) async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.content!.first.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.content!.first.emailId!;
    postLoad.fullLoadChoice = "I Want Vehicle";
    postLoad.id = postBidData.genericCardsDto!.id;
    postLoad.instructions = specialInstructionController.text;
    postLoad.loadWeight = loadWeightController.text;
    postLoad.loggedUserName = user.content!.first.userName;
    postLoad.mainTag = selectedRequriment;
    postLoad.os = 'App';
    postLoad.otherDetails = specialInstructionController.text;
    postLoad.source = sourceCity;
    postLoad.partLoad = selectedRequriment == 'Part Load Vehicle' ? 1 : 0;
    postLoad.privatePost = hideMyID ? 1 : 0;
    postLoad.rating = 5;
    //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type = selectedRequriment;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = images;
    postLoad.listOfUserIds = addedMemberIdList;

    ApiResponse response = await ApiHelper()
        .apiPut("${ApiConstant.BASE_URL}UpdatePost", postLoad.toJson());
    if (response.status == 200) {
      ToastMessage.show(context, "Post edited successfully!");
      Navigator.pop(context);
      Navigator.pop(context, 1);
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  enble() {
    if (vehicleSizeController.text.isNotEmpty &&
        loadWeightController.text.isNotEmpty &&
        emailIdController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        specialInstructionController.text.isNotEmpty &&
        checkdropDown(selectedCargo) &&
        checkdropDown(selectedRequriment) &&
        checkdropDown(selectedPayment) &&
        checkdropDown(sourceCity) &&
        checkdropDown(destinationCity)) {
      enbleButton = true;
    } else {
      enbleButton = false;
    }
    notifyListeners();
  }

  checkdropDown(String val) {
    if (val.allMatches("Select One") == 0) {
      return false;
    } else {
      return true;
    }
  }

  selectedRequrimentType(int index) {
    selectedRequriment = reqirement[index];
    enble();
    notifyListeners();
  }

  selectedRequrimentVehicaleType(int index) {
    selectedRequriment = reqirementVehicale[index];
    enble();
    notifyListeners();
  }

  selectedCargoType(int index) {
    selectedCargo = cargoList[index];
    enble();
    notifyListeners();
  }

  selectedPaymentType(int index) {
    selectedPayment = paymentList[index];
    enble();
    notifyListeners();
  }

  selecteGroup(int index) async {
    print(groupListByUserId[index].groupName!);
    selectedGroup = groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);
    // enble();
  }

  List<String> listOptionShow = ["All User", "Select Group", "Verified user"];
  String selectOption = "Select Option";

  selecteOptiontoShow(int index, BuildContext context) async {
    notifyListeners();
    switch (index) {
      case 0:
        addedMemberIdList.clear();
        selectOption = listOptionShow[index];
        return;
      case 1:
        if (groupListName.isEmpty) {
          await getGroupListByUserId();
        }
        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
        int a = await itemBottomSheet.showIteamHieght(
            context, groupListName, "Select Group");
        selecteGroup(a);
        selectOption = listOptionShow[index];
        notifyListeners();
        return;

      case 2:
        if (sourceCity == "Select One") {
          ToastMessage.show(context, "Please select the source city ");
        } else {
          List<UserVerifiedData> verfiedUserList=await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectUserForPostScreen(
                        true,
                        sourceCity,
                      )));
          if (verfiedUserList.isNotEmpty) {
            addedMemberIdList.clear();
            for (int i = 0; i < verfiedUserList.length; i++) {
              addedMemberIdList.add(verfiedUserList[i].id!);
            }
            selectOption = listOptionShow[index];
          }
        }
        notifyListeners();

        return;
    }
  }

  selectedSourceCity(String city) {
    sourceCity = city;
    enble();
    notifyListeners();
  }

  selectedDestinationCity(String city) {
    destinationCity = city;
    enble();
    notifyListeners();
  }

  checkValidation(BuildContext context) {
    if (vehicleSizeController.text.isEmpty) {
      vehicaleSize = false;
    } else {
      vehicaleSize = true;
    }
    if (loadWeightController.text.isEmpty) {
      loadWieght = false;
    } else {
      loadWieght = true;
    }
    String;
    String selectedPayment = "Select One";

    String;
    if (selectedRequriment == "Select One") {
      ToastMessage.show(context, "Please Select Load Type");
    } else {
      if (sourceCity == "Select One") {
        ToastMessage.show(context, "Please Select From city");
      } else {
        if (destinationCity == "Select One") {
          ToastMessage.show(context, "Please Select To city");
        } else {
          if (selectedCargo == "Select One") {
            ToastMessage.show(context, "Please Select Cargo Type");
          } else {
            if (loadWieght && vehicaleSize) {
              editPost(context);
            } else {
              ToastMessage.show(context, "Please fill the all information");
            }
          }
        }
      }
    }
    notifyListeners();
  }

  checkVehicaleValidation(BuildContext context) {
    if (vehicleSizeController.text.isEmpty) {
      vehicaleSize = false;
    } else {
      vehicaleSize = true;
    }
    if (loadWeightController.text.isEmpty) {
      loadWieght = false;
    } else {
      loadWieght = true;
    }
    if (selectedRequriment == "Select One") {
      ToastMessage.show(context, "Please Select Load Type");
    } else {
      if (sourceCity == "Select One") {
        ToastMessage.show(context, "Please Select From city");
      } else {
        if (destinationCity == "Select One") {
          ToastMessage.show(context, "Please Select To city");
        } else {
          if (selectedCargo == "Select One") {
            ToastMessage.show(context, "Please Select Cargo Type");
          } else {
            if (loadWieght && vehicaleSize) {
              editVehiclePost(context);
            } else {
              ToastMessage.show(context, "Please fill the all information");
            }
          }
        }
      }
    }
    notifyListeners();
  }

  dndChange(bool val) {
    dnd = val;
    notifyListeners();
  }

  hideMyId(bool val) {
    hideMyID = val;
    notifyListeners();
  }
}
