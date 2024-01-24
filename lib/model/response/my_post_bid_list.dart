import 'package:tkd_connect/generated/l10n.dart';

class MyPostBids {
  List<PostBidData>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  String? sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  MyPostBids(
      {this.content,
        this.last,
        this.totalPages,
        this.totalElements,
        this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  MyPostBids.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <PostBidData>[];
      json['content'].forEach((v) {
        content!.add(new PostBidData.fromJson(v));
      });
    }
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    sort = json['sort'];
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['size'] = this.size;
    data['number'] = this.number;
    return data;
  }
}

class PostBidData {
  GenericCardsDto? genericCardsDto;
  List<Bidings>? bidings;

  PostBidData({this.genericCardsDto, this.bidings});

  PostBidData.fromJson(Map<String, dynamic> json) {
    genericCardsDto = json['genericCardsDto'] != null
        ? new GenericCardsDto.fromJson(json['genericCardsDto'])
        : null;
    if (json['bidings'] != null) {
      bidings = <Bidings>[];
      json['bidings'].forEach((v) {
        bidings!.add(new Bidings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genericCardsDto != null) {
      data['genericCardsDto'] = this.genericCardsDto!.toJson();
    }
    if (this.bidings != null) {
      data['bidings'] = this.bidings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GenericCardsDto {
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
  String? makerName;
  String? modelName;
  String? mfgYear;
  String? estPrice;
  int? dnd;
  String? vehicleSize;
  String? association;
  String? isPaid;
  String? website;
  String? alterativeNumber;
  String? companyDetailsName;
  String? isVerifiedByCompany;
  String? typeOfPayment;
  String? typeName;

  String? description;
  String? title;
  String? likes;
  String? comment;
  String? cargoType;
  var vehicleWeight;

  GenericCardsDto(
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
        this.makerName,
        this.modelName,
        this.mfgYear,
        this.estPrice,
        this.dnd,
        this.vehicleSize,
        this.association,
        this.isPaid,
        this.website,
        this.alterativeNumber,
        this.companyDetailsName,
        this.isVerifiedByCompany,
        this.typeOfPayment,
        this.typeName,
        this.vehicleWeight,
        this.description,
        this.title,
        this.likes,
        this.cargoType,
        this.comment});

  GenericCardsDto.fromJson(Map<String, dynamic> json) {
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
    makerName = json['makerName'];
    modelName = json['modelName'];
    mfgYear = json['mfgYear'];
    estPrice = json['estPrice'];
    dnd = json['dnd'];
    vehicleSize = json['vehicleSize'];
    association = json['association'];
    isPaid = json['isPaid'];
    website = json['website'];
    alterativeNumber = json['alterativeNumber'];
    companyDetailsName = json['companyDetailsName'];
    isVerifiedByCompany = json['isVerifiedByCompany'];
    typeOfPayment = json['typeOfPayment'];
    typeName = json['typeName'];
    cargoType=json['cargoType'];
    description = json['description'];
    title = json['title'];
    likes = json['likes'];
    comment = json['comment'];
    vehicleWeight = json['vehicleWeight'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['postingTime'] = this.postingTime;
    data['companyName'] = this.companyName;
    data['nameOfPerson'] = this.nameOfPerson;
    data['companyRating'] = this.companyRating;
    data['content'] = this.content;
    data['topicName'] = this.topicName;
    data['tableName'] = this.tableName;
    data['companyLogo'] = this.companyLogo;
    data['partLoadOrNot'] = this.partLoadOrNot;
    data['reminderUserName'] = this.reminderUserName;
    data['sharableLink'] = this.sharableLink;
    data['deviceId'] = this.deviceId;
    data['ratings'] = this.ratings;
    data['mobileNumber'] = this.mobileNumber;
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['mainTag'] = this.mainTag;
    data['privatePost'] = this.privatePost;
    data['makerName'] = this.makerName;
    data['modelName'] = this.modelName;
    data['mfgYear'] = this.mfgYear;
    data['estPrice'] = this.estPrice;
    data['dnd'] = this.dnd;
    data['vehicleSize'] = this.vehicleSize;
    data['association'] = this.association;
    data['isPaid'] = this.isPaid;
    data['website'] = this.website;
    data['alterativeNumber'] = this.alterativeNumber;
    data['companyDetailsName'] = this.companyDetailsName;
    data['isVerifiedByCompany'] = this.isVerifiedByCompany;
    data['typeOfPayment'] = this.typeOfPayment;
    data['typeName'] = this.typeName;

    data['description'] = this.description;
    data['title'] = this.title;
    data['likes'] = this.likes;
    data['comment'] = this.comment;
    data['cargoType'] = this.cargoType;
    data['vehicleWeight'] = this.vehicleWeight;

    return data;
  }
}

class Bidings {
  BidingsDetails? bidings;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? companyName;
  int?    isVerified;
  int?    isPaid;

  Bidings(
      {this.bidings,
        this.firstName,
        this.lastName,
        this.profileImage,
        this.companyName,this.isVerified,this.isPaid});

  Bidings.fromJson(Map<String, dynamic> json) {
    bidings =
    json['bidings'] != null ? new BidingsDetails.fromJson(json['bidings']) : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    profileImage = json['profileImage'];
    companyName = json['companyName'];
    isVerified=json['isVerified'];
    isPaid=json['isPaid'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bidings != null) {
      data['bidings'] = this.bidings!.toJson();
    }
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profileImage'] = this.profileImage;
    data['companyName'] = this.companyName;
    data['isVerified'] = this.isVerified;
    data['isPaid'] = this.isPaid;

    return data;
  }
}

class BidingsDetails {
  int? id;
  String? emailId;
  String? userName;
  String? type;
  int? idOfPost;
  String? amount;
  String? description;
  String? bidderUserName;
  int? mobileNumber;
  String? loggedUserName;
  int? loggedTime;

  BidingsDetails(
      {this.id,
        this.emailId,
        this.userName,
        this.type,
        this.idOfPost,
        this.amount,
        this.description,
        this.bidderUserName,
        this.mobileNumber,
        this.loggedUserName,
        this.loggedTime});

  BidingsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailId = json['emailId'];
    userName = json['userName'];
    type = json['type'];
    idOfPost = json['idOfPost'];
    amount = json['amount'];
    description = json['description'];
    bidderUserName = json['bidderUserName'];
    mobileNumber = json['mobileNumber'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emailId'] = this.emailId;
    data['userName'] = this.userName;
    data['type'] = this.type;
    data['idOfPost'] = this.idOfPost;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['bidderUserName'] = this.bidderUserName;
    data['mobileNumber'] = this.mobileNumber;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    return data;
  }
}
