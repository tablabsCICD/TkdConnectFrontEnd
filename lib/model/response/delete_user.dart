class DeleteUser {
  String? errorMessage;
  String? errorCode;

  DeleteUser({this.errorMessage, this.errorCode});

  DeleteUser.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    return data;
  }
}