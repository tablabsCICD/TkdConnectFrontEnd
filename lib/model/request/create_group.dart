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