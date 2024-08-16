import 'package:tkd_connect/model/request/post_load.dart';

class LoadPay {
  PostLoad? postLoad;
  RazorPayObject? razorPayObject;

  LoadPay({this.razorPayObject,this.postLoad});

  LoadPay.fromJson(Map<String, dynamic> json) {
    postLoad = json['fullTruckLoad'] != null
        ? PostLoad.fromJson(json['fullTruckLoad'])
        : null;
    razorPayObject = json['razorPayObject'] != null
        ? RazorPayObject.fromJson(json['razorPayObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (postLoad != null) {
      data['fullTruckLoad'] = postLoad!.toJson();
    }
    if (razorPayObject != null) {
      data['razorPayObject'] = razorPayObject!.toJson();
    }
    return data;
  }
}



class RazorPayObject {
  int? plan;
  String? razorPayOrderId;
  String? signature;
  String? transactionId;
  int? userId;

  RazorPayObject(
      {this.plan,
        this.razorPayOrderId,
        this.signature,
        this.transactionId,
        this.userId});

  RazorPayObject.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    razorPayOrderId = json['razorPayOrderId'];
    signature = json['signature'];
    transactionId = json['transactionId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plan'] = plan;
    data['razorPayOrderId'] = razorPayOrderId;
    data['signature'] = signature;
    data['transactionId'] = transactionId;
    data['userId'] = userId;
    return data;
  }
}
