class GroupMemberListResponse {
  List<GroupMember>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  String? sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  GroupMemberListResponse(
      {this.content,
        this.last,
        this.totalElements,
        this.totalPages,
        this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  GroupMemberListResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GroupMember>[];
      json['content'].forEach((v) {
        content!.add(new GroupMember.fromJson(v));
      });
    }
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    sort = json['sort'];
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['size'] = this.size;
    data['number'] = this.number;
    return data;
  }
}

class GroupMember {
  int? id;
  int? groupId;
  int? date;
  int? userId;
  int? isAvailable;
  int? addedByUserId;
  String? displayName;

  GroupMember(
      {this.id,
        this.groupId,
        this.date,
        this.userId,
        this.isAvailable,
        this.addedByUserId,
        this.displayName});

  GroupMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['groupId'];
    date = json['date'];
    userId = json['userId'];
    isAvailable = json['isAvailable'];
    addedByUserId = json['addedByUserId'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupId'] = this.groupId;
    data['date'] = this.date;
    data['userId'] = this.userId;
    data['isAvailable'] = this.isAvailable;
    data['addedByUserId'] = this.addedByUserId;
    data['displayName'] = this.displayName;
    return data;
  }
}
