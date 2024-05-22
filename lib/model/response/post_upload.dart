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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}