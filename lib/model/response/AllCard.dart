class TruckLoadType {
  TruckLoadType({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
  //  this.sort,
    required this.first,
    required this.numberOfElements,
  });
  late final List<TruckLoad> content;
  late final int totalElements;
  late final int totalPages;
  late final bool last;
  late final int size;
  late final int number;
 // late final String? sort;
  late final bool first;
  late final int numberOfElements;

  TruckLoadType.fromJson(Map<String, dynamic> json){
    content = List.from(json['content']).map((e)=>TruckLoad.fromJson(e)).toList();
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    //sort = json['sort']?? '';
    first = json['first'];
    numberOfElements = json['numberOfElements'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['content'] = content.map((e)=>e.toJson()).toList();
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['last'] = last;
    data['size'] = size;
    data['number'] = number;
   // _data['sort'] = sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    return data;
  }
}

class TruckLoad {
  TruckLoad({
    required this.id,
    required this.userId,
    required this.type,
    required this.postingTime,
    required this.companyName,
    required this.nameOfPerson,
    this.companyRating,
    required this.content,
    required this.topicName,
    required this.tableName,
    this.companyLogo,
    required this.partLoadOrNot,
    this.reminderUserName,
    required this.sharableLink,
    required this.deviceId,
    required this.ratings,
    required this.mobileNumber,
    required this.source,
    required this.destination,
    required this.mainTag,
    required this.privatePost,
    this.makerName,
    this.modelName,
    this.mfgYear,
    this.estPrice,
    required this.dnd,
    required this.vehicleSize,
    required this.association,
    required this.isPaid,
    required this.website,
    this.alterativeNumber,
    required this.companyDetailsName,
    this.isVerifiedByCompany,
    this.typeOfPayment,
    this.fullLoadChoice,
    this.loadWeight,
    this.typeOfCargo,
    this.otherDetails,
    this.comment,
    this.likes,
    this.postImages,
    this.transporterOrAgent,
    this.userList,
    this.mobileOrLandline,
    this.expireDate,
    this.isSharedInGroup,
    this.isOpenForBid
  });
  late final int? id;
  late final int? userId;
  late final String? type;
  late final String? postingTime;
  late final String? companyName;
  late final String? nameOfPerson;
  late final String? companyRating;
  late final String? content;
  late final String? topicName;
  late final String? tableName;
  late final String? companyLogo;
  late final int? partLoadOrNot;
  late final String? reminderUserName;
  late final String? sharableLink;
  late final String? deviceId;
  late final double? ratings;
  late final int? mobileNumber;
  late final String? source;
  late final String? destination;
  late final String? mainTag;
  late final int? privatePost;
  late final String? makerName;
  late final String? modelName;
  late final String? mfgYear;
  late final String? estPrice;
  late final int? dnd;
  late final String? vehicleSize;
  late final String? association;
  late final int? isPaid;
  late final String? website;
  late final String? alterativeNumber;
  late final String? companyDetailsName;
  late final String? isVerifiedByCompany;
  late final String? typeOfPayment;
  late final String? fullLoadChoice;
  late final String? loadWeight;
  late final String? typeOfCargo;
  late final String? otherDetails;
  late final dynamic likes;
  late final dynamic comment;
  late final List<dynamic>?postImages;
  late final int?transporterOrAgent;
  late final String? userList;
  late final String? mobileOrLandline;
  late final String? expireDate;

  late final int? isverified;
  late final bool? isSharedInGroup;
  late final int? isOpenForBid;





  TruckLoad.fromJson(Map<String, dynamic> json){
    id = json['id']?? 0;
    userId = json['userId']?? 0;
    type = json['type']?? '';
    postingTime = json['postingTime']?? '';
    companyName = json['companyName']?? '';
    nameOfPerson = json['nameOfPerson']?? '';
    companyRating = json['companyRating']?? '';
    content = json['content']?? '';
    topicName = json['topicName']?? '';
    tableName = json['tableName']?? '';
    companyLogo = json['companyLogo']?? '';
    partLoadOrNot = json['partLoadOrNot']?? 0;
    reminderUserName = json['reminderUserName']?? '';
    sharableLink = json['sharableLink']?? '';
    deviceId = json['deviceId']?? '';
    ratings = json['ratings']?? 0.0;
    mobileNumber = json['mobileNumber']?? 0;
    source = json['source']?? '';
    destination = json['destination']?? '';
    mainTag = json['mainTag']?? '';
    privatePost = json['privatePost']?? 0;
    makerName = json['makerName']?? '';
    modelName = json['modelName']?? '';
    mfgYear = json['mfgYear']?? '';
    estPrice = json['estPrice']?? '';
    dnd = json['dnd']?? 0;
    transporterOrAgent = json['transporterOrAgent']?? 0;

    vehicleSize = json['vehicleSize']?? '';
    association = json['association']?? '';
    isPaid = json['isPaid']?? 0;
    isverified = json['isverified']?? 0;

    website = json['website']?? '';

    alterativeNumber = json['alterativeNumber']?? '';
    companyDetailsName = json['companyDetailsName']?? '';
    isVerifiedByCompany = json['isVerifiedByCompany']?? '';
    typeOfPayment = json['typeOfPayment']?? '';
    fullLoadChoice = json['fullLoadChoice']?? '';
    loadWeight = json['vehicleWeight']?? '';
    typeOfCargo = json['cargoType']?? '';
    otherDetails = json['otherDetails']?? '';
    likes=json['likes']??'';
    comment=json['comment']??'';
    postImages=json['images']??'';
    userList=json['userList']??'';
    expireDate=json['expireDate']??'';

    mobileOrLandline=json['mobileOrLandline']??'';
    isSharedInGroup=json['isSharedInGroup']??false;
    isOpenForBid=json['isOpenForBid']??1;

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
    data['fullLoadChoice'] = fullLoadChoice;
    data['vehicleWeight'] = loadWeight;
    data['cargoType'] = typeOfCargo;
    data['otherDetails'] = otherDetails;
    data['likes'] = likes;
    data['comment'] = comment;
    data['images'] = postImages;
    data['transporterOrAgent'] = transporterOrAgent;
    data['userList'] = userList;
    data['isverified'] = isverified;
    data['mobileOrLandline'] = mobileOrLandline;
    data['expireDate'] = expireDate;
    data['isSharedInGroup'] = isSharedInGroup;
    data['isOpenForBid'] = isOpenForBid;


    return data;
  }
}
