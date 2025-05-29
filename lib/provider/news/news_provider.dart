import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
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

class NewsProvider extends  BaseProvider{
  NewsProvider() : super('Ideal'){
    pagenationHorizantal();
    pagenationVerical();
    getAllData();
  }
  int selectedPage=0;

  List<Content> allNewsTemp=[];
  List<Content> allNews=[];

  bool isLoadDone=false;

  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController=TextEditingController();


  getAllData() async {
    User userLogin=await LocalSharePreferences().getLoginData();

    String myUrl = ApiConstant.GET_NEWS_LIST(selectedPage);


    print("Url $myUrl");
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);

    if(apiResponse.status==200){
      GetAllNewsResponse newsResponse=GetAllNewsResponse.fromJson(apiResponse.response);

      if(selectedPage==0){
        allNews.clear();
        allNewsTemp.clear();
      }
      allNews.addAll(newsResponse.content!);
      allNewsTemp.addAll(newsResponse.content!);
      selectedPage++;
    }
    isLoadDone=true;
    notifyListeners();
  }

  pagenationVerical(){
    scrollControllerVertical.addListener(() {
      if (scrollControllerVertical.position.pixels ==
          scrollControllerVertical.position.maxScrollExtent) {
        getAllData();

      }
    });
  }

  pagenationHorizantal(){
    scrollControllerHorizantal.addListener(() {
      if (scrollControllerHorizantal.position.pixels ==
          scrollControllerHorizantal.position.maxScrollExtent) {
        getAllData();

      }
    });
  }




  getBySearchData() async {

    if(searchController.text.length>2){
      String myUrl = ApiConstant.DIRECTORY(searchController.text);
      ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
      if(apiResponse.status==200){GetAllNewsResponse allNewsResponse=GetAllNewsResponse.fromJson(apiResponse.response);
      allNews.clear();
      allNews.addAll(allNewsResponse.content!);
      }
    }else{
      allNews.clear();
      allNews.addAll(allNewsTemp);
    }
    notifyListeners();
  }





  getDetailsOfUserDirectory(int id,BuildContext context) async{

    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.GET_DIRECT_USER_DETAILS(id));
    if(apiResponse.status==200){
      TransportSearchModel transportSearchData=TransportSearchModel.fromJson(apiResponse.response);
      Navigator.pushNamed(context, AppRoutes.viewprofiledirectory,arguments: transportSearchData.content.first);

    }else {
      ToastMessage.show(context, "Please try again");
    }


  }

}