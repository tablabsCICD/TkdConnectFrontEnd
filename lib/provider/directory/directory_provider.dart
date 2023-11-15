import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/widgets/card/base_widgets.dart';

import '../../model/api_response.dart';
import '../../model/response/transport_directory_search.dart';
import '../../network/api_helper.dart';

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

  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();
  TextEditingController searchController=TextEditingController();


  getAllData() async {
    String myUrl = ApiConstant.DIRECTORYALL(selectedPage);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    if(apiResponse.status==200){TransportSearchModel transportSearchData=TransportSearchModel.fromJson(apiResponse.response);
    user.addAll(transportSearchData.content);
    userTemp.addAll(transportSearchData.content);

    userVerify.addAll(user.where((element) => element.isPaid!=0));
    selectedPage++;
    }

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





}