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
   // pagenationHorizantal();
   // pagenationVerical();
    getAllData();
  }

  int allSelectedPage = 0;
  int selectedPage = 0;

  List<Content> allNewsTemp = [];
  List<Content> allNews = [];

  bool isLoadDone = false;
  bool _myNews = false;

  bool get myNews => _myNews;

  void toggleMyNews(bool value) {
    _myNews = value;
    if(_myNews==true){
      getMyNewsData();
    }else{
      getAllData();
    }
    notifyListeners();
  }

  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  List<String> images = [];

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

  getAllData() async {
    String myUrl = ApiConstant.GET_NEWS_LIST(allSelectedPage);

    print("Url $myUrl");
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);

    if (apiResponse.status == 200) {
      GetAllNewsResponse newsResponse =
          GetAllNewsResponse.fromJson(apiResponse.response);

      if (allSelectedPage == 0) {
        allNews.clear();
        allNewsTemp.clear();
      }
      allNews.addAll(newsResponse.content!);
      allNewsTemp.addAll(newsResponse.content!);
     // allSelectedPage++;
    }
    isLoadDone = true;
    notifyListeners();
  }



 /* pagenationVerical() {
    scrollControllerVertical.addListener(() {
      if (scrollControllerVertical.position.pixels ==
          scrollControllerVertical.position.maxScrollExtent) {
        toggleMyNews(_myNews);
      }
    });
  }

  pagenationHorizantal() {
    scrollControllerHorizantal.addListener(() {
      if (scrollControllerHorizantal.position.pixels ==
          scrollControllerHorizantal.position.maxScrollExtent) {
        toggleMyNews(_myNews);
      }
    });
  }
*/
  checkValidation(BuildContext context) {
    if (topicController.text.isEmpty) {
      ToastMessage.show(context, "Please add news title");
    } else {
      if (images.isEmpty) {
        ToastMessage.show(context, "Please upload image");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Add News',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                'Are you sure you want to add this news?',
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
                    createPost(context);
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
    }
    notifyListeners();
  }

  createPost(BuildContext context) async {
    User user =
        await LocalSharePreferences.localSharePreferences.getLoginData();
    AddNewsRequest postLoad = AddNewsRequest();
    postLoad.companyName = user.content!.first.companyName!;
    postLoad.description = descriptionController.text;
    postLoad.date = '';
    postLoad.firstName = user.content!.first.firstName!;
    postLoad.image = images[0];
    postLoad.lastName = user.content!.first.lastName;
    postLoad.mobileNumber = user.content!.first.mobileNumber!;
    postLoad.profilePicture = user.content!.first.profilePicture;
    postLoad.topicName = topicController.text;
    postLoad.userId = user.content!.first.id;
    postLoad.image2 = images[0];
    postLoad.image3 = images[0];
    postLoad.image4 = images[0];
    postLoad.image5 = images[0];
    postLoad.imageType = "png";
    postLoad.isApproved = 1;
    postLoad.youtubeLink = linkController.text;

    ApiResponse response = await ApiHelper().postParameter(
        "${ApiConstant.ADD_NEWS}",
        postLoad.toJson());
    print('The response status code: ${response.status}');

    if (response.status == 200) {
      Content content = Content.fromJson(response.response);
      allNews.add(content);
      ToastMessage.show(context, "News added successfully!");
      toggleMyNews(_myNews);
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context); // Close the first dialog
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  getBySearchData() async {
    if (searchController.text.length > 2) {
      String myUrl = ApiConstant.SEARCH_NEWS(searchController.text);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
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
    notifyListeners();
  }

  getMyNewsData() async {
    User user =
    await LocalSharePreferences.localSharePreferences.getLoginData();
      String myUrl = ApiConstant.MY_NEWS(user.content!.first.id,selectedPage);
      print(myUrl);
      ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
      if (apiResponse.status == 200) {
        GetAllNewsResponse newsResponse =
        GetAllNewsResponse.fromJson(apiResponse.response);
        if (selectedPage == 0) {
          allNews.clear();
        }
        allNews.addAll(newsResponse.content!);
        //selectedPage++;
      }
    notifyListeners();
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
    if (topicController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      enbleButton = true;
    } else {
      enbleButton = false;
    }
    notifyListeners();
  }

  deletePost(Content content,BuildContext context)async{
    String myUrl = '${ApiConstant.DELETE_NEWS(content.id)}';
    print(myUrl);
    ApiResponse apiResponse= await ApiHelper().ApiDeleteData(myUrl);
    print(apiResponse.response);
    if(apiResponse.status==200){
      toggleMyNews(true);
      ToastMessage.show(context, "Post deleted successfully");
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }
}
