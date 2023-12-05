class VerficationSendOTP {
  int? code;
  Data? data;
  int? timestamp;
  String? transactionId;

  VerficationSendOTP(
      {this.code, this.data, this.timestamp, this.transactionId});

  VerficationSendOTP.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = this.timestamp;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}

class Data {
  String? refId;
  String? message;

  Data({this.refId, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    refId = json['ref_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ref_id'] = this.refId;
    data['message'] = this.message;
    return data;
  }
}