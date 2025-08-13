import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/request/addNewsRequest.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/screen/my_route/select_one_city.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/api_response.dart';
import '../../model/request/route_request.dart';
import '../../model/response/allNewsResponse.dart';
import '../../model/response/transport_directory_search.dart';
import '../../network/api_helper.dart';
import '../../route/app_routes.dart';
import '../../utils/colors.dart';

class NewsProvider extends BaseProvider {
  NewsProvider() : super('Ideal') {
    //getAllData();
  }

  int allSelectedPage = 0;
  int selectedPage = 0;

  List<Content> allNewsTemp = [];
  List<Content> allNews = [];

  bool isLoadDone = false;
  bool _myNews = false;
  bool _isDisposed = false;

  bool get myNews => _myNews;

  void toggleMyNews(bool value) {
    _myNews = value;
    if (_myNews) {
      getMyNewsData();
    } else {
      getAllData();
    }
    notifySafely();
  }

  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  List<String> images = [];

  @override
  void dispose() {
    _isDisposed = true;
    scrollControllerVertical.dispose();
    scrollControllerHorizantal.dispose();
    searchController.dispose();
    topicController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void notifySafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  uploadImage(BuildContext context) async {
    String? image = await pickAndUploadImage(context);
    if (image != null) {
      images.add(image);
      print("Image uploaded successfully: $image");
    } else {
      print("Image upload failed or was cancelled.");
    }
    notifySafely();
  }

  getAllData() async {
    String myUrl = ApiConstant.GET_NEWS_LIST(allSelectedPage);
    print("Url $myUrl");

    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);

    if (apiResponse.status == 200) {
      GetAllNewsResponse newsResponse =
      GetAllNewsResponse.fromJson(apiResponse.response);

      if (allSelectedPage == 0) {
        allNews.clear();
        allNewsTemp.clear();
      }
      allNews.addAll(newsResponse.content!);
      allNewsTemp.addAll(newsResponse.content!);
    }
    isLoadDone = true;
    notifySafely();
  }

  String validationMessage = "";

  Future<bool> checkValidation() async {
    if (topicController.text.isEmpty) {
      validationMessage = "Please add news title";
      return false;
    } else if (images.isEmpty) {
      validationMessage = "Please upload image";
      return false;
    }

    final result = await createPost();
    return result;
  }

  Future<bool> createPost() async {
    try {
      User user = await LocalSharePreferences.localSharePreferences.getLoginData();

      AddNewsRequest postLoad = AddNewsRequest()
        ..companyName = user.content!.first.companyName!
        ..description = descriptionController.text
        ..date = ''
        ..firstName = user.content!.first.firstName!
        ..image = images[0]
        ..lastName = user.content!.first.lastName
        ..mobileNumber = user.content!.first.mobileNumber!
        ..profilePicture = user.content!.first.profilePicture
        ..topicName = topicController.text
        ..userId = user.content!.first.id
        ..image2 = images[0]
        ..image3 = images[0]
        ..image4 = images[0]
        ..image5 = images[0]
        ..imageType = "png"
        ..isApproved = 1
        ..youtubeLink = linkController.text;

      ApiResponse response = await ApiHelper().postParameter(
        ApiConstant.ADD_NEWS,
        postLoad.toJson(),
      );

      print('The response status code: ${response.response}');

      if (response.status == 200) {
        Content content = Content.fromJson(response.response);
        allNews.add(content);
        toggleMyNews(_myNews);
        notifySafely();
        return true;
      }
    } catch (e) {
      print("Exception in createPost: $e");
    }

    return false;
  }



  getBySearchData() async {
    if (searchController.text.length > 2) {
      String myUrl = ApiConstant.SEARCH_NEWS(searchController.text);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
      print(apiResponse.response);
      if (apiResponse.status == 200) {
        GetAllNewsResponse newsResponse =
        GetAllNewsResponse.fromJson(apiResponse.response);
        allNews.clear();
        allNews.addAll(newsResponse.content!);
      }
    } else {
      allNews.clear();
      allNews.addAll(allNewsTemp);
    }
    notifySafely();
  }

  getMyNewsData() async {
    User user =
    await LocalSharePreferences.localSharePreferences.getLoginData();
    String myUrl = ApiConstant.MY_NEWS(user.content!.first.id, selectedPage);
    print(myUrl);
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
    print(apiResponse.response);
    if (apiResponse.status == 200) {
      GetAllNewsResponse newsResponse =
      GetAllNewsResponse.fromJson(apiResponse.response);
      if (selectedPage == 0) {
        allNews.clear();
      }
      allNews.addAll(newsResponse.content!);
    }
    notifySafely();
  }

  getDetailsOfUserDirectory(int id, BuildContext context) async {
    ApiResponse apiResponse = await ApiHelper()
        .apiWithoutDecodeGet(ApiConstant.GET_DIRECT_USER_DETAILS(id));
    if (apiResponse.status == 200) {
      TransportSearchModel transportSearchData =
      TransportSearchModel.fromJson(apiResponse.response);
      Navigator.pushNamed(context, AppRoutes.viewprofiledirectory,
          arguments: transportSearchData.content.first);
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  bool enbleButton = false;

  enble() {
    enbleButton = topicController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
    notifySafely();
  }

  deletePost(Content content, BuildContext context) async {
    String myUrl = '${ApiConstant.DELETE_NEWS(content.id)}';
    print(myUrl);
    ApiResponse apiResponse = await ApiHelper().ApiDeleteData(myUrl);
    print(apiResponse.response);
    if (apiResponse.status == 200) {
      toggleMyNews(true);
      ToastMessage.show(context, "Post deleted successfully");
    } else {
      ToastMessage.show(context, "Please try again");
    }
    notifySafely();
  }

  Future<void> loadNews() async {
    isLoadDone = false;
    allNews.clear();
    allNewsTemp.clear();
    allSelectedPage = 0;
    selectedPage = 0;

    if (_myNews) {
      await getMyNewsData();
    } else {
      await getAllData();
    }

    isLoadDone = true;
    notifySafely();
  }
}
