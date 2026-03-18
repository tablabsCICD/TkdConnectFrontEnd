import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/model/request/reportIncidentRequest.dart';
import 'package:tkd_connect/model/response/myIncidentResponse.dart';
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
    toggleMyReport(myIncident);
    getTotalLostAmt();
    
  }

  int selectedPage = 0;

  List<IncidentObject> allReportTemp = [];
  List<IncidentObject> allReport = [];

  bool isLoadDone = false;
  bool _myIncident = false;
  bool get myIncident => _myIncident;

  Future<void> toggleMyReport(bool value) async {
    _myIncident = value;
    if (_myIncident) {
      await getMyIncidentData();
    } else {
      await getAllData(forceRefresh: true);
    }
    notifyListeners();
  }

  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<String> _incidentTypes = [];
  List<String> _cheatedBy = [];
  bool? _wasFirLaunched = false;
  bool _isAccepted = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController incidentLocationController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController amountLostOrGoodsCheatedController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfIncidentController = TextEditingController();
  List<String> _uploadedProofs = [];
  List<String> images = [];

  List<String> get incidentTypes => _incidentTypes;
  List<String> get cheatedBy => _cheatedBy;
  bool? get wasFirLaunched => _wasFirLaunched;
  bool? get isAccepted => _isAccepted;
  List<String> get uploadedProofs => _uploadedProofs;

  void toggleIncidentType(String type) {
    _incidentTypes.contains(type) ? _incidentTypes.remove(type) : _incidentTypes.add(type);
    notifyListeners();
  }

  void toggleCheatedBy(String value) {
    _cheatedBy.contains(value) ? _cheatedBy.remove(value) : _cheatedBy.add(value);
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
    if (image != null) images.add(image);
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
    nameController.clear();
    companyNameController.clear();
    vehicleNumberController.clear();
    incidentLocationController.clear();
    shortDescriptionController.clear();
    amountLostOrGoodsCheatedController.clear();
    phoneNumberController.clear();
    dateOfIncidentController.clear();
    _uploadedProofs.clear();
    images.clear();
    notifyListeners();
  }

  bool enbleButton = false;

  enble() {
    enbleButton = _isAccepted == true &&
        vehicleNumberController.text.isNotEmpty &&
        incidentLocationController.text.isNotEmpty &&
        amountLostOrGoodsCheatedController.text.isNotEmpty &&
        dateOfIncidentController.text.isNotEmpty &&
        incidentTypes.isNotEmpty &&
        cheatedBy.isNotEmpty;
    notifyListeners();
  }

  void checkValidation(BuildContext context) {
    String? errorMessage;

    if (incidentTypes.isEmpty) {
      errorMessage = "Please select at least one incident";
    } else if (cheatedBy.isEmpty) {
      errorMessage = "Please select at least one cheater";
    } else if (vehicleNumberController.text.isEmpty) {
      errorMessage = "Please enter vehicle number";
    } else if (wasFirLaunched == true && images.isEmpty) {
      errorMessage = "Please upload an image";
    } else if (dateOfIncidentController.text.isEmpty) {
      errorMessage = "Please select a date";
    } else if (!_isAccepted) {
      errorMessage = "Please accept the agreement";
    }

    if (errorMessage != null) {
      ToastMessage.show(context, errorMessage);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Incident'),
          content: Text('Are you sure you want to post this report?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                final isSuccess = await addReport(context);
                if (!context.mounted) return;
                if (isSuccess) {
                  ToastMessage.show(context, "Your report is submitted successfully!");
                  await toggleMyReport(_myIncident); // refresh immediately
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back
                } else {
                  ToastMessage.show(context, "Something went wrong. Please try again.");
                }
              },
              child: Text('Yes', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<bool> addReport(BuildContext context) async {
    try {
      String cheatedByList = cheatedBy.join(", ");
      String incidentTypeList = incidentTypes.join(", ");
      User user = await LocalSharePreferences.localSharePreferences.getLoginData();

      ReportIncidentRequest reportIncidentRequest = ReportIncidentRequest()
        ..cheatedBy = cheatedByList
        ..userId = user.content!.first.id!
        ..topic = incidentTypes[0]
        ..image = wasFirLaunched == true ? images[0] : null
        ..date = dateOfIncidentController.text
        ..description = shortDescriptionController.text
        ..isResolved = false
        ..amountLost = amountLostOrGoodsCheatedController.text
        ..vehicleNumber = vehicleNumberController.text
        ..incidentType = incidentTypeList
        ..isFirLounched = wasFirLaunched
        ..resolutionDetails = '';

      ApiResponse response = await ApiHelper()
          .postParameter(ApiConstant.ADD_REPORT, reportIncidentRequest.toJson());

      if (response.status == 200) {
        // First dialog logic
        Navigator.pop(context); // Close the first dialog

        // Delay showing the second dialog
        Future.microtask(() {
          _showConfirmationDialog(context);
        });
        clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print("Error while adding report: $e");
      return false;
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Report Submitted Successfully',
            style: TextStyle(  fontSize: 16.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,),
          ),
          content: Text(
            'Your report has been successfully submitted to the Admin. Our team will review your report promptly and respond as soon as possible.\n\n'
                'If your report involves serious issues like theft, fraud, or any suspicious activity, please stay alert and avoid direct contact with the parties involved until you receive further communication from Admin.',
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

  Future<void> getAllData({bool forceRefresh = false}) async {
    String myUrl = ApiConstant.GET_REPORT_LIST(selectedPage);
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);

    if (apiResponse.status == 200) {
      GetAllReportIncidentResponse response =
      GetAllReportIncidentResponse.fromJson(apiResponse.response);

      if (selectedPage == 0 || forceRefresh) {
        allReport.clear();
        allReportTemp.clear();
      }
      allReport.addAll(response.content!);
      allReportTemp.addAll(response.content!);
      notifyListeners();
    }
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
      String myUrl = ApiConstant.SEARCH_REPORT(searchController.text, user.content!.first.id);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
      if (apiResponse.status == 200) {
        try {
          MyReportIncidentResponse newsResponse =
          MyReportIncidentResponse.fromJson(apiResponse.response);
          if (newsResponse.content!.isNotEmpty) {
            allReport.clear();
            allReport.addAll(newsResponse.content!);
          } else {
            allReport.clear();
          }
        } catch (e) {
          print('Error decoding response: $e');
          allReport.clear();
        }
      }
    } else {
      allReport.clear();
      allReport.addAll(allReportTemp);
    }
    notifyListeners();
  }

  Future<void> getMyIncidentData() async {
    try {
      final user = await LocalSharePreferences.localSharePreferences.getLoginData();
      final String url = ApiConstant.MY_INCIDENT(user.content!.first.id);
      final ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(url);
      debugPrint(url);
      debugPrint(apiResponse.response.toString());
      allReport.clear(); // fresh start

      if (apiResponse.status == 200) {
        try {
          MyReportIncidentResponse newsResponse =
          MyReportIncidentResponse.fromJson(apiResponse.response);
          debugPrint(newsResponse.content!.length.toString());
            allReport.addAll(newsResponse.content!);
          } catch (e) {
          print('Error decoding response: $e');
          allReport.clear();
        }
      }
    } catch (e, s) {
      debugPrint('getMyIncidentData exception: $e\n$s');
    }
    notifyListeners();
  }


  Future<void> deletePost(IncidentObject incidentObj, BuildContext context) async {
    String myUrl = '${ApiConstant.DELETE_INCIDENT(incidentObj.id)}';
    ApiResponse apiResponse = await ApiHelper().ApiDeleteData(myUrl);
    if (apiResponse.status == 200) {
      ToastMessage.show(context, "Post deleted successfully");
      await toggleMyReport(_myIncident);
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }
  Future<void> LoadReports() async {
    isLoadDone = false;
    allReport.clear();
    allReportTemp.clear();
    selectedPage = 0;

    if (_myIncident) {
      await getMyIncidentData();
    } else {
      await getAllData();
    }

    isLoadDone = true;
    notifyListeners();
  }

  String _totalLostAmt = '';
  String get totalLostAmt => _totalLostAmt;
  Future<void> getTotalLostAmt() async {

    try {
      final url = ApiConstant.totalAmountLost;
      debugPrint('Total Lost Amount API: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // ✅ Convert to string safely
        _totalLostAmt = jsonData['data']?.toString() ?? '0';
      } else {
        debugPrint('❌ API failed: ${response.statusCode}');
        _totalLostAmt = '0';
      }
    } catch (e) {
      debugPrint('❌ Exception in getTotalLostAmt: $e');
      _totalLostAmt = '0';
    }

    notifyListeners();
  }

}

