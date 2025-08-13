class GetAllNewsResponse {
  List<Content>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  dynamic sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  GetAllNewsResponse({
    this.content,
    this.last,
    this.totalElements,
    this.totalPages,
    this.sort,
    this.first,
    this.numberOfElements,
    this.size,
    this.number,
  });

  factory GetAllNewsResponse.fromJson(Map<String, dynamic> json) => GetAllNewsResponse(
    content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
    last: json["last"],
    totalElements: json["totalElements"],
    totalPages: json["totalPages"],
    sort: json["sort"],
    first: json["first"],
    numberOfElements: json["numberOfElements"],
    size: json["size"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
    "last": last,
    "totalElements": totalElements,
    "totalPages": totalPages,
    "sort": sort,
    "first": first,
    "numberOfElements": numberOfElements,
    "size": size,
    "number": number,
  };
}

class Content {
  int? id;
  String? topicName;
  String? description;
  int? userId;
  String? image;
  dynamic image2;
  dynamic image3;
  dynamic image4;
  dynamic image5;
  int? isApproved;
  dynamic date;
  ImageType? imageType;
  dynamic youtubeLink;
  String? firstName;
  String? lastName;
  int? mobileNumber;
  String? companyName;
  String? profilePicture;

  Content({
    this.id,
    this.topicName,
    this.description,
    this.userId,
    this.image,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.isApproved,
    this.date,
    this.imageType,
    this.youtubeLink,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.companyName,
    this.profilePicture,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    topicName: json["topicName"],
    description: json["description"],
    userId: json["userId"],
    image: json["image"],
    image2: json["image2"],
    image3: json["image3"],
    image4: json["image4"],
    image5: json["image5"],
    isApproved: json["isApproved"],
    date: json["date"]??"",
    imageType: imageTypeValues.map[json["imageType"]],
    youtubeLink: json["youtubeLink"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobileNumber: json["mobileNumber"],
    companyName: json["companyName"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "topicName": topicName,
    "description": description,
    "userId": userId,
    "image": image,
    "image2": image2,
    "image3": image3,
    "image4": image4,
    "image5": image5,
    "isApproved": isApproved,
    "date": date?.toIso8601String(),
    "imageType": imageTypeValues.reverse[imageType],
    "youtubeLink": youtubeLink,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": mobileNumber,
    "companyName": companyName,
    "profilePicture": profilePicture,
  };
}

enum ImageType {
  APPLICATION_OCTET_STREAM,
  IMAGE_WEBP
}

final imageTypeValues = EnumValues({
  "application/octet-stream": ImageType.APPLICATION_OCTET_STREAM,
  "image/webp": ImageType.IMAGE_WEBP
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
