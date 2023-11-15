import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:tkd_connect/provider/base_provider.dart';

class ListExpProvider extends BaseProvider{
  List<String>listExp=["Fresher","6 Month","1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year","4 Year","4.5  Year","5 Year","5.5 Year","6 Year"];


  ListExpProvider(super.appState);
  String nameFrom="no";
  String nameTo="no";
  bool onFrom=true;
  bool isEnable=false;

  changeTab(){
    if(onFrom){
      onFrom=false;
    }else{
      onFrom=true;
    }
    notifyListeners();
  }


  void selectTab(int index) {
    if(onFrom){
      nameFrom=listExp[index];
    }else{
      nameTo=listExp[index];
    }
    checkButton();
    notifyListeners();

  }

 bool checkSelecte(int index) {
    if(onFrom){
      if(nameFrom==listExp[index]){
        return true;
      }else{
       return false;
      }

    }else{
      if(nameTo==listExp[index]){
        return true;
      }else{
        return false;
      }
    }

  }

  void checkButton() {
    if(nameTo=="no" || nameFrom=="no"){
      isEnable=false;
    }else{
      isEnable=true;
    }

  }

  onclick(BuildContext context){
    Navigator.pop(context,nameFrom+","+nameTo);
  }






}