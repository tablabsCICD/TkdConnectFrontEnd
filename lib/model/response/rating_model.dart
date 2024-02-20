import 'package:tkd_connect/model/response/userdata.dart';

class RatingModel {
  String? message;
  RatingData? data;
  bool? success;

  RatingModel({this.message, this.data, this.success});

  RatingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new RatingData.fromJson(json['data']) : null;
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

class RatingData {
  int? id;
  dynamic rating;
  String? review;
  CompanyId? companyId;
  UserData? userId;
  int? date;

  RatingData(
      {this.id,
        this.rating,
        this.review,
        this.companyId,
        this.userId,
        this.date});

  RatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    companyId = json['companyId'] != null
        ? new CompanyId.fromJson(json['companyId'])
        : null;
    userId =
    json['userId'] != null ? new UserData.fromJson(json['userId']) : null;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    if (this.companyId != null) {
      data['companyId'] = this.companyId!.toJson();
    }
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['date'] = this.date;
    return data;
  }
}

class CompanyId {
  int? id;
  String? companyName;
  String? companyAddress;
  int? isVerified;
  String? website;
  String? landlineNumber;
  String? companyMobileNumber;
  String? pointOfContact;
  String? gstNumber;
  String? gstNumber2;
  String? typeOfRegistration;
  String? panCardNumber;
  String? tanCardNumber;
  String? officialEmailId;
  double? rating;
  double? numberOfRatings;
  String? city;
  String? state;
  String? otp;
  bool? active;
  String? logo;

  CompanyId(
      {this.id,
        this.companyName,
        this.companyAddress,
        this.isVerified,
        this.website,
        this.landlineNumber,
        this.companyMobileNumber,
        this.pointOfContact,
        this.gstNumber,
        this.gstNumber2,
        this.typeOfRegistration,
        this.panCardNumber,
        this.tanCardNumber,
        this.officialEmailId,
        this.rating,
        this.numberOfRatings,
        this.city,
        this.state,
        this.otp,
        this.active,
        this.logo});

  CompanyId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    isVerified = json['isVerified'];
    website = json['website'];
    landlineNumber = json['landlineNumber'];
    companyMobileNumber = json['companyMobileNumber'];
    pointOfContact = json['pointOfContact'];
    gstNumber = json['gstNumber'];
    gstNumber2 = json['gstNumber2'];
    typeOfRegistration = json['typeOfRegistration'];
    panCardNumber = json['panCardNumber'];
    tanCardNumber = json['tanCardNumber'];
    officialEmailId = json['officialEmailId'];
    rating = json['rating'];
    numberOfRatings = json['numberOfRatings'];
    city = json['city'];
    state = json['state'];
    otp = json['otp'];
    active = json['active']??true;
    logo = json['logo']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['companyAddress'] = this.companyAddress;
    data['isVerified'] = this.isVerified;
    data['website'] = this.website;
    data['landlineNumber'] = this.landlineNumber;
    data['companyMobileNumber'] = this.companyMobileNumber;
    data['pointOfContact'] = this.pointOfContact;
    data['gstNumber'] = this.gstNumber;
    data['gstNumber2'] = this.gstNumber2;
    data['typeOfRegistration'] = this.typeOfRegistration;
    data['panCardNumber'] = this.panCardNumber;
    data['tanCardNumber'] = this.tanCardNumber;
    data['officialEmailId'] = this.officialEmailId;
    data['rating'] = this.rating;
    data['numberOfRatings'] = this.numberOfRatings;
    data['city'] = this.city;
    data['state'] = this.state;
    data['otp'] = this.otp;
    data['active'] = this.active;
    data['logo'] = this.logo;
    return data;
  }
}


