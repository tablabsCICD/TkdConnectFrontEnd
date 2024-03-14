class NotificationListModel {
  List<NotificationModel>? data;
  String? message;
  bool? success;

  NotificationListModel({this.message, this.data, this.success});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationModel>[];
      json['data'].forEach((v) {
        data!.add(new NotificationModel.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class NotificationModel {
  int? id;
  int? userId;
  String? type;
  String? title;
  String? message;
  String? deviceId;
  String? featureName;
  String? dateAndTime;
  int? isNotificationRead;
  String? tableName;
  int? tableId;


  NotificationModel(
      {this.id,
        this.userId,
        this.type,
        this.title,
        this.message,
        this.deviceId,
        this.featureName,
        this.dateAndTime,
        this.isNotificationRead,
        this.tableName,
        this.tableId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    userId = json['userId']??0;
    type = json['type']??'';
    title = json['title']??'';
    message = json['message']??'';
    deviceId = json['deviceId']??'';
    featureName = json['featureName']??'';
    dateAndTime = json['dateAndTime']??'';
    isNotificationRead = json['isNotificationRead']??0;
    tableName = json['tableName']??'';
    tableId = json['tableId']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['message'] = this.message;
    data['deviceId'] = this.deviceId;
    data['featureName'] = this.featureName;
    data['dateAndTime'] = this.dateAndTime;
    data['isNotificationRead'] = this.isNotificationRead;
    data['tableId']==null?0:this.tableId;
    data['tableName']==null?'':this.tableName;
    return data;
  }
}
