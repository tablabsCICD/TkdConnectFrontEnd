class VerifiedUser {
  String? message;
  int? data;
  bool? success;

  VerifiedUser({this.message, this.data, this.success});

  VerifiedUser.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['data'] = this.data;
    data['success'] = success;
    return data;
  }
}