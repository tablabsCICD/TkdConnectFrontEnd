class Advertisement {
  String? message;
  Data? data;
  bool? success;

  Advertisement({this.message, this.data, this.success});

  Advertisement.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  int? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? emailId;
  String? mobileNumber;
  String? companyName;
  String? companyAddress;
  String? city;
  String? state;
  String? country;
  int? landlineNumber;
  String? verified;
  String? companyLogo;
  String? aadharCard;
  String? ratings;
  String? profilePicture;
  String? loggedUserName;
  String? loggedTime;
  String? transporterOrAgent;
  String? isPaid;
  String? paidStartDate;
  String? validTill;
  String? website;
  String? mobileOrLandline;

  String? category;
  String? title;
  String? mainTag;
  List<String>? images;
  String? type;

  Data(
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
        this.mobileOrLandline,

        this.category,
        this.title,
        this.mainTag,
        this.images,
        this.type});

  Data.fromJson(Map<String, dynamic> json) {
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
    verified = json['verified'];
    companyLogo = json['companyLogo'];
    aadharCard = json['aadharCard'];
    ratings = json['ratings'];
    profilePicture = json['profilePicture'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    transporterOrAgent = json['transporterOrAgent'];
    isPaid = json['isPaid'];
    paidStartDate = json['paidStartDate'];
    validTill = json['validTill'];
    website = json['website'];
    mobileOrLandline = json['mobileOrLandline'];

    category = json['category'];
    title = json['title'];
    mainTag = json['mainTag'];
    images = json['images'].cast<String>();
    type = json['type'];
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
    data['mobileOrLandline'] = mobileOrLandline;

    data['category'] = category;
    data['title'] = title;
    data['mainTag'] = mainTag;
    data['images'] = images;
    data['type'] = type;
    return data;
  }
}
