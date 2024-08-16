import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tkd_connect/network/api_helper.dart';

import '../utils/camerabottomsheet.dart';

class BaseProvider extends ChangeNotifier {
  String appState = "Ideal";


  BaseProvider(this.appState);

  Future<String> postImage(BuildContext context) async {

    XFile file = await CameraBottomsheet().show(context);
    String response = await ApiHelper().uploadImage(file);
    response = response.replaceAll("\"", "");
    return response;
  }
  
  sendBid(){
    ApiHelper().postParameter("url", {});
  }



}
