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
        data!.add(new UserVerifiedData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
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
    data['mainBranch'] = this.mainBranch;
    data['idOfMainBranch'] = this.idOfMainBranch;
    data['verified'] = this.verified;
    data['companyLogo'] = this.companyLogo;
    data['aadharCard'] = this.aadharCard;
    data['otp'] = this.otp;
    data['ratings'] = this.ratings;
    data['numberOfTimesRating'] = this.numberOfTimesRating;
    data['password'] = this.password;
    data['deviceId'] = this.deviceId;
    data['profilePicture'] = this.profilePicture;
    data['os'] = this.os;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    data['transporterOrAgent'] = this.transporterOrAgent;
    data['preferredRouresEntered'] = this.preferredRouresEntered;
    data['isPaid'] = this.isPaid;
    data['paidStartDate'] = this.paidStartDate;
    data['validTill'] = this.validTill;
    data['website'] = this.website;
    data['alternativeNumber'] = this.alternativeNumber;
    data['companyId'] = this.companyId;
    data['isUserVerifiedByCompany'] = this.isUserVerifiedByCompany;
    data['aadharCardForVerification'] = this.aadharCardForVerification;
    data['panCardForVerification'] = this.panCardForVerification;
    data['branchName'] = this.branchName;
    return data;
  }
}
