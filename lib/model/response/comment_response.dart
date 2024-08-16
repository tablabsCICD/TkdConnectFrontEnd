class CommentResponse {
  String? message;
  Data? data;
  bool? success;

  CommentResponse({this.message, this.data, this.success});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
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
        ? GeneralPost.fromJson(json['generalPost'])
        : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (generalPost != null) {
      data['generalPost'] = generalPost!.toJson();
    }
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['commentCount'] = commentCount;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['discussionId'] = discussionId;
    data['userId'] = userId;
    data['comment'] = comment;
    data['date'] = date;
    data['profileImage'] = profileImage;
    data['userName'] = userName;

    return data;
  }
}
