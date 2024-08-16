class User {
  List<UserData>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  dynamic sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  User(
      {this.content,
        this.last,
        this.totalPages,
        this.totalElements,
        this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  User.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <UserData>[];
      json['content'].forEach((v) {
        content!.add(UserData.fromJson(v));
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

class UserData {
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
  int? mainBranch;
  int? idOfMainBranch;
  int? verified;
  String? companyLogo;
  String? aadharCard;
  String? otp;
  double? ratings;
  int? numberOfTimesRating;
  String? password;
  String? deviceId;
  String? profilePicture;
  String? os;
  String? loggedUserName;
  int? loggedTime;
  int? transporterOrAgent;
  int? preferredRouresEntered;
  int? isPaid;
  String? paidStartDate;
  String? validTill;
  String? website;
  String? alternativeNumber;
  int? companyId;
  int? isUserVerifiedByCompany;
  bool? isSelected;
  bool? addedIngroup;
  String? panCardForVerification;

  UserData(
      {this.addedIngroup,this.isSelected,this.id,
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
        this.mainBranch,
        this.idOfMainBranch,
        this.verified,
        this.companyLogo,
        this.aadharCard,
        this.otp,
        this.ratings,
        this.numberOfTimesRating,
        this.password,
        this.deviceId,
        this.profilePicture,
        this.os,
        this.loggedUserName,
        this.loggedTime,
        this.transporterOrAgent,
        this.preferredRouresEntered,
        this.isPaid,
        this.paidStartDate,
        this.validTill,
        this.website,
        this.alternativeNumber,
        this.companyId,
        this.isUserVerifiedByCompany});

  UserData.fromJson(Map<String, dynamic> json) {
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
    mainBranch = json['mainBranch']?? 0;
    idOfMainBranch = json['idOfMainBranch']?? 0;
    verified = json['verified']?? 0;
    companyLogo = json['companyLogo']?? '';
    aadharCard = json['aadharCard']?? '';
    otp = json['otp']?? '';
    ratings = json['ratings']?? 0.0;
    numberOfTimesRating = json['numberOfTimesRating']?? 0;
    password = json['password']?? '';
    deviceId = json['deviceId']?? '';
    profilePicture = json['profilePicture']?? '';
    os = json['os']?? '';
    loggedUserName = json['loggedUserName']?? '';
    loggedTime = json['loggedTime']?? 0;
    transporterOrAgent = json['transporterOrAgent']?? 0;
    preferredRouresEntered = json['preferredRouresEntered']?? 0;
    isPaid = json['isPaid']?? 0;
    paidStartDate = json['paidStartDate']?? '';
    validTill = json['validTill']?? '';
    website = json['website']?? '';
    alternativeNumber = json['alternativeNumber']?? '';
    companyId = json['companyId']?? 0;
    isUserVerifiedByCompany = json['isUserVerifiedByCompany']?? 0;
    isSelected=false;
    addedIngroup=false;
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
    data['mainBranch'] = mainBranch;
    data['idOfMainBranch'] = idOfMainBranch;
    data['verified'] = verified;
    data['companyLogo'] = companyLogo;
    data['aadharCard'] = aadharCard;
    data['otp'] = otp;
    data['ratings'] = ratings;
    data['numberOfTimesRating'] = numberOfTimesRating;
    data['password'] = password;
    data['deviceId'] = deviceId;
    data['profilePicture'] = profilePicture;
    data['os'] = os;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    data['transporterOrAgent'] = transporterOrAgent;
    data['preferredRouresEntered'] = preferredRouresEntered;
    data['isPaid'] = isPaid;
    data['paidStartDate'] = paidStartDate;
    data['validTill'] = validTill;
    data['website'] = website;
    data['alternativeNumber'] = alternativeNumber;
    data['companyId'] = companyId;
    data['isUserVerifiedByCompany'] = isUserVerifiedByCompany;
    return data;
  }
}
