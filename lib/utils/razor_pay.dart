import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/phone_pay_model.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../constant/api_constant.dart';
import '../constant/app_constant.dart';
import '../route/app_routes.dart';

class RazorPayClass {
   BuildContext context;
  static String orderID="id";
  static int planId=0;

  RazorPayClass(this.context);





    createOrderId(int amount) async {
      User user=await LocalSharePreferences().getLoginData();
      ApiResponse apiResponse=await ApiHelper().apiPost(ApiConstant.CREATE_ORDER_ID(amount,user.content!.first.id));
      if(apiResponse.status==200){
       RazorPayOrderId payOrderId=RazorPayOrderId.fromJson(apiResponse.response);
       orderID=payOrderId.data!;
      }



    }

  initalPay(int amount,int contact,String email,String packageName,int plan)async{
      planId=plan;
      await createOrderId(amount);
     if(orderID=="id"){
       ToastMessage.show(context, "Please try again");
       return;
     }
    Razorpay razorpay = Razorpay();
    // var options = {
    //   'key': 'rzp_test_7zwe2M6kcEJB5d',
    //   'amount': amount,
    //   'name': 'Acme Corp.',
    //   'description': 'Fine T-Shirt',
    //   'retry': {'enabled': true, 'max_count': 1},
    //   'send_sms_hash': true,
    //   'prefill': {
    //     'contact': '$contact',
    //     'email': '$email'
    //   },
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };
    var options1 = {
      'key': 'rzp_live_LraIKZvldr9N1J',
      'amount': amount, //in the smallest currency sub-unit.
      'name': 'Package.',
      'order_id': '$orderID', // Generate order_id using Orders API
      'description': 'TKD',
      'timeout': 60, // in seconds
      'prefill': {
        'contact': '$contact',
        'email': '$email'
      }
    };
    razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected);
    razorpay.open(options1);

  }


  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Please Try Again");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print(response.data.toString());
    String razorpay_signature=response.data!["razorpay_signature"];
    String  razorpay_order_id=response.data!["razorpay_order_id"];
    String? paymentId=response.paymentId;
  callSignature(razorpay_signature,razorpay_order_id,paymentId,planId);



  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void callSignature(String razorpay_signature,String  razorpay_order_id,String? paymentId,int plan)async {
      User user=await LocalSharePreferences().getLoginData();

      Map<String,dynamic>parameter={
          "plan": plan,
          "razorPayOrderId": razorpay_order_id,
          "signature": razorpay_signature,
          "transactionId": paymentId,
          "userId": user.content!.first.id

      };
      ApiResponse response=await ApiHelper().postParameter(ApiConstant.PAYMENT_SIGNATURE, parameter);
      print('the response is ${response.response}');
      if(response.status==200){
        showAlertDialog(
            context, "Payment Successful", "Redirect To Home");
        LocalSharePreferences localSharePreferences=LocalSharePreferences();
        localSharePreferences.setString(AppConstant.LOGIN_KEY, jsonEncode(response.response));
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context,AppRoutes.home, (route) => true);

          }
        else{
        showAlertDialog(
            context, "Payment Faild", "Payment ID: ");
          }
     }
}

