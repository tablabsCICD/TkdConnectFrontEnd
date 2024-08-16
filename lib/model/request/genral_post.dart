class GeneralPost {
  int? active;
  int? comment;
  String? description;
  int? disLikes;
  int? id;
  List<String>? images;
  int? likes;
  String? loggedTime;
  int? loggedUserName;
  String? title;
  String? typeName;

  GeneralPost(
      {this.active,
        this.comment,
        this.description,
        this.disLikes,
        this.id,
        this.images,
        this.likes,
        this.loggedTime,
        this.loggedUserName,
        this.title,
        this.typeName});

  GeneralPost.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    comment = json['comment'];
    description = json['description'];
    disLikes = json['disLikes'];
    id = json['id'];
    images = json['images'].cast<String>();
    likes = json['likes'];
    loggedTime = json['loggedTime'];
    loggedUserName = json['loggedUserName'];
    title = json['title'];
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['comment'] = comment;
    data['description'] = description;
    data['disLikes'] = disLikes;
    data['id'] = id;
    data['images'] = images;
    data['likes'] = likes;
    data['loggedTime'] = loggedTime;
    data['userId'] = loggedUserName;
    data['title'] = title;
    data['typeName'] = typeName;
    return data;
  }
}
