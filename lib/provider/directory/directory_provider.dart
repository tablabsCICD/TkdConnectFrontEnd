import 'package:flutter/material.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/screen/my_route/select_one_city.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/api_response.dart';
import '../../model/request/route_request.dart';
import '../../model/response/transport_directory_search.dart';
import '../../network/api_helper.dart';
import '../../route/app_routes.dart';

class DirectoryProvider extends  BaseProvider{
  DirectoryProvider() : super('Ideal'){
    pagenationHorizantal();
    pagenationVerical();
    getAllData();
  }
  int selectedPage=0;

  List truckLoadTypeList=[];
  List<TransportSearchData> userTemp=[];
  List<TransportSearchData> user=[];
  List<TransportSearchData> userVerify=[];
  bool isLoadDone=false;

  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController=TextEditingController();
  bool filterisVisible = false;
  String fromCity="All";
  String toCity="All";

  getAllData() async {
    //String myUrl = ApiConstant.DIRECTORYALL(selectedPage);
    User userLogin=await LocalSharePreferences().getLoginData();

    String myUrl = ApiConstant.GET_DIRECT_USER_LIST(selectedPage,userLogin.content!.first.id);

    if(filterisVisible){
      if(fromCity != "All" && toCity!="All"){
        myUrl="${ApiConstant.DIRECTORYFILTER}source=$fromCity&destination=$toCity";
      }else if(fromCity != "All" && toCity=="All"){
        myUrl="${ApiConstant.DIRECTORYFILTER}source=$fromCity";
      }else{
        myUrl="${ApiConstant.DIRECTORYFILTER}destination=$toCity";
      }

    }
    print("Url $myUrl");
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);

    if(apiResponse.status==200){
      TransportSearchModel transportSearchData=TransportSearchModel.fromJson(apiResponse.response);

   if(selectedPage==0){
     user.clear();
     userTemp.clear();
     userVerify.clear();
   }
      user.addAll(transportSearchData.content);
    userTemp.addAll(transportSearchData.content);
    userVerify.addAll(user.where((element) => element.isPaid!=0));
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
      if(apiResponse.status==200){TransportSearchModel transportSearchData=TransportSearchModel.fromJson(apiResponse.response);
        user.clear();
        user.addAll(transportSearchData.content);
      }
    }else{
      user.clear();
      user.addAll(userTemp);
      userVerify.addAll(user.where((element) => element.isPaid!=0));
    }
    notifyListeners();
  }



  onCliclFilter(BuildContext context){
    if(filterisVisible){
      filterisVisible=false;
      truckLoadTypeList.clear();
      notifyListeners();
      selectedPage=0;
      fromCity="All";
      toCity="All";
     getAllData();
    }else{
      filterisVisible=true;
    }
    notifyListeners();
  }


  selectCityFromFilter(BuildContext context)async{
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
              heightFactor: 0.9, child: SelectOneCityScreen());
        });
    fromCity=routeRequest.startLocation;
    selectedPage=0;
    user.clear();
    notifyListeners();
    getAllData();
    }

  selectToCityFilter(BuildContext context)async{
    RouteRequest routeRequest = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const FractionallySizedBox(
              heightFactor: 0.9, child: SelectOneCityScreen());
        });
    toCity=routeRequest.startLocation;
    selectedPage=0;
    user.clear();
    notifyListeners();
    getAllData();
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