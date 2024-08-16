class PostUpload {
  int? statusCode;
  String? message;
  bool? isSuccess;

  PostUpload({this.statusCode, this.message, this.isSuccess});

  PostUpload.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    return data;
  }
}