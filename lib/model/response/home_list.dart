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
        content!.add(Content.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['size'] = size;
    data['number'] = number;
    data['sort'] = sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
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
    data['makerName'] = makerName;
    data['modelName'] = modelName;
    data['mfgYear'] = mfgYear;
    data['estPrice'] = estPrice;
    data['dnd'] = dnd;
    data['vehicleSize'] = vehicleSize;
    data['association'] = association;
    data['isPaid'] = isPaid;
    data['website'] = website;
    data['alterativeNumber'] = alterativeNumber;
    data['companyDetailsName'] = companyDetailsName;
    data['isVerifiedByCompany'] = isVerifiedByCompany;
    data['typeOfPayment'] = typeOfPayment;
    data['typeName'] = typeName;
    data['images'] = images;
    data['description'] = description;
    data['title'] = title;
    data['likes'] = likes;
    data['comment'] = comment;
    data['disLike'] = disLike;
    return data;
  }
}
