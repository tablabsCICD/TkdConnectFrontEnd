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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['bidderUserName'] = this.bidderUserName;
    data['description'] = this.description;
    data['emailId'] = this.emailId;
    data['id'] = this.id;
    data['idOfPost'] = this.idOfPost;
    data['loggedTime'] = this.loggedTime;
    data['loggedUserName'] = this.loggedUserName;
    data['mobileNumber'] = this.mobileNumber;
    data['type'] = this.type;
    data['userName'] = this.userName;
    return data;
  }
}
