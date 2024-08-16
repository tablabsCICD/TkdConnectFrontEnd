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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aadharCard'] = aadharCard;
    data['aadharCardForVerification'] = aadharCardForVerification;
    data['alternativeNumber'] = alternativeNumber;
    data['city'] = city;
    data['companyAddress'] = companyAddress;
    data['companyId'] = companyId;
    data['companyLogo'] = companyLogo;
    data['companyName'] = companyName;
    data['country'] = country;
    data['deviceId'] = deviceId;
    data['emailId'] = emailId;
    data['firstName'] = firstName;
    data['id'] = id;
    data['idOfMainBranch'] = idOfMainBranch;
    data['isPaid'] = isPaid;
    data['isUserVerifiedByCompany'] = isUserVerifiedByCompany;
    data['landlineNumber'] = landlineNumber;
    data['lastName'] = lastName;
    data['loggedTime'] = loggedTime;
    data['loggedUserName'] = loggedUserName;
    data['mainBranch'] = mainBranch;
    data['mobileNumber'] = mobileNumber;
    data['numberOfTimesRating'] = numberOfTimesRating;
    data['os'] = os;
    data['otp'] = otp;
    data['paidStartDate'] = paidStartDate;
    data['panCardForVerification'] = panCardForVerification;
    data['password'] = password;
    data['preferredRouresEntered'] = preferredRouresEntered;
    data['profilePicture'] = profilePicture;
    data['ratings'] = ratings;
    data['state'] = state;
    data['transporterOrAgent'] = transporterOrAgent;
    data['userName'] = userName;
    data['validTill'] = validTill;
    data['verified'] = verified;
    data['website'] = website;
    return data;
  }
}
