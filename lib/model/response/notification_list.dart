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
        data!.add(NotificationModel.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['type'] = type;
    data['title'] = title;
    data['message'] = message;
    data['deviceId'] = deviceId;
    data['featureName'] = featureName;
    data['dateAndTime'] = dateAndTime;
    data['isNotificationRead'] = isNotificationRead;
    data['tableId']==null?0:tableId;
    data['tableName']==null?'':tableName;
    return data;
  }
}
