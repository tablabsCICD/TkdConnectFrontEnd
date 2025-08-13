class GetAllReportIncidentResponse {
  List<IncidentObject>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? numberOfElements;
  bool? first;
  dynamic sort;
  int? size;
  int? number;

  GetAllReportIncidentResponse({
    this.content,
    this.last,
    this.totalElements,
    this.totalPages,
    this.numberOfElements,
    this.first,
    this.sort,
    this.size,
    this.number,
  });

  factory GetAllReportIncidentResponse.fromJson(Map<String, dynamic> json) => GetAllReportIncidentResponse(
    content: json["content"] == null ? [] : List<IncidentObject>.from(json["content"]!.map((x) => IncidentObject.fromJson(x))),
    last: json["last"],
    totalElements: json["totalElements"],
    totalPages: json["totalPages"],
    numberOfElements: json["numberOfElements"],
    first: json["first"],
    sort: json["sort"],
    size: json["size"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "content": content == [] || content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
    "last": last,
    "totalElements": totalElements,
    "totalPages": totalPages,
    "numberOfElements": numberOfElements,
    "first": first,
    "sort": sort,
    "size": size,
    "number": number,
  };
}

class IncidentObject {
  int? id;
  int? date;
  String? topic;
  dynamic description;
  dynamic userId;
  dynamic image;
  dynamic resolutionDetails;
  dynamic isResolved;
  dynamic amountLost;
  dynamic vehicleNumber;
  dynamic cheatedBy;
  dynamic incidentType;
  dynamic isFirLounched;
  int? mobileNumber;

  IncidentObject({
    this.id,
    this.date,
    this.topic,
    this.description,
    this.userId,
    this.image,
    this.resolutionDetails,
    this.isResolved,
    this.amountLost,
    this.vehicleNumber,
    this.cheatedBy,
    this.incidentType,
    this.isFirLounched,
    this.mobileNumber
  });

  factory IncidentObject.fromJson(Map<String, dynamic> json) => IncidentObject(
    id: json["id"],
    date: json["date"],
    topic: json["topic"],
    description: json["description"],
    userId: json["userId"],
    image: json["image"],
    resolutionDetails: json["resolutionDetails"],
    isResolved: json["isResolved"],
    amountLost: json["amountLost"],
    vehicleNumber: json["vehicleNumber"],
    cheatedBy: json["cheatedBy"],
    incidentType: json["incidentType"],
    isFirLounched: json["isFIRLounched"],
    mobileNumber: json["mobileNumber"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "topic": topic,
    "description": description,
    "userId": userId,
    "image": image,
    "resolutionDetails": resolutionDetails,
    "isResolved": isResolved,
    "amountLost": amountLost,
    "vehicleNumber": vehicleNumber,
    "cheatedBy": cheatedBy,
    "incidentType": incidentType,
    "isFIRLounched": isFirLounched,
    "mobileNumber":mobileNumber
  };
}
