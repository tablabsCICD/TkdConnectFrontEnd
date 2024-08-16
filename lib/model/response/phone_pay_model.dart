class RazorPayOrderId {
  String? message;
  String? data;
  bool? success;

  RazorPayOrderId({this.message, this.data, this.success});

  RazorPayOrderId.fromJson(Map<String, dynamic> json) {
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