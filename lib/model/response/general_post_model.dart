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
        data!.add(new GeneralPost.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeName'] = this.typeName;
    data['images'] = this.images;
    data['description'] = this.description;
    data['title'] = this.title;
    data['likes'] = this.likes;
    data['comment'] = this.comment;
    data['userId'] = this.userId;
    data['loggedTime'] = this.loggedTime;
    data['userName'] = this.userName;
    return data;
  }
}
