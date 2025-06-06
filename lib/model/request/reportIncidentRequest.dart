class ReportIncidentRequest {
  String? amountLost;
  String? cheatedBy;
  String? date;
  String? description;
  int? id;
  String? image;
  String? incidentType;
  bool? isFirLounched;
  bool? isResolved;
  String? resolutionDetails;
  String? topic;
  int? userId;
  String? vehicleNumber;

  ReportIncidentRequest({
    this.amountLost,
    this.cheatedBy,
    this.date,
    this.description,
    this.id,
    this.image,
    this.incidentType,
    this.isFirLounched,
    this.isResolved,
    this.resolutionDetails,
    this.topic,
    this.userId,
    this.vehicleNumber,
  });

  factory ReportIncidentRequest.fromJson(Map<String, dynamic> json) => ReportIncidentRequest(
    amountLost: json["amountLost"],
    cheatedBy: json["cheatedBy"],
    date: json["date"],
    description: json["description"],
    id: json["id"],
    image: json["image"],
    incidentType: json["incidentType"],
    isFirLounched: json["isFIRLounched"],
    isResolved: json["isResolved"],
    resolutionDetails: json["resolutionDetails"],
    topic: json["topic"],
    userId: json["userId"],
    vehicleNumber: json["vehicleNumber"],
  );

  Map<String, dynamic> toJson() => {
    "amountLost": amountLost,
    "cheatedBy": cheatedBy,
    "date": date,
    "description": description,
    "id": id,
    "image": image,
    "incidentType": incidentType,
    "isFIRLounched": isFirLounched,
    "isResolved": isResolved,
    "resolutionDetails": resolutionDetails,
    "topic": topic,
    "userId": userId,
    "vehicleNumber": vehicleNumber,
  };
}
