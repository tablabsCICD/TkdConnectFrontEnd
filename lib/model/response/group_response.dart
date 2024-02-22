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
        content!.add(new GroupData.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createByUserId'] = this.createByUserId;
    data['date'] = this.date;
    data['groupName'] = this.groupName;
    data['isPrivate'] = this.isPrivate;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
