class GroupMemberListResponse {
  List<GroupMember>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? numberOfElements;
  bool? first;
  dynamic sort;
  int? size;
  int? number;

  GroupMemberListResponse({
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

  factory GroupMemberListResponse.fromJson(Map<String, dynamic> json) => GroupMemberListResponse(
    content: json["content"] == null ? [] : List<GroupMember>.from(json["content"]!.map((x) => GroupMember.fromJson(x))),
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

class GroupMember {
  int? date;
  int? isAvailable;
  String? displayName;
  int? groupId;
  int? contact;
  String? name;
  String? location;
  int? id;
  int? userId;
  String? email;

  GroupMember({
    this.date,
    this.isAvailable,
    this.displayName,
    this.groupId,
    this.contact,
    this.name,
    this.location,
    this.id,
    this.userId,
    this.email,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    date: json["date"],
    isAvailable: json["isAvailable"],
    displayName: json["displayName"],
    groupId: json["groupId"],
    contact: json["contact"],
    name: json["name"],
    location: json["location"],
    id: json["id"],
    userId: json["userId"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "isAvailable": isAvailable,
    "displayName": displayName,
    "groupId": groupId,
    "contact": contact,
    "name": name,
    "location": location,
    "id": id,
    "userId": userId,
    "email": email,
  };
}
