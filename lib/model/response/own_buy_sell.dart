class OwnBuySelllPostList {
  String? message;
  List<OwnBuySellData>? data;
  bool? success;

  OwnBuySelllPostList({this.message, this.data, this.success});

  OwnBuySelllPostList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OwnBuySellData>[];
      json['data'].forEach((v) {
        data!.add(new OwnBuySellData.fromJson(v));
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

class OwnBuySellData {
  int? id;
  String? type;
  String? ownerName;
  String? agentName;
  int? contactNumber;
  String? city;
  String? maker;
  String? model;
  String? mfgYear;
  String? vehicleRegistrationNumber;
  String? yearOfBuying;
  String? conditionOfVehicle;
  String? conditionOfTyres;
  String? insaurancePaidUpto;
  int? estimatedPrice;
  int? negotiable;
  String? additionalInformation;
  String? bodyType;
  int? date;
  String? os;
  String? loggedUserName;
  int? loggedTime;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  int? privatePost;
  String? vehicleInfo;
  String? enginePower;
  String? documents;
  String? weight;
  String? driverType;
  String? transmission;
  int? userId;
  String? transporterType;
  String? tableName;
  String? mainTag;
  String? postingTime;
  String? buySelltype;
  String? topicName;

  OwnBuySellData(
      {this.id,
        this.type,
        this.ownerName,
        this.agentName,
        this.contactNumber,
        this.city,
        this.maker,
        this.model,
        this.mfgYear,
        this.vehicleRegistrationNumber,
        this.yearOfBuying,
        this.conditionOfVehicle,
        this.conditionOfTyres,
        this.insaurancePaidUpto,
        this.estimatedPrice,
        this.negotiable,
        this.additionalInformation,
        this.bodyType,
        this.date,
        this.os,
        this.loggedUserName,
        this.loggedTime,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.privatePost,
        this.vehicleInfo,
        this.enginePower,
        this.documents,
        this.weight,
        this.driverType,
        this.transmission,
        this.userId,
        this.transporterType,
        this.tableName,
        this.mainTag,
        this.postingTime,
        this.buySelltype,
        this.topicName});

  OwnBuySellData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    ownerName = json['ownerName'];
    agentName = json['agentName'];
    contactNumber = json['contactNumber'];
    city = json['city'];
    maker = json['maker'];
    model = json['model'];
    mfgYear = json['mfgYear'];
    vehicleRegistrationNumber = json['vehicleRegistrationNumber'];
    yearOfBuying = json['yearOfBuying'];
    conditionOfVehicle = json['conditionOfVehicle'];
    conditionOfTyres = json['conditionOfTyres'];
    insaurancePaidUpto = json['insaurancePaidUpto'];
    estimatedPrice = json['estimatedPrice'];
    negotiable = json['negotiable'];
    additionalInformation = json['additionalInformation'];
    bodyType = json['bodyType'];
    date = json['date'];
    os = json['os'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    privatePost = json['privatePost'];
    vehicleInfo = json['vehicleInfo'];
    enginePower = json['enginePower'];
    documents = json['documents'];
    weight = json['weight'];
    driverType = json['driverType'];
    transmission = json['transmission'];
    userId = json['userId'];
    transporterType = json['transporterType'];
    tableName = json['tableName'];
    mainTag = json['mainTag'];
    postingTime = json['postingTime'];
    buySelltype = json['buySelltype'];
    topicName = json['topicName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['ownerName'] = this.ownerName;
    data['agentName'] = this.agentName;
    data['contactNumber'] = this.contactNumber;
    data['city'] = this.city;
    data['maker'] = this.maker;
    data['model'] = this.model;
    data['mfgYear'] = this.mfgYear;
    data['vehicleRegistrationNumber'] = this.vehicleRegistrationNumber;
    data['yearOfBuying'] = this.yearOfBuying;
    data['conditionOfVehicle'] = this.conditionOfVehicle;
    data['conditionOfTyres'] = this.conditionOfTyres;
    data['insaurancePaidUpto'] = this.insaurancePaidUpto;
    data['estimatedPrice'] = this.estimatedPrice;
    data['negotiable'] = this.negotiable;
    data['additionalInformation'] = this.additionalInformation;
    data['bodyType'] = this.bodyType;
    data['date'] = this.date;
    data['os'] = this.os;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['privatePost'] = this.privatePost;
    data['vehicleInfo'] = this.vehicleInfo;
    data['enginePower'] = this.enginePower;
    data['documents'] = this.documents;
    data['weight'] = this.weight;
    data['driverType'] = this.driverType;
    data['transmission'] = this.transmission;
    data['userId'] = this.userId;
    data['transporterType'] = this.transporterType;
    data['tableName'] = this.tableName;
    data['mainTag'] = this.mainTag;
    data['postingTime'] = this.postingTime;
    data['buySelltype'] = this.buySelltype;
    data['topicName'] = this.topicName;
    return data;
  }
}
