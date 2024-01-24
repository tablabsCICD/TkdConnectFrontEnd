class ChatList {
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
  int? rating;
  String? name1;
  String? name2;

  ChatList(
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
        this.name2});

  ChatList.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userId2'] = this.userId2;
    data['mobileNumber1'] = this.mobileNumber1;
    data['mobileNumber2'] = this.mobileNumber2;
    data['connectionKey'] = this.connectionKey;
    data['dateAndTime'] = this.dateAndTime;
    data['chat'] = this.chat;
    data['os'] = this.os;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedUserName2'] = this.loggedUserName2;
    data['loggedTime'] = this.loggedTime;
    data['rating'] = this.rating;
    data['name1'] = this.name1;
    data['name2'] = this.name2;
    return data;
  }
}
