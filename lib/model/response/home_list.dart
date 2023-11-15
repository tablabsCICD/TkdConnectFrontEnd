class HomeList {
  List<Content>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? size;
  int? number;
  String? sort;
  bool? first;
  int? numberOfElements;

  HomeList(
      {this.content,
        this.last,
        this.totalPages,
        this.totalElements,
        this.size,
        this.number,
        this.sort,
        this.first,
        this.numberOfElements});

  HomeList.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'];
    first = json['first'];
    numberOfElements = json['numberOfElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['size'] = this.size;
    data['number'] = this.number;
    data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    return data;
  }
}

class Content {
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
  String? ratings;
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
  int? isPaid;
  String? website;
  String? alterativeNumber;
  String? companyDetailsName;
  String? isVerifiedByCompany;
  String? typeOfPayment;
  String? typeName;
  List<String>? images;
  String? description;
  String? title;
  int? likes;
  String? comment;
  int? disLike;

  Content(
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
        this.images,
        this.description,
        this.title,
        this.likes,
        this.comment,
        this.disLike});

  Content.fromJson(Map<String, dynamic> json) {
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
    images = json['images'].cast<String>();
    description = json['description'];
    title = json['title'];
    likes = json['likes'];
    comment = json['comment'];
    disLike = json['disLike'];
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
    data['images'] = this.images;
    data['description'] = this.description;
    data['title'] = this.title;
    data['likes'] = this.likes;
    data['comment'] = this.comment;
    data['disLike'] = this.disLike;
    return data;
  }
}
