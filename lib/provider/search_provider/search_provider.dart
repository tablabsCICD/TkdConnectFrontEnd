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

  bool isDigitsButNotMobile(String? input) {
    if (input == null) return false;

    final value = input.trim();
    return RegExp(r'^\d+$').hasMatch(value) && value.length != 10;
  }

  callPostApiSearch(
      BuildContext context,
      int currentPage,
      String search,
      ) async {
    User user =
    await LocalSharePreferences.localSharePreferences.getLoginData();

    EasyLoading.show(status: "Loading");

    final trimmed = search.trim();
    final lower = trimmed.toLowerCase();

    final bool startsWithTKD = lower.startsWith('tkd');
    final bool digitsNotMobile = isDigitsButNotMobile(trimmed);

    String url;

    // 🔥 USE ID SEARCH
    if (startsWithTKD || digitsNotMobile) {
      final uniqueId = trimmed;

      print("🔍 Searching by ID: $uniqueId");

      url =
      '${ApiConstant.HOMEPAGE_FILTER}'
          '?page=$currentPage'
          '&size=3'
          '&loggedUserId=${user.content!.first.id}'
          '&id=$uniqueId';
    }
    // 🔍 NORMAL SEARCH
    else {
      url =
      '${ApiConstant.HOMEPAGE_FILTER}'
          '?page=$currentPage'
          '&size=50'
          '&search=$trimmed'
          '&loggedUserId=${user.content!.first.id}';
    }

    print("API URL 👉 $url");

    final req = await http.get(Uri.parse(url));

    isFirstLoading = false;

    if (req.statusCode == 200) {
      response = json.decode(req.body);

      final type = TruckLoadType.fromJson(response);
      totalPages = type.totalPages;
      truckLoadTypeList.addAll(type.content);

      isLoading = false;
      EasyLoading.dismiss();
      notifyListeners();
    } else {
      EasyLoading.dismiss();
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
