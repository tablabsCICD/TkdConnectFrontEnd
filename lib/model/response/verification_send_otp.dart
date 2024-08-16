class VerficationSendOTP {
  int? code;
  Data? data;
  int? timestamp;
  String? transactionId;

  VerficationSendOTP(
      {this.code, this.data, this.timestamp, this.transactionId});

  VerficationSendOTP.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = timestamp;
    data['transaction_id'] = transactionId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ref_id'] = refId;
    data['message'] = message;
    return data;
  }
}