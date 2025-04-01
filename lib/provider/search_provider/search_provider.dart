import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_connect/model/response/transport_directory_search.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';

import '../../constant/api_constant.dart';
import '../../model/api_response.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/userdata.dart';
import '../../utils/sharepreferences.dart';

class SearchProvider extends BaseProvider {
  bool tabPost = true;

  SearchProvider(super.appState);

  bool isLoading = true;
  var response;
  bool isFirstLoading = false;
  int totalPages = 0;
  bool fla = false, pla = false, flr = false, plr = false;
  int selectedPage = 0;
  bool isLoadingUser = false;

  List truckLoadTypeList = [];
  List<TransportSearchData> user = [];
  ScrollController scrollController = ScrollController();

  changeTab() {
    if (tabPost) {
      tabPost = false;
    } else {
      tabPost = true;
    }
    notifyListeners();
  }

  callPostApiSearch(BuildContext context, int currentPage, String search) async {
    User user = await LocalSharePreferences.localSharePreferences.getLoginData();
    EasyLoading.show(status: "Loading");

    // Regular expression to find 'TKD' followed by optional space and digits
    RegExp regex = RegExp(r'TKD\s*(\d+)');
    Match? match = regex.firstMatch(search);

    int uniqueId = 0;
    String url = '';

    // Check if the search string is only digits
    if (RegExp(r'^\d+$').hasMatch(search)) {
      uniqueId = int.parse(search);
      print("The unique ID is directly from the digit-only search: $uniqueId");
    }
    // Extract the unique ID if the match is found
    else if (match != null) {
      String digit = match.group(1) ?? ''; // Extract the digits after 'TKD'
      uniqueId = int.parse(digit);
      print("The unique ID is extracted from 'TKD': $uniqueId");
    } else {
      print("No unique ID found.");
    }

    // Construct the API URL
    if (uniqueId == 0) {
      url =
      '${ApiConstant.HOMEPAGE_FILTER}?page=$currentPage&size=10&search=$search&loggedUserId=${user.content!.first.id}';
    } else {
      url =
      '${ApiConstant.HOMEPAGE_FILTER}?page=$currentPage&size=10&loggedUserId=${user.content!.first.id}&id=$uniqueId';
    }

    print(url);

    // Call the API
    var req = await http.get(Uri.parse(url));

    isFirstLoading = false;

    if (req.statusCode == 200) {
      response = json.decode(req.body);
      var type = TruckLoadType.fromJson(response);
      totalPages = type.totalPages;
      truckLoadTypeList.addAll(type.content);
      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }


  pagenation(BuildContext context, String val) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        callPostApiSearch(context, selectedPage, val);
        selectedPage++;
      }
    });
  }

  callUser(String search) async {
    String myUrl = ApiConstant.DIRECTORY(search);
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
    if (apiResponse.status == 200) {
      TransportSearchModel transportSearchData =
          TransportSearchModel.fromJson(apiResponse.response);
      user.addAll(transportSearchData.content);
    }
    isLoadingUser = true;
    notifyListeners();
  }
}
