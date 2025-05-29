import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import 'package:tkd_connect/widgets/datepicker.dart';

import '../../model/request/post_load.dart';
import '../../model/response/post_upload.dart';
import '../../model/response/userdata.dart';
import '../../model/response/verified_user.dart';
import '../../screen/create_post/select_userlist_for_post.dart';
import '../../utils/colors.dart';
import '../../utils/razorpayload.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/paypostsheet.dart';

class PostLoadProvider extends BaseProvider {
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
  String selectedGroup = "Select One";
  String sourceCity = "Select One";
  String destinationCity = "Select One";

  TextEditingController vehicleSizeController = TextEditingController();
  TextEditingController loadWeightController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool enbleButton = false;
  bool vehicaleSize = true;
  bool loadWieght = true;
  bool dnd = false;
  bool hideMyID = false;
  bool isRepeat = false;

  String selectOption = "Select Option";

  PostLoadProvider() : super('Ideal') {
    initData();
  }

  initData() async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    emailIdController.text = user.content!.first.emailId!;
    mobileNumberController.text = user.content!.first.mobileNumber!.toString();
  }

  uploadImage(BuildContext context) async {
    String image = await postImage(context);
    images.add(image);
    notifyListeners();
  }

  List<GroupData> groupListByUserId = [];
  List<String> groupListName = [];
  List<String> listOptionShow = ["All User", "Group", "Verified user"];
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

    GroupMemberListResponse groupListModel =
        GroupMemberListResponse.fromJson(response.response);
    listAddedMember.addAll(groupListModel.content!);
    for (var element in listAddedMember) {
      addedMemberIdList.add(element.userId!);
    }
    print(addedMemberIdList.length);
    notifyListeners();
  }

  createPost(BuildContext context) async {
    User user = await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.content!.first.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.content!.first.emailId!;
    postLoad.fullLoadChoice = "I Have Vehicle"; // I Have Vehicle

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
    postLoad.type = selectedRequriment;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.expireDate = expiryDateController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = '';//images[0];
    postLoad.isRepeat = isRepeat==true?1:0;
    postLoad.repeatStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    postLoad.repeatEndDate = endDateController.text;
    postLoad.listOfUserIds = addedMemberIdList;
    postLoad.id = 0;

    ApiResponse response = await ApiHelper().postParameter(
        "${ApiConstant.BASE_URL}fullTruckLoad2", postLoad.toJson());
    print('The response status code: ${response.status}');

    if (response.status == 200) {
      PostUpload postUpload = PostUpload.fromJson(response.response);

      // First dialog logic
      Navigator.pop(context); // Close the first dialog

      // Delay showing the second dialog
      Future.microtask(() {
        _showConfirmationDialog(context);
      });

      if (postUpload.statusCode == 401) {
        ToastMessage.show(context, "Please update your package");
        callSubDailog(context, postLoad);
      } else {
        ToastMessage.show(context, "Post submitted successfully!");
       /* Navigator.pop(context);
        Navigator.pop(context, 1);*/
      }
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }


  createVehiclePost(BuildContext context) async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.content!.first.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.content!.first.emailId!;
    postLoad.fullLoadChoice = "I Want Vehicle";

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
    postLoad.expireDate = expiryDateController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = '';
    postLoad.isRepeat = isRepeat==true?1:0;
    postLoad.repeatStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    postLoad.repeatEndDate = endDateController.text;
    postLoad.listOfUserIds = addedMemberIdList;
    //postLoad.userList = null;



    ApiResponse response = await ApiHelper().postParameter(
        "${ApiConstant.BASE_URL}fullTruckLoad2", postLoad.toJson());
    print('the constand ${ jsonEncode(postLoad.toJson())}');

    if (response.status == 200) {
      // ToastMessage.show(context, "Post submitted successfully!");
      // Navigator.pop(context);
      // Navigator.pop(context, 1);
      PostUpload postUpload=PostUpload.fromJson(response.response);
      Navigator.pop(context); // Close the first dialog

      // Delay showing the second dialog
      Future.microtask(() {
        _showConfirmationDialog(context);
      });

      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        callSubDailog(context,postLoad);
        // Navigator.pushNamed(context, AppRoutes.registration_plan_details);
      }else{
        ToastMessage.show(context, "Post submitted successfully!");
        /*Navigator.pop(context);
        Navigator.pop(context, 1);*/
      }

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

  setDate(String date) async {
    expiryDateController.text = date;
    notifyListeners();
  }
  setStartDate(String date) async {
    startDateController.text = date;
    notifyListeners();
  }
  setEndDate(String date) async {
    endDateController.text = date;
    notifyListeners();
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
    addedMemberIdList.clear();
    selectedGroup = groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);
  }

  selecteOptiontoShow(int index, BuildContext context) async {
    notifyListeners();
    switch (index) {
      case 0:
        addedMemberIdList.clear();
        selectOption = listOptionShow[index];
        selectedGroup = listOptionShow[index];
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
        selectedGroup = listOptionShow[index];
        notifyListeners();
        return;

      case 2:
        if (sourceCity == "Select One") {
          ToastMessage.show(context, "Please select the source city ");
        } else {
          List<UserVerifiedData> verfiedUserList = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectUserForPostScreen(false, sourceCity)));
          if (verfiedUserList.isNotEmpty) {
            addedMemberIdList.clear();
            for (int i = 0; i < verfiedUserList.length; i++) {
              addedMemberIdList.add(verfiedUserList[i].id!);
            }
            selectOption = listOptionShow[index];
            selectedGroup = listOptionShow[index];
          }
        }

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
            if (selectedGroup == "Select One") {
              ToastMessage.show(context, "Please Select Show Post To");
            } else {
              if (loadWieght && vehicaleSize) {
                //createPost(context);


                if(selectedGroup == "Select One"){

                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Post Load',style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),),
                        content: Text('Are you sure you want to post this requirement?',style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w400,
                        ),),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,),),
                          ),
                          TextButton(
                            onPressed: () {
                              createPost(context);

                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.green, fontSize: 12.sp,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }

              } else {
                ToastMessage.show(context, "Please fill the all information");
              }
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

            if(selectedGroup == "Select One"){
              ToastMessage.show(context, "Please Select Show Post To");
            }else {
              if (loadWieght && vehicaleSize) {
                // createVehiclePost(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Post Load',style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),),
                      content: Text('Are you sure you want to post this requirement?',style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,),),
                        ),
                        TextButton(
                          onPressed: () {
                            createVehiclePost(context);

                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.green, fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,),
                          ),
                        ),
                      ],
                    );
                  },
                );



              } else {
                ToastMessage.show(context, "Please fill the all information");
              }
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

  repeatPostSwitch(bool val) {
    isRepeat = val;
    notifyListeners();
  }

  payment(BuildContext  context,PostLoad postLoad)async{

    User user=await LocalSharePreferences().getLoginData();
    RazorPayClassLoad(context).initalPay(199,user.content!.first.mobileNumber!,user.content!.first.emailId!,postLoad);

  }

  void callSubDailog(BuildContext context,PostLoad postLoad) async{

    bool plan=  await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
              heightFactor: 0.6,
              child: PayPostSheet());
        });
    if(plan){
        payment(context,postLoad,);

    }else{
      ToastMessage.show(context, "Please Try Again");
    }

  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Important Notice',
            style: TextStyle(  fontSize: 16.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,),
          ),
          content: Text(
            'Do not Pay any Advance before Loading of Truck and verifying RTO documents on mParivahan website.',
            style: TextStyle(  fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600, color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();// Close the dialog
              },
              child: Text(
                'Ok',
                style: TextStyle(  fontSize: 14.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,),
              ),
            ),
          ],
        );
      },
    );
  }

}
