
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/group_member_list.dart';
import 'package:tkd_connect/model/response/group_response.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';
import '../../model/response/userdata.dart';
import '../../utils/colors.dart';
import '../../widgets/bottomsheet.dart';
class BulkUploadProvider extends BaseProvider {
  String selectedGroup = "Select One";
  String selectOption = "Select Option";
  bool isLoad=true;
  List<GroupData> groupListByUserId = [];
  List<String> groupListName = [];
  List<String> listOptionShow = ["All User", "Group",];
  List<GroupMember> listAddedMember = [];
  List<int> addedMemberIdList = [];

  BulkUploadProvider() : super('Ideal') {

  }



  selectFile(BuildContext context)async{

    if(selectedGroup=="Select One"){

      ToastMessage.show(context, "Please select Show Post to");

    }else{
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String? path=result.files.single.path;
        callBulkUploadApi(path, context);
        //File( path!);
      } else {
        print("No file selected");
      }

    }




  }

  callBulkUploadApi(String? path,BuildContext context)async{
    User user =
    await LocalSharePreferences.localSharePreferences.getLoginData();
    String numbersString="null";
    if(addedMemberIdList.length!=0){
      numbersString =addedMemberIdList.join(',');
    }



    print('the path is $path');
    File file = File(path!); // Replace with the actual file path
    Map<String, dynamic> fields = {};


    if(addedMemberIdList.length!=0){
      fields = {
        "loggedUsername":user.content!.first.userName,
        "mobileNumber":"9503334903",
        "email":user.content!.first.emailId,
        "tableName":"FullTruckLoad",
        "mainTag":isLoad?"I Have Vehicle":"I Want Vehicle",
        "images":"",
        "transporterOrCustomerName":user.content!.first.userName,
        "listOfUserIds":numbersString
      };
    }else{
      fields = {
        "loggedUsername":user.content!.first.userName,
        "mobileNumber":"9503334903",
        "email":user.content!.first.emailId,
        "tableName":"FullTruckLoad",
        "mainTag":isLoad?"I Have Vehicle":"I Want Vehicle",
        "images":"",
        "transporterOrCustomerName":user.content!.first.userName,


      };

    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bulk Post',style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ),),
          content: Text('Are you sure you want to upload document ?',style: TextStyle(
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
                //
                uploadFile(context,"http://ec2-13-127-217-17.ap-south-1.compute.amazonaws.com:8080/tkd2/api/uploadFullTruckLoad", file, fields);

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






  getGroupListByUserId() async {
    User user =
    await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.GET_GROUP_LIST(user.content!.first.id);
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
        // if (sourceCity == "Select One") {
        //   ToastMessage.show(context, "Please select the source city ");
        // } else {
        //   List<UserVerifiedData> verfiedUserList = await Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => SelectUserForPostScreen(false, sourceCity)));
        //   if (verfiedUserList.isNotEmpty) {
        //     addedMemberIdList.clear();
        //     for (int i = 0; i < verfiedUserList.length; i++) {
        //       addedMemberIdList.add(verfiedUserList[i].id!);
        //     }
        //     selectOption = listOptionShow[index];
        //     selectedGroup = listOptionShow[index];
        //   }
        // }

        return;
    }
  }




  changeTab(){
    notifyListeners();
  }



  //upload file to server
  Future<void> uploadFile(BuildContext context,String url, File file, Map<String, dynamic> fields) async {
    EasyLoading.show(status: "Uploading");
    try {

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });
      String fileName = file.path!.split('/').last;
      // Add file
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file', // This is the name field expected by the server
          file.path,
          filename: fileName, // Optional: provide a custom file name
        ));
      }

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        EasyLoading.dismiss();
        ToastMessage.show(context, "File uploaded successfully");
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        debugPrint('File uploaded successfully: $responseBody');
      } else {
        EasyLoading.dismiss();
        ToastMessage.show(context, "File upload failed");
        debugPrint('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error uploading file: $e');
    }
  }


}
