class AddNewsRequest {
  String? companyName;
  String? date;
  String? description;
  String? firstName;
  int? id;
  String? image;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? imageType;
  int? isApproved;
  String? lastName;
  int? mobileNumber;
  String? profilePicture;
  String? topicName;
  int? userId;
  String? youtubeLink;

  AddNewsRequest({
    this.companyName,
    this.date,
    this.description,
    this.firstName,
    this.id,
    this.image,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.imageType,
    this.isApproved,
    this.lastName,
    this.mobileNumber,
    this.profilePicture,
    this.topicName,
    this.userId,
    this.youtubeLink,
  });

  factory AddNewsRequest.fromJson(Map<String, dynamic> json) => AddNewsRequest(
    companyName: json["companyName"],
    date: json["date"],
    description: json["description"],
    firstName: json["firstName"],
    id: json["id"],
    image: json["image"],
    image2: json["image2"],
    image3: json["image3"],
    image4: json["image4"],
    image5: json["image5"],
    imageType: json["imageType"],
    isApproved: json["isApproved"],
    lastName: json["lastName"],
    mobileNumber: json["mobileNumber"],
    profilePicture: json["profilePicture"],
    topicName: json["topicName"],
    userId: json["userId"],
    youtubeLink: json["youtubeLink"],
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "date": date,
    "description": description,
    "firstName": firstName,
    "id": id,
    "image": image,
    "image2": image2,
    "image3": image3,
    "image4": image4,
    "image5": image5,
    "imageType": imageType,
    "isApproved": isApproved,
    "lastName": lastName,
    "mobileNumber": mobileNumber,
    "profilePicture": profilePicture,
    "topicName": topicName,
    "userId": userId,
    "youtubeLink": youtubeLink,
  };
}
