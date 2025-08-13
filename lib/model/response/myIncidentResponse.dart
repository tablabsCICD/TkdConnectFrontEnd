import 'getAllReportIncidentResponse.dart';

class MyReportIncidentResponse {
  List<IncidentObject>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? numberOfElements;
  bool? first;
  dynamic sort;
  int? size;
  int? number;

  MyReportIncidentResponse({
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

  factory MyReportIncidentResponse.fromJson(Map<String, dynamic> json) => MyReportIncidentResponse(
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
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
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
