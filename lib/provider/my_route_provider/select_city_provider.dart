import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/provider/base_provider.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../../model/request/route_request.dart';
import '../../model/response/city_selection.dart';

class SelectCityProvider extends BaseProvider {

  final bool isEdit;
  final String dest;
  final String sorce;
  SelectCityProvider(super.appState, this.isEdit, this.dest, this.sorce){
      getCallCity();
      pagenation();
  }
  bool isButtonEnbale=false;
  List<dynamic>cityList=[];
  List<CitySelection> listCity=[];
  bool isSelectStartLocation=true;
  bool isSelectDestination=false;
  late String _selectedStartCity;
  late String _selectedDestinationCity;
  late int _selectedInextStart=-1;
  late int _selectedInextDestination=-1;
  List<CitySelection> temListCity=[];
  TextEditingController searchController=TextEditingController();
  int selectedPage=0;
  ScrollController scrollController = ScrollController();


  getCallCity()async{
    var request=await ApiHelper().apiGet(ApiConstant.GET_ALL_CITY(selectedPage));
     if(request.status==200){
      cityList=request.response;
      for(int i=0;i<cityList.length;i++){
        CitySelection citySelection=CitySelection(cityList[i], false,i);
        listCity.add(citySelection);
        temListCity.addAll(listCity);
        selectedPage++;
      }
    }
     if(isEdit){
       onEditCity(sorce, dest);
     }
     notifyListeners();

  }


  pagenation(){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getCallCity();

      }
    });
  }


  selectCity(int index){
    clearCity();
    if(isSelectStartLocation){
      listCity[index].isSelect=true;
      _selectedStartCity=listCity[index].name;
      _selectedInextStart=listCity[index].id;
    }else{
      _selectedDestinationCity=listCity[index].name;
      listCity[index].isSelect=true;
      _selectedInextDestination=listCity[index].id;
    }
    buttonEnable();
    notifyListeners();
   }
  clearCity(){
    for(int i=0;i<listCity.length;i++){

      listCity[i].isSelect=false;
    }
  }

  clearCityTab(){
    for(int i=0;i<listCity.length;i++){
       listCity[i].isSelect=false;
    }
    if(isSelectStartLocation){
      if(_selectedInextStart!=-1){
      for(int i=0;i<listCity.length;i++){
        if(listCity[i].id==_selectedInextStart){
          listCity[i].isSelect=true;
        }
      }
      }
    }else {
      if(_selectedInextDestination!=-1){

        for(int i=0;i<listCity.length;i++){
          if(listCity[i].id==_selectedInextDestination){
            listCity[i].isSelect=true;
          }
        }
      }
    }
  }
  selectTab(String name){
    if(name.compareTo("Start")==0){
       isSelectStartLocation=true;
       isSelectDestination=false;
       clearCityTab();
    }else{
      isSelectStartLocation=false;
      isSelectDestination=true;
      clearCityTab();
    }
    buttonEnable();
    notifyListeners();
  }

  buttonEnable(){
    if(_selectedInextDestination!=-1 && _selectedInextStart!=-1){
      isButtonEnbale=true;
    }else{
      isButtonEnbale=false;
    }
  }

  onClickButton(BuildContext context){
    if(_selectedStartCity==_selectedInextDestination){
      ToastMessage.show(context, "Please select other city");
    }else{
      RouteRequest routeRequest=RouteRequest(_selectedStartCity, _selectedDestinationCity, _selectedInextStart, _selectedInextDestination);
      Navigator.of(context).pop(routeRequest);
    }

  }


  selectOneCity(int index){
    clearCity();
    if(isSelectStartLocation){
      listCity[index].isSelect=true;
      _selectedStartCity=listCity[index].name;
      _selectedInextStart=listCity[index].id;
    }
    buttonEnableOne();
    notifyListeners();
  }

  buttonEnableOne(){
    if(_selectedInextStart!=-1){
      isButtonEnbale=true;
    }else{
      isButtonEnbale=false;
    }
  }


  onClickOne(BuildContext context){
    RouteRequest routeRequest=RouteRequest(_selectedStartCity, "Mumbai", _selectedInextStart, 0);
    Navigator.of(context).pop(routeRequest);
  }

  onEditCity(String source,String destination){
    _selectedStartCity=source;
    _selectedDestinationCity=destination;
    for(int i=0;i<listCity.length;i++){

      if(_selectedStartCity==listCity[i].name){
        selectCity(i);
  }
      if(_selectedDestinationCity==listCity[i].name){
        _selectedInextDestination=i;
      }
    }

    notifyListeners();


  }

  searchCity(String name)async{
    if(name.length>2){
      var request=await ApiHelper().apiGet(ApiConstant.GET_ALL_CITY_SERACH(name));
      if(request.status==200){
        cityList=request.response;

        listCity.clear();
        for(int i=0;i<cityList.length;i++){
          CitySelection citySelection=CitySelection(cityList[i], false,i);

          listCity.add(citySelection);
        }
        notifyListeners();
      }
    }else{
      listCity.clear();
      listCity.addAll(temListCity);
    }
    notifyListeners();
  }

}