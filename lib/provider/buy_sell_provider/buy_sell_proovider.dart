import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constant/api_constant.dart';
import '../../model/response/AllCard.dart';
import '../../model/response/userdata.dart';
import '../../network/api_helper.dart';
import '../../utils/sharepreferences.dart';
import '../../utils/toast.dart';

class BuySellProvider extends ChangeNotifier {
  bool isBuy = false;

  int selectedPage = 0;
  final int pageSize = 10; // keep in sync with API "size"
  bool isLoading = false;
  bool hasMore = true;

  List<TruckLoad> buySellList = [];
  User? user;

  // Filters & search & sort
  String? companyName;
  String? nameOfPerson;
  String? location;
  String? model;
  String? mfgYear;
  String? vehicleSize;
  int? minPrice;
  int? maxPrice;
  String? sortBy;
  String searchText = "";

  // controllers
  final companyCtrl = TextEditingController();
  final personCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final vehicleSizeCtrl = TextEditingController();

  /// If your API expects 1-based page index set this to 1.
  /// Most Spring backends expect 0-based pages; leave default 0.
  final int pageIndexBase = 0;

  BuySellProvider(BuildContext context) {
    loadUser();
    getBuySellList();
    pagenation(context); // initial load
  }

  void initFilterControllers() {
    companyCtrl.text = companyName ?? "";
    personCtrl.text = nameOfPerson ?? "";
    locationCtrl.text = location ?? "";
    modelCtrl.text = model ?? "";
    yearCtrl.text = mfgYear ?? "";
    vehicleSizeCtrl.text = vehicleSize ?? "";
  }

  Future<void> loadUser() async {
    try {
      user = await LocalSharePreferences().getLoginData();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> refresh() async {
    selectedPage = 0;
    hasMore = true;
    buySellList.clear();
    await getBuySellList();
  }

  ScrollController scrollController = ScrollController();

  pagenation(BuildContext context){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        selectedPage++;
        getBuySellList();
      }
    });
  }

  void updateSearch(String text) {
    searchText = text;
    refresh();
  }

  void switchTab(bool tab) {
    isBuy = tab;
    refresh();
  }

  void applyFilters({
    String? company,
    String? person,
    String? loc,
    String? mod,
    String? year,
    String? size,
    int? min,
    int? max,
  }) {
    companyName = company;
    nameOfPerson = person;
    location = loc;
    model = mod;
    mfgYear = year;
    vehicleSize = size;
    minPrice = min;
    maxPrice = max;
    refresh();
  }

  void clearFilters() {
    companyName = null;
    nameOfPerson = null;
    location = null;
    model = null;
    mfgYear = null;
    vehicleSize = null;
    minPrice = 0;
    maxPrice = 5000000;
    sortBy = null;

    companyCtrl.clear();
    personCtrl.clear();
    locationCtrl.clear();
    modelCtrl.clear();
    yearCtrl.clear();
    vehicleSizeCtrl.clear();

    refresh();
  }

  /// Main method with robust pagination detection
  Future<void> getBuySellList() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final currentPageToSend = (selectedPage + pageIndexBase).toString();
      Map<String, String> params = {
        "type": isBuy ? "Buy" : "Sell",
        "page": currentPageToSend,
        "size": pageSize.toString(),
      };

      if (searchText.isNotEmpty) params["search"] = searchText;
      if (companyName?.isNotEmpty == true) params["companyName"] = companyName!;
      if (nameOfPerson?.isNotEmpty == true) params["nameOfPerson"] = nameOfPerson!;
      if (location?.isNotEmpty == true) params["location"] = location!;
      if (model?.isNotEmpty == true) params["model"] = model!;
      if (mfgYear?.isNotEmpty == true) params["mfgYear"] = mfgYear!;
      if (vehicleSize?.isNotEmpty == true) params["vehicleSize"] = vehicleSize!;
      if (minPrice != null) params["minPrice"] = minPrice.toString();
      if (maxPrice != null) params["maxPrice"] = maxPrice.toString();
      if (sortBy != null && sortBy!.isNotEmpty) params["sortBy"] = sortBy!;

      final uri = Uri.parse(ApiConstant.BUY_SELL_ALL_CARD).replace(queryParameters: params);
      debugPrint("GET BUY/SELL -> $uri");

      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final raw = jsonDecode(res.body);

        // Try to parse using your model if it matches
        final parsed = TruckLoadType.fromJson(raw);

        // If first page, clear
        if (selectedPage == 0) buySellList.clear();

        buySellList.addAll(parsed.content);

        // === Robust 'hasMore' detection ===
        bool computedHasMore = false;

        // 1) If JSON contains explicit 'last' boolean (spring style)
        if (raw is Map && (raw.containsKey('last') || raw.containsKey('isLast'))) {
          final last = raw['last'] ?? raw['isLast'];
          if (last is bool) {
            computedHasMore = !last;
          }
        }

        // 2) If JSON has totalPages and number -> use it
        if (!computedHasMore && raw is Map && raw.containsKey('totalPages') && raw.containsKey('number')) {
          final number = raw['number'];
          final totalPages = raw['totalPages'];
          if (number is int && totalPages is int) {
            computedHasMore = (number < totalPages - 1);
          }
        }

        // 3) If JSON has totalElements and size -> use that
        if (!computedHasMore && raw is Map && raw.containsKey('totalElements') && raw.containsKey('size')) {
          final total = raw['totalElements'];
          final size = raw['size'];
          if (total is int && size is int) {
            final currentLoaded = buySellList.length;
            computedHasMore = currentLoaded < total;
          }
        }

        // 4) Fallback: if returned items equal pageSize -> maybe more, otherwise no
        if (!computedHasMore) {
          computedHasMore = parsed.content.length >= pageSize;
        }

        hasMore = computedHasMore;

        // increment selectedPage only if we did get items and we expect more pages next time
        if (parsed.content.isNotEmpty) {
          // increment regardless, we use hasMore to stop later calls
          selectedPage++;
        }
      } else {
        // non-200 -> stop further loads (avoid loops)
        hasMore = false;
      }
    } catch (e, st) {
      debugPrint("getBuySellList error: $e\n$st");
      // on error — keep hasMore true? better set to false to avoid repeated failing calls
      hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadMore() {
    if (!isLoading && hasMore) {
      getBuySellList();
    }
  }

  Future<void> deletePost(BuildContext context, int id) async {
    final res = await ApiHelper().ApiDeleteData("${ApiConstant.POST_BUY_SELL}?id=$id");
    if (res.status == 200) {
      buySellList.removeWhere((e) => e.id == id);
      ToastMessage.show(context, "Deleted Successfully");
    } else {
      ToastMessage.show(context, "Error deleting post");
    }
    notifyListeners();
  }
}
