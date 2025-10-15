import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tkd_connect/constant/api_constant.dart';
import '../model/api_response.dart';

class ApiHelper {
  Dio dio = Dio();

  Future<ApiResponse> apiGet(String URL) async {
    print(URL);
    EasyLoading.show(status: "Loading");
    try {
      var request = await dio.get(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> apiWithoutDecodeGet(String URL) async {
    print(URL);
    try {
      EasyLoading.show(status: "Loading");
      var request = await dio.get(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> apiWithoutDilogDecodeGet(String URL) async {
    print(URL);
    try {
      var request = await dio.get(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    }
  }

  Future<ApiResponse> apiPost(String URL) async {
    print(URL);
    try {
      EasyLoading.show(status: "Loading");
      var request = await dio.post(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> apiPostWithoutDialog(String URL) async {
    print(URL);
    try {
      var request = await dio.post(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    }
  }

  Future<ApiResponse> apiPutWithoutDialog(String URL) async {
    print(URL);
    try {
      var request = await dio.put(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    }
  }

  Future<ApiResponse> apiPutDat(String URL) async {
    print(URL);
    try {
      EasyLoading.show(status: "Loading");
      var request = await dio.put(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> apiDecodePost(String URL) async {
    print(URL);
    try {
      EasyLoading.show(status: "Loading");
      var request = await dio.post(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> apiPut(String URL, Map<String, dynamic> data) async {
    print(URL);
    try {
      var body = json.encode(data);
      print(body);
      var request = await dio.put(URL, data: body);
      print(request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    }
  }

  Future<ApiResponse> ApiDeleteData(String URL) async {
    print(URL);
    try {
      EasyLoading.show(status: "Loading");
      var request = await dio.delete(URL);
      print(request.data);
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> postParameter(String url, Map<String, dynamic> data) async {
    print(url);
    print(data);
    try {
      EasyLoading.show(status: "Loading");
      var body = json.encode(data);
      print(body);
      final request = await dio.post(url, data: body);
      print(request.data);
      print("Post response: ${request.data}");
      ApiResponse apiResponseHelper = returnResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse> postParameterDecode(String url, Map<String, dynamic> data) async {
    print(url);
    try {
      EasyLoading.show(status: "Loading");
      var body = json.encode(data);
      print(body);
      final request = await dio.post(url, data: body);
      print(request.data);
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      return apiResponseHelper;
    } catch (e) {
      print(e);
      return ApiResponse(800, null);
    } finally {
      EasyLoading.dismiss();
    }
  }

  ApiResponse returnResponse<T>(Response request) {
    try {
      if (request.statusCode == 200 || request.statusCode == 201) {
        var data = request.data;
        if (data is String) {
          data = json.decode(data);
        }
        return ApiResponse(request.statusCode!, data);
      } else if (request.statusCode == 500) {
        var data = request.data;
        if (data is String) {
          data = json.decode(data);
        }
        return ApiResponse(request.statusCode!, data);
      }else{
        return ApiResponse(request.statusCode!, null);
      }
    } catch (e) {
      print(e);
      return ApiResponse(500, null);
    }
  }

  ApiResponse returnNotDecodeResponse<T>(Response request) {
    if (request.statusCode == 200 || request.statusCode == 201) {
      return ApiResponse(request.statusCode!, request.data);
    } else {
      return ApiResponse(request.statusCode!, null);
    }
  }

  Future<String> uploadImage(XFile file) async {
    try {
      EasyLoading.show(status: "Uploading");
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profilePicture": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      debugPrint(ApiConstant.IMG_UPLOAD);
      var response = await dio.post("${ApiConstant.IMG_UPLOAD}", data: formData);
      debugPrint(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print(e);
      return "";
    } finally {
      EasyLoading.dismiss();
    }
  }
}
