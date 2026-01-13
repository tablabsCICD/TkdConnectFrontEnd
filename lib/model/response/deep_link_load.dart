class TruckDeep {
  List<Content>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? numberOfElements;
  bool? first;
  dynamic sort;
  int? size;
  int? number;

  TruckDeep({
    this.content,
    this.last,
    this.totalPages,
    this.totalElements,
    this.numberOfElements,
    this.first,
    this.sort,
    this.size,
    this.number,
  });

  factory TruckDeep.fromJson(Map<String, dynamic> json) => TruckDeep(
    content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
    last: json["last"],
    totalPages: json["totalPages"],
    totalElements: json["totalElements"],
    numberOfElements: json["numberOfElements"],
    first: json["first"],
    sort: json["sort"],
    size: json["size"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
    "last": last,
    "totalPages": totalPages,
    "totalElements": totalElements,
    "numberOfElements": numberOfElements,
    "first": first,
    "sort": sort,
    "size": size,
    "number": number,
  };
}

class Content {
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
  dynamic date;
  String? os;
  String? loggedUserName;
  int? loggedTime;
  int? privatePost;
  int? dnd;
  String? typeOfPayment;
  dynamic image;
  int? isOpenForBid;
  String? tableName;
  String? mainTag;
  DateTime? postingTime;
  String? type;
  String? topicName;
  double? rating;
  List<dynamic>? listOfUserIds;
  List<dynamic>? images;
  dynamic material;
  DateTime? expireDate;
  dynamic transporterType;
  dynamic userList;
  dynamic isRepeat;
  dynamic repeatStartDate;
  dynamic repeatEndDate;
  dynamic ispostOwnerVerifiedForTrack;
  dynamic isQuoteOwnerVerifiedForTrack;
  dynamic isCompleted;

  Content({
    this.id,
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
    this.isOpenForBid,
    this.tableName,
    this.mainTag,
    this.postingTime,
    this.type,
    this.topicName,
    this.rating,
    this.listOfUserIds,
    this.images,
    this.material,
    this.expireDate,
    this.transporterType,
    this.userList,
    this.isRepeat,
    this.repeatStartDate,
    this.repeatEndDate,
    this.ispostOwnerVerifiedForTrack,
    this.isQuoteOwnerVerifiedForTrack,
    this.isCompleted,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    fullLoadChoice: json["fullLoadChoice"],
    transporterOrCustomerName: json["transporterOrCustomerName"],
    contactNumber: json["contactNumber"],
    emailId: json["emailId"],
    source: json["source"],
    destination: json["destination"],
    typeOfCargo: json["typeOfCargo"],
    otherDetails: json["otherDetails"],
    vehicleSize: json["vehicleSize"],
    loadWeight: json["loadWeight"],
    instructions: json["instructions"],
    partLoad: json["partLoad"],
    date: json["date"],
    os: json["os"],
    loggedUserName: json["loggedUserName"],
    loggedTime: json["loggedTime"],
    privatePost: json["privatePost"],
    dnd: json["dnd"],
    typeOfPayment: json["typeOfPayment"],
    image: json["image"],
    isOpenForBid: json["isOpenForBid"],
    tableName: json["tableName"],
    mainTag: json["mainTag"],
    postingTime: json["postingTime"] == null ? null : DateTime.parse(json["postingTime"]),
    type: json["type"],
    topicName: json["topicName"],
    rating: json["rating"],
    listOfUserIds: json["listOfUserIds"] == null ? [] : List<dynamic>.from(json["listOfUserIds"]!.map((x) => x)),
    images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
    material: json["material"],
    expireDate: json["expireDate"] == null ? null : DateTime.parse(json["expireDate"]),
    transporterType: json["transporterType"],
    userList: json["userList"],
    isRepeat: json["isRepeat"],
    repeatStartDate: json["repeatStartDate"],
    repeatEndDate: json["repeatEndDate"],
    ispostOwnerVerifiedForTrack: json["ispostOwnerVerifiedForTrack"],
    isQuoteOwnerVerifiedForTrack: json["isQuoteOwnerVerifiedForTrack"],
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullLoadChoice": fullLoadChoice,
    "transporterOrCustomerName": transporterOrCustomerName,
    "contactNumber": contactNumber,
    "emailId": emailId,
    "source": source,
    "destination": destination,
    "typeOfCargo": typeOfCargo,
    "otherDetails": otherDetails,
    "vehicleSize": vehicleSize,
    "loadWeight": loadWeight,
    "instructions": instructions,
    "partLoad": partLoad,
    "date": date,
    "os": os,
    "loggedUserName": loggedUserName,
    "loggedTime": loggedTime,
    "privatePost": privatePost,
    "dnd": dnd,
    "typeOfPayment": typeOfPayment,
    "image": image,
    "isOpenForBid": isOpenForBid,
    "tableName": tableName,
    "mainTag": mainTag,
    "postingTime": postingTime?.toIso8601String(),
    "type": type,
    "topicName": topicName,
    "rating": rating,
    "listOfUserIds": listOfUserIds == null ? [] : List<dynamic>.from(listOfUserIds!.map((x) => x)),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "material": material,
    "expireDate": "${expireDate!.year.toString().padLeft(4, '0')}-${expireDate!.month.toString().padLeft(2, '0')}-${expireDate!.day.toString().padLeft(2, '0')}",
    "transporterType": transporterType,
    "userList": userList,
    "isRepeat": isRepeat,
    "repeatStartDate": repeatStartDate,
    "repeatEndDate": repeatEndDate,
    "ispostOwnerVerifiedForTrack": ispostOwnerVerifiedForTrack,
    "isQuoteOwnerVerifiedForTrack": isQuoteOwnerVerifiedForTrack,
    "isCompleted": isCompleted,
  };
}
