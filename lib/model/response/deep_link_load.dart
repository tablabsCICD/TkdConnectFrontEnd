class TruckDeep {
  List<TruckLoadDeepLink>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  bool? first;
 
  int? numberOfElements;
  int? size;
  int? number;

  TruckDeep(
      {this.content,
        this.last,
        this.totalElements,
        this.totalPages,
        this.first,
      
        this.numberOfElements,
        this.size,
        this.number});

  TruckDeep.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <TruckLoadDeepLink>[];
      json['content'].forEach((v) {
        content!.add(TruckLoadDeepLink.fromJson(v));
      });
    }
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    first = json['first'];
  
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['last'] = last;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['first'] = first;
 
    data['numberOfElements'] = numberOfElements;
    data['size'] = size;
    data['number'] = number;
    return data;
  }
}

class TruckLoadDeepLink {
  int? id;
  String? fullLoadChoice;
  String? transporterOrCustomerName;
  int? contactNumber;
  String? emailId;
  String? source;
  String? destination;
  String? typeOfCargo;
  String? otherDetails;
  String? vehicleSize;
  String? loadWeight;
  String? instructions;
  int? partLoad;
  String? date;
  String? os;
  String? loggedUserName;
  int? loggedTime;
  int? privatePost;
  int? dnd;
  String? typeOfPayment;
  String? image;
  String? tableName;
  String? mainTag;
  String? postingTime;
  String? type;
  String? topicName;
  //String? rating;

  String? material;
  String? expireDate;
  String? transporterType;
  //String? userList;

  TruckLoadDeepLink(
      {this.id,
        this.fullLoadChoice,
        this.transporterOrCustomerName,
        this.contactNumber,
        this.emailId,
        this.source,
        this.destination,
        this.typeOfCargo,
        this.otherDetails,
        this.vehicleSize,
        this.loadWeight,
        this.instructions,
        this.partLoad,
        this.date,
        this.os,
        this.loggedUserName,
        this.loggedTime,
        this.privatePost,
        this.dnd,
        this.typeOfPayment,
        this.image,
        this.tableName,
        this.mainTag,
        this.postingTime,
        this.type,
        this.topicName,
       // this.rating,

        this.material,
        this.expireDate,
        this.transporterType,
});

  TruckLoadDeepLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullLoadChoice = json['fullLoadChoice'];
    transporterOrCustomerName = json['transporterOrCustomerName'];
    contactNumber = json['contactNumber'];
    emailId = json['emailId'];
    source = json['source'];
    destination = json['destination'];
    typeOfCargo = json['typeOfCargo'];
    otherDetails = json['otherDetails'];
    vehicleSize = json['vehicleSize'];
    loadWeight = json['loadWeight'];
    instructions = json['instructions'];
    partLoad = json['partLoad'];
    date = json['date'];
    os = json['os'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    privatePost = json['privatePost'];
    dnd = json['dnd'];
    typeOfPayment = json['typeOfPayment'];
    image = json['image'];
    tableName = json['tableName'];
    mainTag = json['mainTag'];
    postingTime = json['postingTime'];
    type = json['type'];
    topicName = json['topicName'];
    //rating = json['rating'];

    material = json['material'];
    expireDate = json['expireDate'];
    transporterType = json['transporterType'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullLoadChoice'] = fullLoadChoice;
    data['transporterOrCustomerName'] = transporterOrCustomerName;
    data['contactNumber'] = contactNumber;
    data['emailId'] = emailId;
    data['source'] = source;
    data['destination'] = destination;
    data['typeOfCargo'] = typeOfCargo;
    data['otherDetails'] = otherDetails;
    data['vehicleSize'] = vehicleSize;
    data['loadWeight'] = loadWeight;
    data['instructions'] = instructions;
    data['partLoad'] = partLoad;
    data['date'] = date;
    data['os'] = os;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    data['privatePost'] = privatePost;
    data['dnd'] = dnd;
    data['typeOfPayment'] = typeOfPayment;
    data['image'] = image;
    data['tableName'] = tableName;
    data['mainTag'] = mainTag;
    data['postingTime'] = postingTime;
    data['type'] = type;
    data['topicName'] = topicName;
   // data['rating'] = this.rating;

    data['material'] = material;
    data['expireDate'] = expireDate;
    data['transporterType'] = transporterType;

    return data;
  }
}
