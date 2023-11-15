class PostLoad {
  int? contactNumber;
  String? date;
  String? destination;
  int? dnd;
  String? emailId;
  String? fullLoadChoice;
  int? id;
  List<String>? image;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactNumber'] = this.contactNumber;
    data['date'] = this.date;
    data['destination'] = this.destination;
    data['dnd'] = this.dnd;
    data['emailId'] = this.emailId;
    data['fullLoadChoice'] = this.fullLoadChoice;
    data['id'] = this.id;
    data['images'] = this.image;
    data['instructions'] = this.instructions;
    data['listOfUserIds'] = this.listOfUserIds;
    data['loadWeight'] = this.loadWeight;
    data['loggedTime'] = this.loggedTime;
    data['loggedUserName'] = this.loggedUserName;
    data['mainTag'] = this.mainTag;
    data['os'] = this.os;
    data['otherDetails'] = this.otherDetails;
    data['partLoad'] = this.partLoad;
    data['postingTime'] = this.postingTime;
    data['privatePost'] = this.privatePost;
    data['rating'] = this.rating;
    data['source'] = this.source;
    data['tableName'] = this.tableName;
    data['topicName'] = this.topicName;
    data['transporterOrCustomerName'] = this.transporterOrCustomerName;
    data['type'] = this.type;
    data['typeOfCargo'] = this.typeOfCargo;
    data['typeOfPayment'] = this.typeOfPayment;
    data['vehicleSize'] = this.vehicleSize;
    return data;
  }
}
