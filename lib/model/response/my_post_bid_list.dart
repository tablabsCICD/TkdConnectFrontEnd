

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
        content!.add(PostBidData.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['sort'] = sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    data['size'] = size;
    data['number'] = number;
    return data;
  }
}

class PostBidData {
  GenericCardsDto? genericCardsDto;
  List<Bidings>? bidings;

  PostBidData({this.genericCardsDto, this.bidings});

  PostBidData.fromJson(Map<String, dynamic> json) {
    genericCardsDto = json['genericCardsDto'] != null
        ? GenericCardsDto.fromJson(json['genericCardsDto'])
        : null;
    if (json['bidings'] != null) {
      bidings = <Bidings>[];
      json['bidings'].forEach((v) {
        bidings!.add(Bidings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (genericCardsDto != null) {
      data['genericCardsDto'] = genericCardsDto!.toJson();
    }
    if (bidings != null) {
      data['bidings'] = bidings!.map((v) => v.toJson()).toList();
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
  String? userList;
  var vehicleWeight;
  String? expireDate;
  bool showCharts = false;
  int? isOpenForBid;

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
        this.userList,
        this.comment,this.expireDate,this.showCharts = false,this.isOpenForBid});

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
    userList = json['userList']??'';
    expireDate = json['expireDate']??'';
    showCharts = json['showCharts'] ?? false;
    isOpenForBid = json['isOpenForBid'] ?? 1;
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

    data['description'] = description;
    data['title'] = title;
    data['likes'] = likes;
    data['comment'] = comment;
    data['cargoType'] = cargoType;
    data['vehicleWeight'] = vehicleWeight;
    data['userList'] = userList;
    data['expireDate'] = expireDate;
    data['showCharts'] = showCharts;
    data['isOpenForBid'] = isOpenForBid;
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
    json['bidings'] != null ? BidingsDetails.fromJson(json['bidings']) : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    profileImage = json['profileImage'];
    companyName = json['companyName'];
    isVerified=json['isVerified'];
    isPaid=json['isPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bidings != null) {
      data['bidings'] = bidings!.toJson();
    }
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['profileImage'] = profileImage;
    data['companyName'] = companyName;
    data['isVerified'] = isVerified;
    data['isPaid'] = isPaid;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emailId'] = emailId;
    data['userName'] = userName;
    data['type'] = type;
    data['idOfPost'] = idOfPost;
    data['amount'] = amount;
    data['description'] = description;
    data['bidderUserName'] = bidderUserName;
    data['mobileNumber'] = mobileNumber;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    return data;
  }
}
