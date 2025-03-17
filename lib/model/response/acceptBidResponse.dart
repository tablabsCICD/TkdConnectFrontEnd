class AcceptBidResponse {
  String? message;
  AcceptBidData? data;
  bool? success;

  AcceptBidResponse({this.message, this.data, this.success});

  AcceptBidResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new AcceptBidData.fromJson(json['data']) : null;
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

class AcceptBidData {
  int? id;
  int? bidderUserId;
  String? amount;
  String? destinationLocation;
  String? sourceLocation;
  int? userId;
  int? loggedTime;
  int? postId;
  int? bidId;
  String? vehicleNumber;
  String? driverContact;
  int? isUpdatedDriverDetails;

  AcceptBidData(
      {this.id,
        this.bidderUserId,
        this.amount,
        this.destinationLocation,
        this.sourceLocation,
        this.userId,
        this.loggedTime,
        this.postId,
        this.bidId,
        this.vehicleNumber,
        this.driverContact,
        this.isUpdatedDriverDetails});

  AcceptBidData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bidderUserId = json['bidderUserId'];
    amount = json['amount'];
    destinationLocation = json['destinationLocation'];
    sourceLocation = json['sourceLocation'];
    userId = json['userId'];
    loggedTime = json['loggedTime'];
    postId = json['postId'];
    bidId = json['bidId'];
    vehicleNumber = json['vehicleNumber'];
    driverContact = json['driverContact'];
    isUpdatedDriverDetails = json['isUpdatedDriverDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bidderUserId'] = this.bidderUserId;
    data['amount'] = this.amount;
    data['destinationLocation'] = this.destinationLocation;
    data['sourceLocation'] = this.sourceLocation;
    data['userId'] = this.userId;
    data['loggedTime'] = this.loggedTime;
    data['postId'] = this.postId;
    data['bidId'] = this.bidId;
    data['vehicleNumber'] = this.vehicleNumber;
    data['driverContact'] = this.driverContact;
    data['isUpdatedDriverDetails'] = this.isUpdatedDriverDetails;
    return data;
  }
}
