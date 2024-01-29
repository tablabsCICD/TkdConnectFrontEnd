class CommentResponse {
  String? message;
  Data? data;
  bool? success;

  CommentResponse({this.message, this.data, this.success});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  GeneralPost? generalPost;
  List<Comments>? comments;
  int? commentCount;

  Data({this.generalPost, this.comments, this.commentCount});

  Data.fromJson(Map<String, dynamic> json) {
    generalPost = json['generalPost'] != null
        ? new GeneralPost.fromJson(json['generalPost'])
        : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generalPost != null) {
      data['generalPost'] = this.generalPost!.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['commentCount'] = this.commentCount;
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
  var loggedTime;

  GeneralPost(
      {this.id,
      this.typeName,
      this.images,
      this.description,
      this.title,
      this.likes,
      this.comment,
      this.userId,
      this.loggedTime});

  GeneralPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['typeName'];
    images = json['images'].cast<String>();
    description = json['description'];
    title = json['title'];
    likes = json['likes'];
    comment = json['comment'];
    userId = json['userId'];
    loggedTime = json['loggedTime'];
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
    return data;
  }
}

class Comments {
  int? id;
  int? discussionId;
  int? userId;
  String? comment;
  int? date;
  String? profileImage;
  String? userName;

  Comments(
      {this.id,
      this.discussionId,
      this.userId,
      this.comment,
      this.date,
      this.profileImage,
      this.userName});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discussionId = json['discussionId'] ?? '';
    userId = json['userId'] ?? '';
    comment = json['comment'] ?? '';
    date = json['date'] ?? '';
    profileImage = json['profileImage'] ?? '';
    userName = json['userName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['discussionId'] = this.discussionId;
    data['userId'] = this.userId;
    data['comment'] = this.comment;
    data['date'] = this.date;
    data['profileImage'] = this.profileImage;
    data['userName'] = this.userName;

    return data;
  }
}
