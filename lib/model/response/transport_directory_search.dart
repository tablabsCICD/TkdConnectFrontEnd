class TransportSearchModel {
  late final List<TransportSearchData> content;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;

  //String? sort;
  bool? first;
  int? numberOfElements;

  TransportSearchModel(
      {required this.content,
      this.totalPages,
      this.totalElements,
      this.last,
      this.size,
      this.number,
      //  this.sort,
      this.first,
      this.numberOfElements});

  TransportSearchModel.fromJson(Map<String, dynamic> json) {
    content = List.from(json['content'])
        .map((e) => TransportSearchData.fromJson(e))
        .toList();
    totalPages = json['totalPages'] ?? 0;
    totalElements = json['totalElements'] ?? 0;
    last = json['last'] ?? false;
    size = json['size'] ?? 0;
    number = json['number'] ?? 0;
    //  sort = json['sort']?? '';
    first = json['first'] ?? false;
    numberOfElements = json['numberOfElements'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content.map((e) => e.toJson()).toList();
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['last'] = last;
    data['size'] = size;
    data['number'] = number;
    // data['sort'] = this.sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    return data;
  }
}

class TransportSearchData {
  int? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? emailId;
  int? mobileNumber;
  String? companyName;
  String? companyAddress;
  String? city;
  String? state;
  String? country;
  int? landlineNumber;
  int? verified;
  String? companyLogo;
  String? aadharCard;
  double? ratings;
  String? profilePicture;
  String? loggedUserName;
  int? loggedTime;
  int? transporterOrAgent;
  int? isPaid;
  String? paidStartDate;
  String? validTill;
  String? website;
  String? type;
  String? mainTag;
  String? title;
  String? mobileOrLandline;

  List<String>? images;

  late final List<ListOfPreferredRoutes> listOfPreferredRoutes;

  TransportSearchData(
      {this.id,
      this.userName,
      this.firstName,
      this.lastName,
      this.emailId,
      this.mobileNumber,
      this.companyName,
      this.companyAddress,
      this.city,
      this.state,
      this.country,
      this.landlineNumber,
      this.verified,
      this.companyLogo,
      this.aadharCard,
      this.ratings,
      this.profilePicture,
      this.loggedUserName,
      this.loggedTime,
      this.transporterOrAgent,
      this.isPaid,
      this.paidStartDate,
      this.validTill,
      this.website,
      this.type,
      this.mainTag,
      this.title,
      this.images,
      this.mobileOrLandline,
      required this.listOfPreferredRoutes});

  TransportSearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userName = json['userName'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    emailId = json['emailId'] ?? '';
    mobileNumber = json['mobileNumber'] ?? 0;
    companyName = json['companyName'] ?? '';
    companyAddress = json['companyAddress'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    country = json['country'] ?? '';
    landlineNumber = json['landlineNumber'] ?? 0;
    verified = json['verified'] ?? 0;
    companyLogo = json['companyLogo'] ?? '';
    aadharCard = json['aadharCard'] ?? '';
    ratings = json['ratings'] ?? 0.0;
    profilePicture = json['profilePicture'] ?? '';
    loggedUserName = json['loggedUserName'] ?? '';
    loggedTime = json['loggedTime'] ?? 0;
    transporterOrAgent = json['transporterOrAgent'] ?? 0;
    isPaid = json['isPaid'] ?? 0;
    paidStartDate = json['paidStartDate'] ?? '';
    validTill = json['validTill'] ?? '';
    website = json['website'] ?? '';
    type = json['type'] ?? '';
    mainTag = json['mainTag'] ?? '';
    title = json['title'] ?? '';
    mobileOrLandline = json['mobileOrLandline'] ?? '';

    images = json['images'].cast<String>();

    listOfPreferredRoutes = List.from(json['listOfPreferredRoutes'])
        .map((e) => ListOfPreferredRoutes.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['emailId'] = emailId;
    data['mobileNumber'] = mobileNumber;
    data['companyName'] = companyName;
    data['companyAddress'] = companyAddress;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['landlineNumber'] = landlineNumber;
    data['verified'] = verified;
    data['companyLogo'] = companyLogo;
    data['aadharCard'] = aadharCard;
    data['ratings'] = ratings;
    data['profilePicture'] = profilePicture;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    data['transporterOrAgent'] = transporterOrAgent;
    data['isPaid'] = isPaid;
    data['paidStartDate'] = paidStartDate;
    data['validTill'] = validTill;
    data['website'] = website;
    data['type'] = type;
    data['mainTag'] = mainTag;
    data['title'] = title;
    data['images'] = images;
    data['mobileOrLandline'] = mobileOrLandline;

    data['listOfPreferredRoutes'] =
        listOfPreferredRoutes.map((e) => e.toJson()).toList();
    return data;
  }
}

class ListOfPreferredRoutes {
  int? id;
  int? userId;
  String? routeSource;
  String? routeDestination;
  String? loggedUserName;
  String? loggedTime;

  ListOfPreferredRoutes(
      {this.id,
      this.userId,
      this.routeSource,
      this.routeDestination,
      this.loggedUserName,
      this.loggedTime});

  ListOfPreferredRoutes.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['userId'] ?? 0;
    routeSource = json['routeSource'] ?? '';
    routeDestination = json['routeDestination'] ?? '';
    loggedUserName = json['loggedUserName'] ?? '';
    loggedTime = json['loggedTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['routeSource'] = routeSource;
    data['routeDestination'] = routeDestination;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    return data;
  }
}
