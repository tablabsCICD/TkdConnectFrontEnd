import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tkd_connect/model/api_response.dart';
import 'package:tkd_connect/model/response/phone_pay_model.dart';
import 'package:tkd_connect/model/response/userdata.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:tkd_connect/utils/sharepreferences.dart';
import 'package:tkd_connect/utils/toast.dart';

import '../constant/api_constant.dart';
import '../model/request/loadpost.dart';
import '../model/request/post_load.dart';
import '../route/app_routes.dart';

class RazorPayClassLoad {
  BuildContext context;
  static String orderID="id";
  static bool iscreate=false;
   static PostLoad postLoadObj=PostLoad();
  RazorPayClassLoad(this.context);





  createOrderId(int amount) async {
    User user=await LocalSharePreferences().getLoginData();
    ApiResponse apiResponse=await ApiHelper().apiPost(ApiConstant.CREATE_ORDER_ID(amount,user.content!.first.id));
    if(apiResponse.status==200){
      RazorPayOrderId payOrderId=RazorPayOrderId.fromJson(apiResponse.response);
      orderID=payOrderId.data!;
    }



  }

  initalPay(int amount,int contact,String email,PostLoad postLoad)async{
    postLoadObj=postLoad;
    await createOrderId(amount);
    if(orderID=="id"){
      ToastMessage.show(context, "Please try again");
      return;
    }

    Razorpay razorpay = Razorpay();
    // var options1 = {
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
      'name': 'Post Load.',
      'order_id': orderID, // Generate order_id using Orders API
      'description': 'TKD',
      'timeout': 90, // in seconds
      'prefill': {
        'contact': '$contact',
        'email': email
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
    String razorpaySignature=response.data!["razorpay_signature"];
    String  razorpayOrderId=response.data!["razorpay_order_id"];
    String? paymentId=response.paymentId;

    callSignature(razorpaySignature,razorpayOrderId,paymentId);



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

  void callSignature(String razorpaySignature,String  razorpayOrderId,String? paymentId)async {
    User user=await LocalSharePreferences().getLoginData();

    LoadPay loadPay=LoadPay();
    loadPay.postLoad=postLoadObj;
    RazorPayObject objetRazorPay=RazorPayObject();
    objetRazorPay.userId=user.content!.first.id;
    objetRazorPay.plan=user.content!.first.isPaid;
    objetRazorPay.razorPayOrderId=razorpayOrderId;
    objetRazorPay.signature=razorpaySignature;
    objetRazorPay.transactionId=paymentId;
    loadPay.razorPayObject=objetRazorPay;
    ApiResponse response=await ApiHelper().postParameter(ApiConstant.LOAD_PAYMENT_SIGNATURE, loadPay.toJson());
    print('the response is ${response.response}');
    if(response.status==200){
      showAlertDialog(context, "Payment Successful ", "Redirect To Home");
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context,AppRoutes.home, (route) => true);
    }
    else{
      showAlertDialog(
          context, "Payment Faild", "Payment ID: ");
    }
  }

}

