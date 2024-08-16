class VerifiedUser {
  String? message;
  List<UserVerifiedData>? data;
  bool? success;

  VerifiedUser({this.message, this.data, this.success});

  VerifiedUser.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <UserVerifiedData>[];
      json['data'].forEach((v) {
        data!.add(UserVerifiedData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class UserVerifiedData {
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
  String? aadharCardForVerification;
  String? panCardForVerification;
  String? branchName;
  bool? isSelected;
 bool? isAdded;

  UserVerifiedData(
      {this.id,
        this.isSelected,
        this.isAdded,
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
        this.isUserVerifiedByCompany,
        this.aadharCardForVerification,
        this.panCardForVerification,
        this.branchName});

  UserVerifiedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    mobileNumber = json['mobileNumber'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    landlineNumber = json['landlineNumber'];
    mainBranch = json['mainBranch'];
    idOfMainBranch = json['idOfMainBranch'];
    verified = json['verified'];
    companyLogo = json['companyLogo'];
    aadharCard = json['aadharCard'];
    otp = json['otp'];
    ratings = json['ratings'];
    numberOfTimesRating = json['numberOfTimesRating'];
    password = json['password'];
    deviceId = json['deviceId'];
    profilePicture = json['profilePicture'];
    os = json['os'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    transporterOrAgent = json['transporterOrAgent'];
    preferredRouresEntered = json['preferredRouresEntered'];
    isPaid = json['isPaid'];
    paidStartDate = json['paidStartDate'];
    validTill = json['validTill'];
    website = json['website'];
    alternativeNumber = json['alternativeNumber'];
    companyId = json['companyId'];
    isUserVerifiedByCompany = json['isUserVerifiedByCompany'];
    aadharCardForVerification = json['aadharCardForVerification'];
    panCardForVerification = json['panCardForVerification'];
    branchName = json['branchName'];
    isSelected=false;
    isAdded=false;
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
    data['aadharCardForVerification'] = aadharCardForVerification;
    data['panCardForVerification'] = panCardForVerification;
    data['branchName'] = branchName;
    return data;
  }
}
