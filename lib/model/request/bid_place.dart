class BidPlace {
  String? amount;
  String? bidderUserName;
  String? description;
  String? emailId;
  int? id;
  int? idOfPost;
  String? loggedTime;
  String? loggedUserName;
  int? mobileNumber;
  String? type;
  String? userName;

  BidPlace(
      {this.amount,
        this.bidderUserName,
        this.description,
        this.emailId,
        this.id,
        this.idOfPost,
        this.loggedTime,
        this.loggedUserName,
        this.mobileNumber,
        this.type,
        this.userName});

  BidPlace.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    bidderUserName = json['bidderUserName'];
    description = json['description'];
    emailId = json['emailId'];
    id = json['id'];
    idOfPost = json['idOfPost'];
    loggedTime = json['loggedTime'];
    loggedUserName = json['loggedUserName'];
    mobileNumber = json['mobileNumber'];
    type = json['type'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['bidderUserName'] = bidderUserName;
    data['description'] = description;
    data['emailId'] = emailId;
    data['id'] = id;
    data['idOfPost'] = idOfPost;
    data['loggedTime'] = loggedTime;
    data['loggedUserName'] = loggedUserName;
    data['mobileNumber'] = mobileNumber;
    data['type'] = type;
    data['userName'] = userName;
    return data;
  }
}
