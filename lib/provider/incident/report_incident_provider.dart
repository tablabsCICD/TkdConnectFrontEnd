import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/model/request/reportIncidentRequest.dart';
import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/allNewsResponse.dart';
import '../../model/response/getAllReportIncidentResponse.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../utils/colors.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';
import '../base_provider.dart';

class ReportIncidentProvider extends BaseProvider {
  ReportIncidentProvider() : super('Ideal') {
  //  pagenationHorizantal();
   // pagenationVerical();
    getAllData();
  }

  int selectedPage = 0;

  List<IncidentObject> allReportTemp = [];
  List<IncidentObject> allReport = [];

  bool isLoadDone = false;
  bool _myIncident = false;
  bool get myIncident => _myIncident;

  void toggleMyNews(bool value) {
    _myIncident = value;
    if(_myIncident==true){
      getMyIncidentData();
    }else{
      getAllData();
    }
    notifyListeners();
  }


  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<String> _incidentTypes = [];
  List<String> _cheatedBy = [];
  bool? _wasFirLaunched=false;
  bool _isAccepted = false;

  // TextEditingControllers
  TextEditingController nameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController incidentLocationController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController amountLostOrGoodsCheatedController =
      TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfIncidentController = TextEditingController();
  List<String> _uploadedProofs = [];
  List<String> images = [];

  // Getters
  List<String> get incidentTypes => _incidentTypes;

  List<String> get cheatedBy => _cheatedBy;

  bool? get wasFirLaunched => _wasFirLaunched;

  bool? get isAccepted => _isAccepted;

  List<String> get uploadedProofs => _uploadedProofs;

  // Methods
  void toggleIncidentType(String type) {
    if (_incidentTypes.contains(type)) {
      _incidentTypes.remove(type);
    } else {
      _incidentTypes.add(type);
    }
    notifyListeners();
  }

  void toggleCheatedBy(String value) {
    if (_cheatedBy.contains(value)) {
      _cheatedBy.remove(value);
    } else {
      _cheatedBy.add(value);
    }
    notifyListeners();
  }

  void updateFirStatus(bool? status) {
    _wasFirLaunched = status;
    notifyListeners();
  }

  void updateAcceptedTerm(bool status) {
    _isAccepted = status;
    notifyListeners();
  }

  void addUploadedProof(String proof) {
    _uploadedProofs.add(proof);
    notifyListeners();
  }

  uploadImage(BuildContext context) async {
    String? image = await pickAndUploadImage(context);
    if (image != null) {
      images.add(image);
      print("Image uploaded successfully: $image");
    } else {
      print("Image upload failed or was cancelled.");
    }
    notifyListeners();
  }

  setDate(String date) async {
    dateOfIncidentController.text = date;
    notifyListeners();
  }

  void clear() {
    _incidentTypes.clear();
    _cheatedBy.clear();
    _wasFirLaunched = null;

    // Clear TextEditingControllers
    nameController.clear();
    companyNameController.clear();
    vehicleNumberController.clear();
    incidentLocationController.clear();
    shortDescriptionController.clear();
    amountLostOrGoodsCheatedController.clear();

    phoneNumberController.clear();
    dateOfIncidentController.clear();
    _uploadedProofs.clear();
    notifyListeners();
  }

  bool enbleButton = false;

  enble() {
    if (_isAccepted==true &&
        vehicleNumberController.text.isNotEmpty &&
        incidentLocationController.text.isNotEmpty &&
        amountLostOrGoodsCheatedController.text.isNotEmpty &&
        dateOfIncidentController.text.isNotEmpty &&
        incidentTypes.isNotEmpty &&
        cheatedBy.isNotEmpty) {
      enbleButton = true;
    } else {
      enbleButton = false;
    }
    notifyListeners();
  }

  void checkValidation(BuildContext context) {
    // Consolidate error messages
    String? errorMessage;

    if (incidentTypes.isEmpty) {
      errorMessage = "Please select at least one incident";
    } else if (cheatedBy.isEmpty) {
      errorMessage = "Please select at least one cheater";
    } else if (vehicleNumberController.text.isEmpty) {
      errorMessage = "Please enter vehicle number";
    } else if (wasFirLaunched==true && images.isEmpty) {
      errorMessage = "Please upload an image";
    } else if (dateOfIncidentController.text.isEmpty) {
      errorMessage = "Please select a date";
    } else if (!isAccepted!) {
      errorMessage = "Please accept the agreement";
    }

    // Show error message if validation fails
    if (errorMessage != null) {
      ToastMessage.show(context, errorMessage);
      return;
    }

    // Validation passed, show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Post Load',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to post this requirement?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: ThemeColor.theme_blue,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                addReport(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  addReport(BuildContext context) async {
    // Convert list to comma-separated string
    String cheatedByList = cheatedBy.join(", ");
    // Convert list to comma-separated string
    String incidentTypeList = incidentTypes.join(", ");
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    ReportIncidentRequest reportIncidentRequest = ReportIncidentRequest();
    reportIncidentRequest.cheatedBy = cheatedByList;
    reportIncidentRequest.userId = user.content!.first.id!;
    reportIncidentRequest.topic = incidentTypes[0];
    reportIncidentRequest.image = wasFirLaunched==true?images[0]:null;
    reportIncidentRequest.date = dateOfIncidentController.text;
    reportIncidentRequest.description = shortDescriptionController.text;
    reportIncidentRequest.isResolved = false;
    reportIncidentRequest.amountLost = amountLostOrGoodsCheatedController.text;
    reportIncidentRequest.vehicleNumber = vehicleNumberController.text;
    reportIncidentRequest.incidentType = incidentTypeList;
    reportIncidentRequest.isFirLounched = wasFirLaunched;
    reportIncidentRequest.resolutionDetails = '';


    ApiResponse response = await ApiHelper()
        .postParameter("${ApiConstant.ADD_REPORT}", reportIncidentRequest.toJson());
    print('The response status code: ${response.status}');

    if (response.status == 200) {
      ToastMessage.show(context, "Your Report is submitted successfully!");
      toggleMyNews(_myIncident);
      // First dialog logic
      Navigator.pop(context);
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  getAllData() async {
    String myUrl = ApiConstant.GET_REPORT_LIST(selectedPage);

    print("Url $myUrl");
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);

    if (apiResponse.status == 200) {
      GetAllReportIncidentResponse newsResponse =
      GetAllReportIncidentResponse.fromJson(apiResponse.response);

      if (selectedPage == 0) {
        allReport.clear();
        allReportTemp.clear();
      }
      allReport.addAll(newsResponse.content!);
      allReportTemp.addAll(newsResponse.content!);
     // selectedPage++;
    }
    notifyListeners();
  }

  pagenationVerical() {
    scrollControllerVertical.addListener(() {
      if (scrollControllerVertical.position.pixels ==
          scrollControllerVertical.position.maxScrollExtent) {
        getAllData();
      }
    });
  }

  pagenationHorizantal() {
    scrollControllerHorizantal.addListener(() {
      if (scrollControllerHorizantal.position.pixels ==
          scrollControllerHorizantal.position.maxScrollExtent) {
        getAllData();
      }
    });
  }

  getBySearchData() async {
    User user = await LocalSharePreferences.localSharePreferences.getLoginData();
    if (searchController.text.length > 2) {
      String myUrl =
      ApiConstant.SEARCH_REPORT(searchController.text, user.content!.first.id);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);

      if (apiResponse.status == 200) {
        try {
          // Decode the JSON response
          final List<dynamic> responseList = jsonDecode(apiResponse.response);
          if (responseList.isNotEmpty) {
            // Map each JSON object to an IncidentObject
            List<IncidentObject> newsResponse = responseList
                .map((item) =>
                IncidentObject.fromJson(item as Map<String, dynamic>))
                .toList();
            allReport.clear();
            allReport.addAll(newsResponse);
          } else {
            allReport.clear();
          }
        } catch (e) {
          print('Error decoding response: $e');
          allReport.clear(); // Clear the list if decoding fails
        }
      }
    } else {
      // Restore the original list if search text is less than 3 characters
      allReport.clear();
      allReport.addAll(allReportTemp);
    }
    notifyListeners();
  }

  getMyIncidentData() async {
    User user = await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.MY_INCIDENT(user.content!.first.id);
    print(myUrl);
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);

    if (apiResponse.status == 200) {
      try {
        // Decode the JSON response
        final List<dynamic> responseList = jsonDecode(apiResponse.response);
        if (responseList.isNotEmpty) {
          // Map each JSON object to an IncidentObject
          List<IncidentObject> newsResponse = responseList
              .map((item) => IncidentObject.fromJson(item as Map<String, dynamic>))
              .toList();
          allReport.clear();
          allReport.addAll(newsResponse);
        } else {
          allReport.clear();
        }
      } catch (e) {
        print('Error decoding response: $e');
        allReport.clear(); // Clear the list if decoding fails
      }
    }
    notifyListeners();
  }



  deletePost(IncidentObject incidentObj,BuildContext context)async{
    String myUrl = '${ApiConstant.DELETE_INCIDENT(incidentObj.id)}';
    print(myUrl);
    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    print(apiResponse.response);
    if(apiResponse.status==200){
      ToastMessage.show(context, "Post deleted successfully");
      toggleMyNews(true);
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }
}
