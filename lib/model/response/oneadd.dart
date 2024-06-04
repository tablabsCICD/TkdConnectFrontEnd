class Advertisement {
  String? message;
  Data? data;
  bool? success;

  Advertisement({this.message, this.data, this.success});

  Advertisement.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
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
    data['mobileOrLandline'] = this.mobileOrLandline;

    data['category'] = this.category;
    data['title'] = this.title;
    data['mainTag'] = this.mainTag;
    data['images'] = this.images;
    data['type'] = this.type;
    return data;
  }
}
