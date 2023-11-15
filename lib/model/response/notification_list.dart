class NotificationListModel {
  List<NotificationModel>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? size;
  int? number;
  String? sort;
  int? numberOfElements;
  bool? first;

  NotificationListModel(
      {this.content,
        this.last,
        this.totalPages,
        this.totalElements,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = List.from(json['content']).map((e)=>NotificationModel.fromJson(e)).toList();
    }
    last = json['last'];
    totalPages = json['totalPages']??0;
    totalElements = json['totalElements']??0;
    size = json['size']??0;
    number = json['number']??0;
    sort = json['sort']??'';
    numberOfElements = json['numberOfElements']??0;
    first = json['first'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['size'] = this.size;
    data['number'] = this.number;
    data['sort'] = this.sort;
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
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
