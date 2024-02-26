import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import 'package:tkd_connect/constant/app_constant.dart';

import '../model/api_response.dart';

class ApiHelper{
  Dio dio=Dio();

  Future<ApiResponse> apiGet(String URL) async{

    EasyLoading.show(status: "Loading");
    var request = await dio.get(URL);
    ApiResponse apiResponseHelper = returnResponse(request);
    EasyLoading.dismiss();
    return apiResponseHelper;

  }

  Future<ApiResponse> apiWithoutDecodeGet(String URL) async{
    try{
      EasyLoading.show(status: "Loading");
      var request = await dio.get(URL);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch (e){
      print(e);
      EasyLoading.dismiss();
      return ApiResponse(500, null);
    }

  }

  Future<ApiResponse> apiWithoutDilogDecodeGet(String URL) async{
    try{

      var request = await dio.get(URL);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch (e){
      print(e);
      return ApiResponse(500, null);
    }

  }

  Future<ApiResponse>  apiPost(String URL) async{

    try{
      EasyLoading.show(status: "Loading");
      var request = await dio.post(URL);
      ApiResponse apiResponseHelper = returnResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch (e){
      print('$e');
      EasyLoading.dismiss();
      return ApiResponse(500, null);
    }




  }

  Future<ApiResponse>  apiPostWithoutDialog(String URL) async{

    try{
     // EasyLoading.show(status: "Loading");
      var request = await dio.post(URL);
      ApiResponse apiResponseHelper = returnResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch (e){
      print('$e');
     // EasyLoading.dismiss();
      return ApiResponse(500, null);
    }




  }

  Future<ApiResponse>  apiPutDat(String URL) async{

    try{
      EasyLoading.show(status: "Loading");
      var request = await dio.put(URL);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch (e){
      print('$e');
      EasyLoading.dismiss();
      return ApiResponse(500, null);
    }




  }


  Future<ApiResponse>  apiDecodePost(String URL) async{

    try{
      EasyLoading.show(status: "Loading");
      var request = await dio.post(URL);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch (e){
      print('$e');
      EasyLoading.dismiss();
      return ApiResponse(500, null);
    }
   }

  Future<ApiResponse>  apiPut(String URL,Map<String,dynamic>data) async{
    var body = json.encode(data);
    var request = await dio.put(URL,data: body);
    ApiResponse apiResponseHelper = returnResponse(request);
    return apiResponseHelper;
  }


  Future<ApiResponse> ApiDeleteData(String URL) async{
   try{
     EasyLoading.show(status: "Loading");
     var request = await dio.delete(URL);
     ApiResponse apiResponseHelper = returnResponse(request);
     EasyLoading.dismiss();
     return apiResponseHelper;
   }catch(e){
     EasyLoading.dismiss();
     return ApiResponse(500, null);
   }

  }

  Future<ApiResponse> postParameter(String url,Map<String,dynamic>data) async{
    EasyLoading.show(status: "Loading");
    try{
      var body = json.encode(data);
      final request = await dio.post(url,data: body);
      print("Post Parameter:"+request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch(e){
      EasyLoading.dismiss();
      return ApiResponse(500, null);
    }
   }


  Future<ApiResponse> postParameterDecode(String url,Map<String,dynamic>data) async{
    EasyLoading.show(status: "Loading");
    try{
      var body = json.encode(data);
      final request = await dio.post(url,data: body);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      EasyLoading.dismiss();
      return apiResponseHelper;
    }catch(e){
      print(e);
      EasyLoading.dismiss();
      return ApiResponse(800, null);
    }
  }

  ApiResponse returnResponse<T>(Response request){
    try{
      if(request.statusCode==200){
        var response = json.decode(request.data);
        ApiResponse apiResponseHelper = ApiResponse(request.statusCode!, response);
        return apiResponseHelper;
      }else{
        ApiResponse apiResponseHelper = ApiResponse(request.statusCode!, null);
        return apiResponseHelper;
      }
    }catch(e) {

      print('$e');
      ApiResponse apiResponseHelper = ApiResponse(500, null);
      return apiResponseHelper;
    }

  }

  ApiResponse returnNotDecodeResponse<T>(Response request){
    if(request.statusCode==200){

      ApiResponse apiResponseHelper = ApiResponse(request.statusCode!, request.data);
      return apiResponseHelper;
    }else{
      ApiResponse apiResponseHelper = ApiResponse(request.statusCode!, null);
      return apiResponseHelper;
    }
  }

  Future<String> uploadImage(XFile file) async {
    EasyLoading.show(status: "Uploading");
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "profilePicture":
      await MultipartFile.fromFile(file.path, filename:fileName),
    });
    var response = await dio.post(ApiConstant.BASE_URL+"saveImage", data: formData);
    EasyLoading.dismiss();
    return response.data;
  }



}