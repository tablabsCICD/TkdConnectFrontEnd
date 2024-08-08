import 'package:tkd_connect/model/request/post_load.dart';

class LoadPay {
  PostLoad? postLoad;
  RazorPayObject? razorPayObject;

  LoadPay({this.razorPayObject,this.postLoad});

  LoadPay.fromJson(Map<String, dynamic> json) {
    postLoad = json['fullTruckLoad'] != null
        ? new PostLoad.fromJson(json['fullTruckLoad'])
        : null;
    razorPayObject = json['razorPayObject'] != null
        ? new RazorPayObject.fromJson(json['razorPayObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postLoad != null) {
      data['fullTruckLoad'] = this.postLoad!.toJson();
    }
    if (this.razorPayObject != null) {
      data['razorPayObject'] = this.razorPayObject!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = this.plan;
    data['razorPayOrderId'] = this.razorPayOrderId;
    data['signature'] = this.signature;
    data['transactionId'] = this.transactionId;
    data['userId'] = this.userId;
    return data;
  }
}
