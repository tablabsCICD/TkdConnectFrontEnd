import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/route/app_routes.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../generated/l10n.dart';
import '../../screen/jobs/experience_screen.dart';

class CreateJobProvider extends BaseProvider{
  CreateJobProvider(super.appState) {
    positionController.addListener(buttonEnble);
    JobTitileController.addListener(buttonEnble);
    descriptionController.addListener(buttonEnble);
    salController.addListener(buttonEnble);
  }

  TextEditingController positionController=TextEditingController();
  TextEditingController JobTitileController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController salController=TextEditingController();
  bool buttonActive=false;
  bool isSubmitting=false;
  String expFrom=S().from;
  String expTo=S().to;
  bool expUpdate=false;
  String selectSal="Select salary";

  List<String>salary=["1 LPA ","1LPA - 2LPA","2LPA - 3LPA","4LPA - 5LPA","6LPA - 7LPA","8LPA - 9LPA","9LPA - 10LPA","10LPA - Above"];


  showExpDialog(BuildContext context)async{
    String? cityName= await showModalBottomSheet<String?>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
              heightFactor: 0.9,
              child: ExperienceScreen());
        });
    if(cityName!=null){
      expFrom=cityName.split(",").first;
      expTo=cityName.split(",").last;
      expUpdate=true;
      buttonEnble();
      notifyListeners();
    }
  }



  buttonEnble(){
    bool isExpSelected = (expUpdate || (expFrom != S().from && expTo != S().to)) &&
        expFrom.isNotEmpty &&
        expTo.isNotEmpty &&
        expFrom != "no" &&
        expTo != "no";

    bool canEnable = positionController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        JobTitileController.text.trim().isNotEmpty &&
        salController.text.trim().isNotEmpty &&
        isExpSelected;

    if (buttonActive != canEnable) {
      buttonActive = canEnable;
      notifyListeners();
    }
  }

  onSubitJobPost(BuildContext context)async{
    if (isSubmitting) return;

    // 1. Retrieve Logged-in User Data
    User? user;
    try {
      LocalSharePreferences localSharePreferences = LocalSharePreferences();
      user = await localSharePreferences.getLoginData();
    } catch (e) {
      debugPrint("Error retrieving logged-in user data: $e");
    }

    final userContent = (user?.content != null && user!.content!.isNotEmpty)
        ? user.content!.first
        : null;

    if (userContent == null || userContent.id == null || userContent.id == 0) {
      if (context.mounted) {
        ToastMessage.show(context, "Please log in to post a job.");
      }
      return;
    }

    isSubmitting = true;
    notifyListeners();

    try {
      // 2. Prepare payload with logged-in user details according to backend contract
      String companyName = "";
      if (userContent.companyName != null && userContent.companyName!.trim().isNotEmpty) {
        companyName = userContent.companyName!.trim();
      } else if (userContent.userName != null && userContent.userName!.trim().isNotEmpty) {
        companyName = userContent.userName!.trim();
      } else if (userContent.firstName != null && userContent.firstName!.trim().isNotEmpty) {
        companyName = "${userContent.firstName ?? ''} ${userContent.lastName ?? ''}".trim();
      }

      String userCity = (userContent.city != null && userContent.city!.trim().isNotEmpty)
          ? userContent.city!.trim()
          : "city";

      String platformName = kIsWeb
          ? "Web"
          : (defaultTargetPlatform == TargetPlatform.iOS ? "iOS" : "Android");

      Map<String, dynamic> data = {
        "companyName": companyName,
        "contactNumber": userContent.mobileNumber ?? 0,
        "emailId": userContent.emailId ?? "",
        "experience": "$expTo-$expFrom",
        "isSalaryNegotiable": 1,
        "isSelected": 0,
        "jobDepartment": JobTitileController.text.trim(),
        "jobDescription": descriptionController.text.trim(),
        "jobLocation": userCity,
        "jobType": positionController.text.trim(),
        "loggedTime": '',
        "loggedUserName": userContent.userName ?? "",
        "mainTag": "Job Seeker",
        "message": descriptionController.text.trim(),
        "os": platformName,
        "postingTime": '',
        "privatePost": 0,
        "removedDate": '',
        "salary": salController.text.trim(),
        "tableName": " ",
        "topicName": " ",
        "type": "Job Seeker",
        "userId": userContent.id
      };

      ApiResponse apiResponse =
          await ApiHelper().postParameter(ApiConstant.POST_JOB, data);

      String? extractMessage(dynamic response) {
        if (response == null) return null;
        if (response is Map) {
          if (response['message'] != null &&
              response['message'].toString().trim().isNotEmpty) {
            return response['message'].toString().trim();
          }
          if (response['error'] != null &&
              response['error'].toString().trim().isNotEmpty) {
            return response['error'].toString().trim();
          }
          if (response['msg'] != null &&
              response['msg'].toString().trim().isNotEmpty) {
            return response['msg'].toString().trim();
          }
        }
        if (response is String && response.trim().isNotEmpty) {
          try {
            final decoded = json.decode(response);
            if (decoded is Map) {
              return decoded['message'] ?? decoded['error'] ?? decoded['msg'];
            }
          } catch (_) {
            return response.trim();
          }
        }
        return null;
      }

      // Check success
      if (apiResponse.status == 200 || apiResponse.status == 201) {
        if (apiResponse.response is Map && apiResponse.response['statusCode'] == 401) {
          String msg = extractMessage(apiResponse.response) ??
              "Please update your subscription package to post jobs.";
          if (context.mounted) {
            ToastMessage.show(context, msg);
            Navigator.pushNamed(context, AppRoutes.registration_plan_details);
          }
          return;
        }

        String successMsg = extractMessage(apiResponse.response) ?? "Job created successfully.";
        if (context.mounted) {
          ToastMessage.show(context, successMsg);
          Navigator.pop(context, 1);
        }
      } else {
        String? apiMsg = extractMessage(apiResponse.response);
        String errorMsg;
        if (apiMsg != null && apiMsg.isNotEmpty) {
          errorMsg = apiMsg;
        } else if (apiResponse.status == 400) {
          errorMsg = "Invalid job post details. Please check the form fields.";
        } else if (apiResponse.status == 401 || apiResponse.status == 403) {
          errorMsg = "You are not authorized to post a job. Please verify your subscription.";
        } else if (apiResponse.status == 404) {
          errorMsg = "Job service is currently unavailable. Please try again later.";
        } else if (apiResponse.status == 500 ||
            apiResponse.status == 502 ||
            apiResponse.status == 503) {
          errorMsg = "Server error occurred. Please try again later.";
        } else {
          errorMsg = "Unable to create job post. Please try again.";
        }
        if (context.mounted) {
          ToastMessage.show(context, errorMsg);
        }
      }
    } catch (e) {
      debugPrint("Job submission error: $e");
      String errorMsg = "Unable to post job. Please check your internet connection and try again.";
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMsg = "Connection timed out. Please check your internet connection.";
        } else if (e.type == DioExceptionType.connectionError) {
          errorMsg = "No internet connection. Please verify your network.";
        }
      }
      if (context.mounted) {
        ToastMessage.show(context, errorMsg);
      }
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  selectedJob(a){
    if (a != null && a >= 0 && a < salary.length) {
      selectSal=salary[a];
      salController.text=salary[a];
      buttonEnble();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    positionController.removeListener(buttonEnble);
    JobTitileController.removeListener(buttonEnble);
    descriptionController.removeListener(buttonEnble);
    salController.removeListener(buttonEnble);
    positionController.dispose();
    JobTitileController.dispose();
    descriptionController.dispose();
    salController.dispose();
    super.dispose();
  }
}