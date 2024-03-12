class TruckLoadType {
  TruckLoadType({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
    this.sort,
    required this.first,
    required this.numberOfElements,
  });
  late final List<TruckLoad> content;
  late final int totalElements;
  late final int totalPages;
  late final bool last;
  late final int size;
  late final int number;
  late final String? sort;
  late final bool first;
  late final int numberOfElements;

  TruckLoadType.fromJson(Map<String, dynamic> json){
    content = List.from(json['content']).map((e)=>TruckLoad.fromJson(e)).toList();
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = json['sort']?? '';
    first = json['first'];
    numberOfElements = json['numberOfElements'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content.map((e)=>e.toJson()).toList();
    _data['totalElements'] = totalElements;
    _data['totalPages'] = totalPages;
    _data['last'] = last;
    _data['size'] = size;
    _data['number'] = number;
    _data['sort'] = sort;
    _data['first'] = first;
    _data['numberOfElements'] = numberOfElements;
    return _data;
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
    this.userList
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
  late final dynamic? likes;
  late final dynamic? comment;
  late final List<dynamic>?postImages;
  late final int?transporterOrAgent;
  late final String? userList;




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
    comment=json['comment']??'';;
    postImages=json['images']??'';
    userList=json['userList']??'';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['type'] = type;
    _data['postingTime'] = postingTime;
    _data['companyName'] = companyName;
    _data['nameOfPerson'] = nameOfPerson;
    _data['companyRating'] = companyRating;
    _data['content'] = content;
    _data['topicName'] = topicName;
    _data['tableName'] = tableName;
    _data['companyLogo'] = companyLogo;
    _data['partLoadOrNot'] = partLoadOrNot;
    _data['reminderUserName'] = reminderUserName;
    _data['sharableLink'] = sharableLink;
    _data['deviceId'] = deviceId;
    _data['ratings'] = ratings;
    _data['mobileNumber'] = mobileNumber;
    _data['source'] = source;
    _data['destination'] = destination;
    _data['mainTag'] = mainTag;
    _data['privatePost'] = privatePost;
    _data['makerName'] = makerName;
    _data['modelName'] = modelName;
    _data['mfgYear'] = mfgYear;
    _data['estPrice'] = estPrice;
    _data['dnd'] = dnd;
    _data['vehicleSize'] = vehicleSize;
    _data['association'] = association;
    _data['isPaid'] = isPaid;
    _data['website'] = website;
    _data['alterativeNumber'] = alterativeNumber;
    _data['companyDetailsName'] = companyDetailsName;
    _data['isVerifiedByCompany'] = isVerifiedByCompany;
    _data['typeOfPayment'] = typeOfPayment;
    _data['fullLoadChoice'] = fullLoadChoice;
    _data['vehicleWeight'] = loadWeight;
    _data['cargoType'] = typeOfCargo;
    _data['otherDetails'] = otherDetails;
    _data['likes'] = likes;
    _data['comment'] = comment;
    _data['images'] = postImages;
    _data['transporterOrAgent'] = transporterOrAgent;
    _data['userList'] = userList;

    return _data;
  }
}
