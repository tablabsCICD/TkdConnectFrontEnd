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
    this.images,
    this.transporterOrAgent,
    this.userList,
    this.mobileOrLandline,
    this.expireDate,
    this.repeatStartDate,
    this.repeatEndDate,
    this.isSharedInGroup,
    this.isOpenForBid,
    this.isRepeat,
    this.ispostOwnerVerifiedForTrack,this.isQuoteOwnerVerifiedForTrack,this.isCompleted,this.experience,this.department,
    this.vehicleRegistrationNumber,
    this.emailId
  });
  late final int? id;
  late final int? userId;
  late final String? type;
  late final String? postingTime;
  late final String? companyName;
  late final String? nameOfPerson;
  late final dynamic? companyRating;
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
  late final int? likes;
  late final  List<dynamic>? comment;
  late final List<dynamic>?postImages;
  late final List<dynamic>? images;
  late final int?transporterOrAgent;
  late final String? userList;
  late final String? mobileOrLandline;
  late final String? expireDate;
  late final int? repeatEndDate;
  late final int? repeatStartDate;
  late final int? isverified;
  late final bool? isSharedInGroup;
  late final int? isOpenForBid;
  late final int? isRepeat;
  int? ispostOwnerVerifiedForTrack;
  int? isQuoteOwnerVerifiedForTrack;
  int? isCompleted;
  late final String? experience;
  late final String? department;
  late final String? vehicleRegistrationNumber;
  late final String? emailId;

  TruckLoad.fromJson(Map<String, dynamic> json){
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    userId = json['userId'] is int ? json['userId'] : int.tryParse(json['userId']?.toString() ?? '0') ?? 0;
    type = json['type']?.toString() ?? '';
    postingTime = json['postingTime']?.toString() ?? '';
    companyName = json['companyName']?.toString() ?? '';
    nameOfPerson = json['nameOfPerson']?.toString() ?? '';
    companyRating = json['companyRating'] ?? 0.0;
    content = json['content']?.toString() ?? '';
    topicName = json['topicName']?.toString() ?? '';
    tableName = json['tableName']?.toString() ?? '';
    companyLogo = json['companyLogo']?.toString() ?? '';
    partLoadOrNot = json['partLoadOrNot'] is int ? json['partLoadOrNot'] : int.tryParse(json['partLoadOrNot']?.toString() ?? '0') ?? 0;
    reminderUserName = json['reminderUserName']?.toString() ?? '';
    sharableLink = json['sharableLink']?.toString() ?? '';
    deviceId = json['deviceId']?.toString() ?? '';
    ratings = json['ratings'] is num ? (json['ratings'] as num).toDouble() : double.tryParse(json['ratings']?.toString() ?? '0.0') ?? 0.0;
    mobileNumber = json['mobileNumber'] is int ? json['mobileNumber'] : int.tryParse(json['mobileNumber']?.toString() ?? '0') ?? 0;
    source = json['source']?.toString() ?? '';
    destination = json['destination']?.toString() ?? '';
    mainTag = json['mainTag']?.toString() ?? '';
    privatePost = json['privatePost'] is int ? json['privatePost'] : int.tryParse(json['privatePost']?.toString() ?? '0') ?? 0;
    makerName = json['makerName']?.toString() ?? '';
    modelName = json['modelName']?.toString() ?? '';
    mfgYear = json['mfgYear']?.toString() ?? '';
    estPrice = json['estPrice']?.toString() ?? '';
    dnd = json['dnd'] is int ? json['dnd'] : int.tryParse(json['dnd']?.toString() ?? '0') ?? 0;
    transporterOrAgent = json['transporterOrAgent'] is int ? json['transporterOrAgent'] : int.tryParse(json['transporterOrAgent']?.toString() ?? '0') ?? 0;

    vehicleSize = json['vehicleSize']?.toString() ?? '';
    association = json['association']?.toString() ?? '';
    isPaid = json['isPaid'] is int ? json['isPaid'] : int.tryParse(json['isPaid']?.toString() ?? '0') ?? 0;
    isverified = json['isverified'] is int ? json['isverified'] : int.tryParse(json['isverified']?.toString() ?? '0') ?? 0;

    website = json['website']?.toString() ?? '';

    alterativeNumber = json['alterativeNumber']?.toString() ?? '';
    companyDetailsName = json['companyDetailsName']?.toString() ?? '';
    isVerifiedByCompany = json['isVerifiedByCompany']?.toString() ?? '';
    typeOfPayment = json['typeOfPayment']?.toString() ?? '';
    fullLoadChoice = json['fullLoadChoice']?.toString() ?? '';
    loadWeight = json['vehicleWeight']?.toString() ?? '';
    typeOfCargo = json['cargoType']?.toString() ?? '';
    otherDetails = json['otherDetails']?.toString() ?? '';
    likes = json['likes'] is int ? json['likes'] : int.tryParse(json['likes']?.toString() ?? '0') ?? 0;
    comment = json['comment'] is List ? json['comment'] : [];
    postImages = _parseImages(json['postImages']);
    images = _parseImages(json['images']);
    userList = json['userList']?.toString() ?? '';
    expireDate = json['expireDate']?.toString() ?? '';
    repeatEndDate = json['repeatEndDate'] is int ? json['repeatEndDate'] : int.tryParse(json['repeatEndDate']?.toString() ?? '0') ?? 0;
    repeatStartDate = json['repeatStartDate'] is int ? json['repeatStartDate'] : int.tryParse(json['repeatStartDate']?.toString() ?? '0') ?? 0;
    mobileOrLandline = json['mobileOrLandline']?.toString() ?? '';
    isSharedInGroup = json['isSharedInGroup'] == true || json['isSharedInGroup'] == 1;
    isOpenForBid = json['isOpenForBid'] is int ? json['isOpenForBid'] : int.tryParse(json['isOpenForBid']?.toString() ?? '1') ?? 1;
    isRepeat = json['isRepeat'] is int ? json['isRepeat'] : int.tryParse(json['isRepeat']?.toString() ?? '0') ?? 0;
    ispostOwnerVerifiedForTrack = json['ispostOwnerVerifiedForTrack'] is int ? json['ispostOwnerVerifiedForTrack'] : int.tryParse(json['ispostOwnerVerifiedForTrack']?.toString() ?? '0') ?? 0;
    isQuoteOwnerVerifiedForTrack = json['isQuoteOwnerVerifiedForTrack'] is int ? json['isQuoteOwnerVerifiedForTrack'] : int.tryParse(json['isQuoteOwnerVerifiedForTrack']?.toString() ?? '0') ?? 0;
    isCompleted = json['isCompleted'] is int ? json['isCompleted'] : int.tryParse(json['isCompleted']?.toString() ?? '0') ?? 0;
    experience = json['experience']?.toString() ?? '';
    department = json['department']?.toString() ?? '';
    vehicleRegistrationNumber = json['vehicleRegistrationNumber']?.toString() ?? '';
    emailId = json["emailId"]?.toString() ?? '';
  }

  static List<dynamic> _parseImages(dynamic rawImages) {
    if (rawImages == null) return [];
    if (rawImages is List) {
      return rawImages.map((e) {
        if (e is Map) {
          return (e['url'] ?? e['imageUrl'] ?? e['image'] ?? e['filePath'] ?? e.toString()).toString();
        }
        return e?.toString() ?? '';
      }).where((s) => s.isNotEmpty).toList();
    }
    if (rawImages is String && rawImages.isNotEmpty) {
      return [rawImages];
    }
    return [];
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
    data['postImages'] = postImages;
    data['images'] = images;
    data['transporterOrAgent'] = transporterOrAgent;
    data['userList'] = userList;
    data['isverified'] = isverified;
    data['mobileOrLandline'] = mobileOrLandline;
    data['expireDate'] = expireDate;
    data['repeatEndDate'] = repeatEndDate;
    data['repeatStartDate'] = repeatStartDate;
    data['isSharedInGroup'] = isSharedInGroup;
    data['isOpenForBid'] = isOpenForBid;
    data['isRepeat']=isRepeat;
    data['ispostOwnerVerifiedForTrack'] = ispostOwnerVerifiedForTrack;
    data['isQuoteOwnerVerifiedForTrack'] = isQuoteOwnerVerifiedForTrack;
    data['isCompleted'] = isCompleted;
    data['experience'] = experience;
    data['department'] = department;
    data['vehicleRegistrationNumber'] = vehicleRegistrationNumber;
    data["emailId"]= emailId;
    return data;
  }
}
