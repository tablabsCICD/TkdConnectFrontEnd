import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:tkd_connect/constant/app_constant.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/network/api_helper.dart';

import '../constant/api_constant.dart';
import '../model/response/phone_pay_model.dart';

class PhonePayPayment {
  String environment = "RELEASE";
  String merchantId = "M22YOFUNC8SHQ";

  //String merchantId="PGTESTPAYUAT";

  String packageName = "com.phonepe.simulator";

  Future<bool> initPhonePay() async {
    return await PhonePePaymentSdk.init(environment, null, merchantId, true);
  }

  startTranscation() async {
    var result = "";
    await PhonePePaymentSdk.startTransaction(
            getBody(1000), 'null', getSalt(1000), null)
        .then((response) => (() {
              if (response != null) {
                String status = response['status'].toString();
                String error = response['error'].toString();
                if (status == 'SUCCESS') {
                  print('the response is ${response}');
                  result = "Flow Completed - Status: Success!";
                } else {
                  result = "Flow Completed - Status: $status and Error: $error";
                }
              } else {
                result = "Flow Incomplete";
              }
            }));
  }

  String getSalt(int amount) {
    String apiEndPoint = "/pg/v1/pay";
     var salt = "8c99929a-54ac-4f2a-b321-965536fde7ca";
    //var salt = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";

    var index = 1;
    return sha256
            .convert(utf8.encode(getBody(amount) + apiEndPoint + salt))
            .toString() +
        "###" +
        index.toString();


  }
  String getSaltVerfy(int amount) {
    String apiEndPoint = "/pg/v1/status/M22YOFUNC8SHQ/${AppConstant.PHONE_PAY_TRANSCATION_ID}";
     var salt = "8c99929a-54ac-4f2a-b321-965536fde7ca";
    var index = 1;
    return sha256
            .convert(utf8.encode(  apiEndPoint + salt))
            .toString() +
        "###" +
        index.toString();

    //SHA256("/pg/v1/status/{merchantId}/{merchantTransactionId}" + saltKey) + "###" + saltIndex
  }

  String getBody(int amount) {

    var body = {
      "merchantId": "M22YOFUNC8SHQ",
      // "merchantId": "PGTESTPAYUAT",

      "merchantTransactionId": AppConstant.PHONE_PAY_TRANSCATION_ID,
      "merchantUserId": "MUID123",
      "amount": 100,
      "callbackUrl": "https://webhook.site/callback-url",
      "mobileNumber": "9503334903",
      "paymentInstrument": {"type": "PAY_PAGE"}
    }; // Encode the request body to JSON
    String jsonBody = jsonEncode(body);
    String base64EncodedBody = base64Encode(utf8.encode(jsonBody));
    return base64EncodedBody;
  }


  getStatusOfTranscation()async{
    print('the trsanscation id is ${AppConstant.PHONE_PAY_TRANSCATION_ID}');
    print('the xveridy  ${getSaltVerfy(100)}');
    Dio dio=Dio();
    var headers = {
      'X-VERIFY': getSaltVerfy(100),
      'X-MERCHANT-ID': 'M22YOFUNC8SHQ',
      'Content-Type': 'application/json'
    };
    EasyLoading.show(status: "Loading");

  //  var request = await dio.get("https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/${AppConstant.PHONE_PAY_TRANSCATION_ID}");
    var request=await dio.request(
      'https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/M22YOFUNC8SHQ/${AppConstant.PHONE_PAY_TRANSCATION_ID}',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
    print('the response is ${request.data} status code is ${request.statusCode}');

    // ApiResponse apiResponse=await ApiHelper().apiGet("https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/MT7850590068192015");
    // print('the data is ${apiResponse.response}');

    
  }

  getTranscation() async{
    Map<String,dynamic>parameter={
      "userId ":31
    };
    ApiResponse apiResponse=await ApiHelper().postParameter(ApiConstant.BASE_URL+"phonepe/phonepay/UUID?userId=31", parameter);
    try{
      if(apiResponse.status==200){
        PhonePayModel payModel=PhonePayModel.fromJson(apiResponse.response);
        AppConstant.PHONE_PAY_TRANSCATION_ID=payModel.data!.uuid!;
      }
    }catch (e){
      print('$e');
    }

  }

}
