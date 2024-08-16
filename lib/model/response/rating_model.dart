import 'package:tkd_connect/model/response/userdata.dart';

class RatingModel {
  String? message;
  RatingData? data;
  bool? success;

  RatingModel({this.message, this.data, this.success});

  RatingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? RatingData.fromJson(json['data']) : null;
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
        ? CompanyId.fromJson(json['companyId'])
        : null;
    userId =
    json['userId'] != null ? UserData.fromJson(json['userId']) : null;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['review'] = review;
    if (companyId != null) {
      data['companyId'] = companyId!.toJson();
    }
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['date'] = date;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    data['companyAddress'] = companyAddress;
    data['isVerified'] = isVerified;
    data['website'] = website;
    data['landlineNumber'] = landlineNumber;
    data['companyMobileNumber'] = companyMobileNumber;
    data['pointOfContact'] = pointOfContact;
    data['gstNumber'] = gstNumber;
    data['gstNumber2'] = gstNumber2;
    data['typeOfRegistration'] = typeOfRegistration;
    data['panCardNumber'] = panCardNumber;
    data['tanCardNumber'] = tanCardNumber;
    data['officialEmailId'] = officialEmailId;
    data['rating'] = rating;
    data['numberOfRatings'] = numberOfRatings;
    data['city'] = city;
    data['state'] = state;
    data['otp'] = otp;
    data['active'] = active;
    data['logo'] = logo;
    return data;
  }
}


