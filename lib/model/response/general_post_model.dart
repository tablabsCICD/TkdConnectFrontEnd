class GeneralPostModel {
  String? message;
  List<GeneralPost>? data;
  bool? success;

  GeneralPostModel({this.message, this.data, this.success});

  GeneralPostModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GeneralPost>[];
      json['data'].forEach((v) {
        data!.add(GeneralPost.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class GeneralPost {
  int? id;
  String? typeName;
  List<String>? images;
  String? description;
  String? title;
  int? likes;
  String? comment;
  int? userId;
  int? loggedTime;
  String? userName;

  GeneralPost(
      {this.id,
        this.typeName,
        this.images,
        this.description,
        this.title,
        this.likes,
        this.comment,
        this.userId,
        this.loggedTime,
        this.userName});

  GeneralPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['typeName']??'';
    images = json['images'].cast<String>();
    description = json['description']??'';
    title = json['title']??"";
    likes = json['likes']??0;
    comment = json['comment']??'';
    userId = json['userId']??0;
    loggedTime = json['loggedTime']??0;
    userName = json['userName']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['typeName'] = typeName;
    data['images'] = images;
    data['description'] = description;
    data['title'] = title;
    data['likes'] = likes;
    data['comment'] = comment;
    data['userId'] = userId;
    data['loggedTime'] = loggedTime;
    data['userName'] = userName;
    return data;
  }
}
