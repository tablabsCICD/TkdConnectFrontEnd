class RegisterCompany {
  String? aadharCard;
  String? aadharCardForVerification;
  String? alternativeNumber;
  String? city;
  String? companyAddress;
  int? companyId;
  String? companyLogo;
  String? companyName;
  String? country;
  String? deviceId;
  String? emailId;
  String? firstName;
  int? id;
  int? idOfMainBranch;
  int? isPaid;
  int? isUserVerifiedByCompany;
  int? landlineNumber;
  String? lastName;
  String? loggedTime;
  String? loggedUserName;
  int? mainBranch;
  String? mobileNumber;
  int? numberOfTimesRating;
  String? os;
  String? otp;
  String? paidStartDate;
  String? panCardForVerification;
  String? password;
  int? preferredRouresEntered;
  String? profilePicture;
  int? ratings;
  String? state;
  int? transporterOrAgent;
  String? userName;
  String? validTill;
  int? verified;
  String? website;

  RegisterCompany(
      {this.aadharCard,
        this.aadharCardForVerification,
        this.alternativeNumber,
        this.city,
        this.companyAddress,
        this.companyId,
        this.companyLogo,
        this.companyName,
        this.country,
        this.deviceId,
        this.emailId,
        this.firstName,
        this.id,
        this.idOfMainBranch,
        this.isPaid,
        this.isUserVerifiedByCompany,
        this.landlineNumber,
        this.lastName,
        this.loggedTime,
        this.loggedUserName,
        this.mainBranch,
        this.mobileNumber,
        this.numberOfTimesRating,
        this.os,
        this.otp,
        this.paidStartDate,
        this.panCardForVerification,
        this.password,
        this.preferredRouresEntered,
        this.profilePicture,
        this.ratings,
        this.state,
        this.transporterOrAgent,
        this.userName,
        this.validTill,
        this.verified,
        this.website});

  RegisterCompany.fromJson(Map<String, dynamic> json) {
    aadharCard = json['aadharCard'];
    aadharCardForVerification = json['aadharCardForVerification'];
    alternativeNumber = json['alternativeNumber'];
    city = json['city'];
    companyAddress = json['companyAddress'];
    companyId = json['companyId'];
    companyLogo = json['companyLogo'];
    companyName = json['companyName'];
    country = json['country'];
    deviceId = json['deviceId'];
    emailId = json['emailId'];
    firstName = json['firstName'];
    id = json['id'];
    idOfMainBranch = json['idOfMainBranch'];
    isPaid = json['isPaid'];
    isUserVerifiedByCompany = json['isUserVerifiedByCompany'];
    landlineNumber = json['landlineNumber'];
    lastName = json['lastName'];
    loggedTime = json['loggedTime'];
    loggedUserName = json['loggedUserName'];
    mainBranch = json['mainBranch'];
    mobileNumber = json['mobileNumber'];
    numberOfTimesRating = json['numberOfTimesRating'];
    os = json['os'];
    otp = json['otp'];
    paidStartDate = json['paidStartDate'];
    panCardForVerification = json['panCardForVerification'];
    password = json['password'];
    preferredRouresEntered = json['preferredRouresEntered'];
    profilePicture = json['profilePicture'];
    ratings = json['ratings'];
    state = json['state'];
    transporterOrAgent = json['transporterOrAgent'];
    userName = json['userName'];
    validTill = json['validTill'];
    verified = json['verified'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aadharCard'] = this.aadharCard;
    data['aadharCardForVerification'] = this.aadharCardForVerification;
    data['alternativeNumber'] = this.alternativeNumber;
    data['city'] = this.city;
    data['companyAddress'] = this.companyAddress;
    data['companyId'] = this.companyId;
    data['companyLogo'] = this.companyLogo;
    data['companyName'] = this.companyName;
    data['country'] = this.country;
    data['deviceId'] = this.deviceId;
    data['emailId'] = this.emailId;
    data['firstName'] = this.firstName;
    data['id'] = this.id;
    data['idOfMainBranch'] = this.idOfMainBranch;
    data['isPaid'] = this.isPaid;
    data['isUserVerifiedByCompany'] = this.isUserVerifiedByCompany;
    data['landlineNumber'] = this.landlineNumber;
    data['lastName'] = this.lastName;
    data['loggedTime'] = this.loggedTime;
    data['loggedUserName'] = this.loggedUserName;
    data['mainBranch'] = this.mainBranch;
    data['mobileNumber'] = this.mobileNumber;
    data['numberOfTimesRating'] = this.numberOfTimesRating;
    data['os'] = this.os;
    data['otp'] = this.otp;
    data['paidStartDate'] = this.paidStartDate;
    data['panCardForVerification'] = this.panCardForVerification;
    data['password'] = this.password;
    data['preferredRouresEntered'] = this.preferredRouresEntered;
    data['profilePicture'] = this.profilePicture;
    data['ratings'] = this.ratings;
    data['state'] = this.state;
    data['transporterOrAgent'] = this.transporterOrAgent;
    data['userName'] = this.userName;
    data['validTill'] = this.validTill;
    data['verified'] = this.verified;
    data['website'] = this.website;
    return data;
  }
}
