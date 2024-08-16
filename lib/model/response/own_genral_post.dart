class OwnGenralPostList {
  String? message;
  List<GernralPostOwnData>? data;
  bool? success;

  OwnGenralPostList({this.message, this.data, this.success});

  OwnGenralPostList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GernralPostOwnData>[];
      json['data'].forEach((v) {
        data!.add(GernralPostOwnData.fromJson(v));
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

class GernralPostOwnData {
  int? id;
  String? typeName;
 // List<Null>? images;
  String? description;
  String? title;
  int? likes;
  String? comment;
  int? userId;
 // Null? loggedTime;

  GernralPostOwnData(
      {this.id,
        this.typeName,
        //this.images,
        this.description,
        this.title,
        this.likes,
        this.comment,
        this.userId,
       // this.loggedTime
      });

  GernralPostOwnData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['typeName'];
    // if (json['images'] != null) {
    //   images = <Null>[];
    //   json['images'].forEach((v) {
    //     images!.add(new Null.fromJson(v));
    //   });
    // }
    description = json['description'];
    title = json['title'];
    likes = json['likes'];
    comment = json['comment'];
    userId = json['userId'];
   // loggedTime = json['loggedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['typeName'] = typeName;
    // if (this.images != null) {
    //   data['images'] = this.images!.map((v) => v.toJson()).toList();
    // }
    data['description'] = description;
    data['title'] = title;
    data['likes'] = likes;
    data['comment'] = comment;
    data['userId'] = userId;
   // data['loggedTime'] = this.loggedTime;
    return data;
  }
}
