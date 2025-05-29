class EditPostLoad {
  int? contactNumber;
  DateTime? date;
  String? destination;
  int? dnd;
  String? emailId;
  String? expireDate;
  String? fullLoadChoice;
  int? id;
  String? image;
  List<String>? images;
  String? instructions;
  int? isOpenForBid;
//  int? isRepeat;
  List<int>? listOfUserIds;
  String? loadWeight;
  DateTime? loggedTime;
  String? loggedUserName;
  String? mainTag;
  String? material;
  String? os;
  String? otherDetails;
  int? partLoad;
  String? postingTime;
  int? privatePost;
  int? rating;
 /* String? repeatEndDate;
  String? repeatStartDate;*/
  String? source;
  String? tableName;
  String? topicName;
  String? transporterOrCustomerName;
  String? transporterType;
  String? type;
  String? typeOfCargo;
  String? typeOfPayment;
  String? userList;
  String? vehicleSize;

  EditPostLoad({
    this.contactNumber,
    this.date,
    this.destination,
    this.dnd,
    this.emailId,
    this.expireDate,
    this.fullLoadChoice,
    this.id,
    this.image,
    this.images,
    this.instructions,
    this.isOpenForBid,
   // this.isRepeat,
    this.listOfUserIds,
    this.loadWeight,
    this.loggedTime,
    this.loggedUserName,
    this.mainTag,
    this.material,
    this.os,
    this.otherDetails,
    this.partLoad,
    this.postingTime,
    this.privatePost,
    this.rating,
   /* this.repeatEndDate,
    this.repeatStartDate,*/
    this.source,
    this.tableName,
    this.topicName,
    this.transporterOrCustomerName,
    this.transporterType,
    this.type,
    this.typeOfCargo,
    this.typeOfPayment,
    this.userList,
    this.vehicleSize,
  });

  factory EditPostLoad.fromJson(Map<String, dynamic> json) => EditPostLoad(
    contactNumber: json["contactNumber"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    destination: json["destination"],
    dnd: json["dnd"],
    emailId: json["emailId"],
    expireDate: json["expireDate"],
    fullLoadChoice: json["fullLoadChoice"],
    id: json["id"],
    image: json["image"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    instructions: json["instructions"],
    isOpenForBid: json["isOpenForBid"],
  //  isRepeat: json["isRepeat"],
    listOfUserIds: json["listOfUserIds"] == null ? [] : List<int>.from(json["listOfUserIds"]!.map((x) => x)),
    loadWeight: json["loadWeight"],
    loggedTime: json["loggedTime"] == null ? null : DateTime.parse(json["loggedTime"]),
    loggedUserName: json["loggedUserName"],
    mainTag: json["mainTag"],
    material: json["material"],
    os: json["os"],
    otherDetails: json["otherDetails"],
    partLoad: json["partLoad"],
    postingTime: json["postingTime"],
    privatePost: json["privatePost"],
    rating: json["rating"],
   /* repeatEndDate: json["repeatEndDate"] ,
    repeatStartDate: json["repeatStartDate"] ,*/
    source: json["source"],
    tableName: json["tableName"],
    topicName: json["topicName"],
    transporterOrCustomerName: json["transporterOrCustomerName"],
    transporterType: json["transporterType"],
    type: json["type"],
    typeOfCargo: json["typeOfCargo"],
    typeOfPayment: json["typeOfPayment"],
    userList: json["userList"],
    vehicleSize: json["vehicleSize"],
  );

  Map<String, dynamic> toJson() => {
    "contactNumber": contactNumber,
    "date": date?.toIso8601String(),
    "destination": destination,
    "dnd": dnd,
    "emailId": emailId,
    "expireDate": expireDate,
    "fullLoadChoice": fullLoadChoice,
    "id": id,
    "image": image,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "instructions": instructions,
    "isOpenForBid": isOpenForBid,
   // "isRepeat": isRepeat,
    "listOfUserIds": listOfUserIds == null ? [] : List<dynamic>.from(listOfUserIds!.map((x) => x)),
    "loadWeight": loadWeight,
    "loggedTime": loggedTime?.toIso8601String(),
    "loggedUserName": loggedUserName,
    "mainTag": mainTag,
    "material": material,
    "os": os,
    "otherDetails": otherDetails,
    "partLoad": partLoad,
    "postingTime": postingTime,
    "privatePost": privatePost,
    "rating": rating,
   /* "repeatEndDate": repeatEndDate,
    "repeatStartDate": repeatStartDate,*/
    "source": source,
    "tableName": tableName,
    "topicName": topicName,
    "transporterOrCustomerName": transporterOrCustomerName,
    "transporterType": transporterType,
    "type": type,
    "typeOfCargo": typeOfCargo,
    "typeOfPayment": typeOfPayment,
    "userList": userList,
    "vehicleSize": vehicleSize,
  };
}
