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
        data!.add(OwnBuySellData.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['ownerName'] = ownerName;
    data['agentName'] = agentName;
    data['contactNumber'] = contactNumber;
    data['city'] = city;
    data['maker'] = maker;
    data['model'] = model;
    data['mfgYear'] = mfgYear;
    data['vehicleRegistrationNumber'] = vehicleRegistrationNumber;
    data['yearOfBuying'] = yearOfBuying;
    data['conditionOfVehicle'] = conditionOfVehicle;
    data['conditionOfTyres'] = conditionOfTyres;
    data['insaurancePaidUpto'] = insaurancePaidUpto;
    data['estimatedPrice'] = estimatedPrice;
    data['negotiable'] = negotiable;
    data['additionalInformation'] = additionalInformation;
    data['bodyType'] = bodyType;
    data['date'] = date;
    data['os'] = os;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    data['image1'] = image1;
    data['image2'] = image2;
    data['image3'] = image3;
    data['image4'] = image4;
    data['privatePost'] = privatePost;
    data['vehicleInfo'] = vehicleInfo;
    data['enginePower'] = enginePower;
    data['documents'] = documents;
    data['weight'] = weight;
    data['driverType'] = driverType;
    data['transmission'] = transmission;
    data['userId'] = userId;
    data['transporterType'] = transporterType;
    data['tableName'] = tableName;
    data['mainTag'] = mainTag;
    data['postingTime'] = postingTime;
    data['buySelltype'] = buySelltype;
    data['topicName'] = topicName;
    return data;
  }
}
