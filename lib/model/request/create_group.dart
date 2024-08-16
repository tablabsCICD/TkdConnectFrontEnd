class GroupCreateModel {
  int? id;
  int? createByUserId;
  int? date;
  String? groupName;
  int? isPrivate;
  String? imageUrl;

  GroupCreateModel(
      {this.id,
        this.createByUserId,
        this.date,
        this.groupName,
        this.isPrivate,
        this.imageUrl});

  GroupCreateModel.fromJson(Map<String, dynamic> json) {
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