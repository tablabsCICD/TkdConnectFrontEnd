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
        content!.add(GroupMember.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['last'] = last;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['sort'] = sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    data['size'] = size;
    data['number'] = number;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groupId'] = groupId;
    data['date'] = date;
    data['userId'] = userId;
    data['isAvailable'] = isAvailable;
    data['addedByUserId'] = addedByUserId;
    data['displayName'] = displayName;
    return data;
  }
}
