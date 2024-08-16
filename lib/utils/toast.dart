import 'package:flutter/material.dart';

class ToastMessage{

  static show(BuildContext context,String message){
    SnackBar snackBar= SnackBar(content:
    Text(message),
      duration: const Duration(seconds: 2),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

}