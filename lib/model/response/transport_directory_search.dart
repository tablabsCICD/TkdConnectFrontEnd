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
    content = List.from(json['content']).map((e)=>TransportSearchData.fromJson(e)).toList();
    totalPages = json['totalPages']?? 0;
    totalElements = json['totalElements']?? 0;
    last = json['last']?? false;
    size = json['size']?? 0;
    number = json['number']?? 0;
  //  sort = json['sort']?? '';
    first = json['first']?? false;
    numberOfElements = json['numberOfElements']?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] =
          this.content.map((e)=>e.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['last'] = this.last;
    data['size'] = this.size;
    data['number'] = this.number;
   // data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
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
        required this.listOfPreferredRoutes});

  TransportSearchData.fromJson(Map<String, dynamic> json) {
    id = json['id']?? 0;
    userName = json['userName']?? '';
    firstName = json['firstName']?? '';
    lastName = json['lastName']?? '';
    emailId = json['emailId']?? '';
    mobileNumber = json['mobileNumber']?? 0;
    companyName = json['companyName']?? '';
    companyAddress = json['companyAddress']?? '';
    city = json['city']?? '';
    state = json['state']?? '';
    country = json['country']?? '';
    landlineNumber = json['landlineNumber']?? 0;
    verified = json['verified']?? 0;
    companyLogo = json['companyLogo']?? '';
    aadharCard = json['aadharCard']?? '';
    ratings = json['ratings']?? 0.0;
    profilePicture = json['profilePicture']?? '';
    loggedUserName = json['loggedUserName']?? '';
    loggedTime = json['loggedTime']?? 0;
    transporterOrAgent = json['transporterOrAgent']?? 0;
    isPaid = json['isPaid']?? 0;
    paidStartDate = json['paidStartDate']?? '';
    validTill = json['validTill']?? '';
    website = json['website']?? '';
    type = json['type']?? '';
    mainTag = json['mainTag']?? '';
    title = json['title']?? '';

    images = json['images'].cast<String>();

    listOfPreferredRoutes = List.from(json['listOfPreferredRoutes']).map((e)=>ListOfPreferredRoutes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['mobileNumber'] = this.mobileNumber;
    data['companyName'] = this.companyName;
    data['companyAddress'] = this.companyAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['landlineNumber'] = this.landlineNumber;
    data['verified'] = this.verified;
    data['companyLogo'] = this.companyLogo;
    data['aadharCard'] = this.aadharCard;
    data['ratings'] = this.ratings;
    data['profilePicture'] = this.profilePicture;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    data['transporterOrAgent'] = this.transporterOrAgent;
    data['isPaid'] = this.isPaid;
    data['paidStartDate'] = this.paidStartDate;
    data['validTill'] = this.validTill;
    data['website'] = this.website;
    data['type'] = this.type;
    data['mainTag'] = this.mainTag;
    data['title'] = this.title;
    data['images'] = this.images;

    if (this.listOfPreferredRoutes != null) {
      data['listOfPreferredRoutes'] =
          this.listOfPreferredRoutes.map((e)=>e.toJson()).toList();
    }
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
    id = json['id']?? 0 ;
    userId = json['userId']?? 0;
    routeSource = json['routeSource']?? '';
    routeDestination = json['routeDestination']?? '';
    loggedUserName = json['loggedUserName']?? '';
    loggedTime = json['loggedTime']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['routeSource'] = this.routeSource;
    data['routeDestination'] = this.routeDestination;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    return data;
  }
}