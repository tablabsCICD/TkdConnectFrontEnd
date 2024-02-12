class PhonePayModel {
  String? message;
  Data? data;
  bool? success;

  PhonePayModel({this.message, this.data, this.success});

  PhonePayModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  int? id;
  String? uuid;
  int? date;
  Null? status;
  int? userId;
  Null? amount;

  Data({this.id, this.uuid, this.date, this.status, this.userId, this.amount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    date = json['date'];
    status = json['status'];
    userId = json['userId'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['date'] = this.date;
    data['status'] = this.status;
    data['userId'] = this.userId;
    data['amount'] = this.amount;
    return data;
  }
}
