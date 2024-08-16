class GroupListResponse {
  List<GroupData>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  String? sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  GroupListResponse(
      {this.content,
        this.last,
        this.totalElements,
        this.totalPages,
        this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  GroupListResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GroupData>[];
      json['content'].forEach((v) {
        content!.add(GroupData.fromJson(v));
      });
    }
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    sort = json['sort']??'';
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

class GroupData {
  int? id;
  int? createByUserId;
  int? date;
  String? groupName;
  int? isPrivate;
  String? imageUrl;

  GroupData(
      {this.id,
        this.createByUserId,
        this.date,
        this.groupName,
        this.isPrivate,
        this.imageUrl});

  GroupData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createByUserId = json['createByUserId'];
    date = json['date'];
    groupName = json['groupName'];
    isPrivate = json['isPrivate'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createByUserId'] = createByUserId;
    data['date'] = date;
    data['groupName'] = groupName;
    data['isPrivate'] = isPrivate;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
