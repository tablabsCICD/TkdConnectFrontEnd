class ChatListDate {
  String? message;
  List<ChatData>? data;
  bool? success;

  ChatListDate({this.message, this.data, this.success});

  ChatListDate.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatData>[];
      json['data'].forEach((v) {
        data!.add(ChatData.fromJson(v));
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

class ChatData {
  int? id;
  int? userId;
  int? userId2;
  int? mobileNumber1;
  int? mobileNumber2;
  String? connectionKey;
  int? dateAndTime;
  String? chat;
  String? os;
  String? loggedUserName;
  String? loggedUserName2;
  int? loggedTime;
  double? rating;
  String? name1;
  String? name2;
  String? userProfile1;
  String? userProfile2;

  ChatData(
      {this.id,
        this.userId,
        this.userId2,
        this.mobileNumber1,
        this.mobileNumber2,
        this.connectionKey,
        this.dateAndTime,
        this.chat,
        this.os,
        this.loggedUserName,
        this.loggedUserName2,
        this.loggedTime,
        this.rating,
        this.name1,
        this.name2,
        this.userProfile1,
        this.userProfile2});

  ChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userId2 = json['userId2'];
    mobileNumber1 = json['mobileNumber1'];
    mobileNumber2 = json['mobileNumber2'];
    connectionKey = json['connectionKey'];
    dateAndTime = json['dateAndTime'];
    chat = json['chat'];
    os = json['os'];
    loggedUserName = json['loggedUserName'];
    loggedUserName2 = json['loggedUserName2'];
    loggedTime = json['loggedTime'];
    rating = json['rating'];
    name1 = json['name1'];
    name2 = json['name2'];
    userProfile1 = json['userProfile1'];
    userProfile2 = json['userProfile2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userId2'] = userId2;
    data['mobileNumber1'] = mobileNumber1;
    data['mobileNumber2'] = mobileNumber2;
    data['connectionKey'] = connectionKey;
    data['dateAndTime'] = dateAndTime;
    data['chat'] = chat;
    data['os'] = os;
    data['loggedUserName'] = loggedUserName;
    data['loggedUserName2'] = loggedUserName2;
    data['loggedTime'] = loggedTime;
    data['rating'] = rating;
    data['name1'] = name1;
    data['name2'] = name2;
    data['userProfile1'] = userProfile1;
    data['userProfile2'] = userProfile2;
    return data;
  }
}
