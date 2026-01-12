

class BidPlaced {
  List<Bids>? content;
  bool? last;
  int? totalPages;
  int? totalElements;

  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  BidPlaced(
      {this.content,
        this.last,
        this.totalPages,
        this.totalElements,

        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  BidPlaced.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Bids>[];
      json['content'].forEach((v) {
        content!.add(Bids.fromJson(v));
      });
    }
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];

    first = json['first'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;

    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    data['size'] = size;
    data['number'] = number;
    return data;
  }
}

class Bids {
  int? id;
  int? userId;
  String? type;
  String? postingTime;
  String? companyName;
  String? nameOfPerson;
  String? companyRating;
  String? content;
  String? topicName;
  String? tableName;
  String? companyLogo;
  int? partLoadOrNot;
  String? reminderUserName;
  String? sharableLink;
  String? deviceId;
  double? ratings;
  int? mobileNumber;
  String? source;
  String? destination;
  String? mainTag;
  int? privatePost;
  String? amount;
  String? description;
  int? bidingId;
  int? isAccepted;
  int? acceptBidId;
  String? vehicleNumber;
  String? driverContact;
  int? ispostOwnerVerifiedForTrack;
  int? isQuoteOwnerVerifiedForTrack;
  int? isCompleted;

  Bids(
      {this.id,
        this.userId,
        this.type,
        this.postingTime,
        this.companyName,
        this.nameOfPerson,
        this.companyRating,
        this.content,
        this.topicName,
        this.tableName,
        this.companyLogo,
        this.partLoadOrNot,
        this.reminderUserName,
        this.sharableLink,
        this.deviceId,
        this.ratings,
        this.mobileNumber,
        this.source,
        this.destination,
        this.mainTag,
        this.privatePost,
        this.amount,
        this.description,
        this.bidingId,this.isAccepted,this.acceptBidId,this.driverContact,this.vehicleNumber,
        this.ispostOwnerVerifiedForTrack,this.isQuoteOwnerVerifiedForTrack,this.isCompleted});

  Bids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    type = json['type'];
    postingTime = json['postingTime'];
    companyName = json['companyName'];
    nameOfPerson = json['nameOfPerson'];
    companyRating = json['companyRating'];
    content = json['content'];
    topicName = json['topicName'];
    tableName = json['tableName'];
    companyLogo = json['companyLogo'];
    partLoadOrNot = json['partLoadOrNot'];
    reminderUserName = json['reminderUserName'];
    sharableLink = json['sharableLink'];
    deviceId = json['deviceId'];
    ratings = json['ratings'];
    mobileNumber = json['mobileNumber'];
    source = json['source'];
    destination = json['destination'];
    mainTag = json['mainTag'];
    privatePost = json['privatePost'];
    amount = json['amount'];
    description = json['description'];
    bidingId = json['bidingId'];
    isAccepted = json['isAccepted'];
    acceptBidId = json['acceptBidId'];
    driverContact=json['driverContact'];
    vehicleNumber=json['vehicleNumber'];
    ispostOwnerVerifiedForTrack = json['ispostOwnerVerifiedForTrack'] ?? 0;
    isQuoteOwnerVerifiedForTrack = json['isQuoteOwnerVerifiedForTrack'] ?? 0;
    isCompleted = json['isCompleted']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['type'] = type;
    data['postingTime'] = postingTime;
    data['companyName'] = companyName;
    data['nameOfPerson'] = nameOfPerson;
    data['companyRating'] = companyRating;
    data['content'] = content;
    data['topicName'] = topicName;
    data['tableName'] = tableName;
    data['companyLogo'] = companyLogo;
    data['partLoadOrNot'] = partLoadOrNot;
    data['reminderUserName'] = reminderUserName;
    data['sharableLink'] = sharableLink;
    data['deviceId'] = deviceId;
    data['ratings'] = ratings;
    data['mobileNumber'] = mobileNumber;
    data['source'] = source;
    data['destination'] = destination;
    data['mainTag'] = mainTag;
    data['privatePost'] = privatePost;
    data['amount'] = amount;
    data['description'] = description;
    data['bidingId'] = bidingId;
    data['isAccepted'] = isAccepted;
    data['acceptBidId'] = acceptBidId;
    data['vehicleNumber']= vehicleNumber;
    data['driverContact'] = driverContact;
    data['ispostOwnerVerifiedForTrack'] = ispostOwnerVerifiedForTrack;
    data['isQuoteOwnerVerifiedForTrack'] = isQuoteOwnerVerifiedForTrack;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
