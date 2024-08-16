class PostLoad {
  int? contactNumber;
  String? date;
  String? destination;
  int? dnd;
  String? emailId;
  String? fullLoadChoice;
  int? id;
  List<String>? image;
  String? images;
  String? instructions;
  List<int>? listOfUserIds;
  String? loadWeight;
  String? loggedTime;
  String? loggedUserName;
  String? mainTag;
  String? os;
  String? otherDetails;
  int? partLoad;
  String? postingTime;
  int? privatePost;
  int? rating;
  String? source;
  String? tableName;
  String? topicName;
  String? transporterOrCustomerName;
  String? type;
  String? typeOfCargo;
  String? typeOfPayment;
  String? vehicleSize;
  String? userList;

  PostLoad(
      {this.contactNumber,
        this.date,
        this.destination,
        this.dnd,
        this.emailId,
        this.fullLoadChoice,
        this.id,
        this.image,
        this.instructions,
        this.listOfUserIds,
        this.loadWeight,
        this.loggedTime,
        this.loggedUserName,
        this.mainTag,
        this.os,
        this.otherDetails,
        this.partLoad,
        this.postingTime,
        this.privatePost,
        this.rating,
        this.source,
        this.tableName,
        this.topicName,
        this.transporterOrCustomerName,
        this.type,
        this.typeOfCargo,
        this.typeOfPayment,
        this.userList,
        this.images,
        this.vehicleSize});

  PostLoad.fromJson(Map<String, dynamic> json) {
    contactNumber = json['contactNumber'];
    date = json['date'];
    destination = json['destination'];
    dnd = json['dnd'];
    emailId = json['emailId'];
    fullLoadChoice = json['fullLoadChoice'];
    id = json['id'];
    image = json['image'].cast<String>();
    instructions = json['instructions'];
    listOfUserIds = json['listOfUserIds'].cast<int>();
    loadWeight = json['loadWeight'];
    loggedTime = json['loggedTime'];
    loggedUserName = json['loggedUserName'];
    mainTag = json['mainTag'];
    os = json['os'];
    otherDetails = json['otherDetails'];
    partLoad = json['partLoad'];
    postingTime = json['postingTime'];
    privatePost = json['privatePost'];
    rating = json['rating'];
    source = json['source'];
    tableName = json['tableName'];
    topicName = json['topicName'];
    transporterOrCustomerName = json['transporterOrCustomerName'];
    type = json['type'];
    typeOfCargo = json['typeOfCargo'];
    typeOfPayment = json['typeOfPayment'];
    vehicleSize = json['vehicleSize'];
    userList = json['userList'];
    images="";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contactNumber'] = contactNumber;
    data['date'] = date;
    data['destination'] = destination;
    data['dnd'] = dnd;
    data['emailId'] = emailId;
    data['fullLoadChoice'] = fullLoadChoice;
    data['id'] = id;
    data['image'] = images;

    data['instructions'] = instructions;
    data['listOfUserIds'] = listOfUserIds;
    data['loadWeight'] = loadWeight;
    data['loggedTime'] = loggedTime;
    data['loggedUserName'] = loggedUserName;
    data['mainTag'] = mainTag;
    data['os'] = os;
    data['otherDetails'] = otherDetails;
    data['partLoad'] = partLoad;
    data['postingTime'] = postingTime;
    data['privatePost'] = privatePost;
    data['rating'] = rating;
    data['source'] = source;
    data['tableName'] = tableName;
    data['topicName'] = topicName;
    data['transporterOrCustomerName'] = transporterOrCustomerName;
    data['type'] = type;
    data['typeOfCargo'] = typeOfCargo;
    data['typeOfPayment'] = typeOfPayment;
    data['vehicleSize'] = vehicleSize;
    data['userList'] = userList;
    return data;
  }
}
