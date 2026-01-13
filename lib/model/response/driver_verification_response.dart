class DriverVerificationResponse {
  String? message;
  Data? data;
  bool? success;

  DriverVerificationResponse({
    this.message,
    this.data,
    this.success,
  });

  factory DriverVerificationResponse.fromJson(Map<String, dynamic> json) => DriverVerificationResponse(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "success": success,
  };
}

class Data {
  int? id;
  int? dateTime;
  int? postId;
  String? vehicleNumber;
  String? driverContact;
  String? postOwnerNumber;
  String? quoteOwnerNumber;
  dynamic postOwnerOtp;
  dynamic postOwnerOtpGeneratedAt;
  dynamic quoteOwnerOtp;
  dynamic quoteOwnerOtpGeneratedAt;
  String? details;

  Data({
    this.id,
    this.dateTime,
    this.postId,
    this.vehicleNumber,
    this.driverContact,
    this.postOwnerNumber,
    this.quoteOwnerNumber,
    this.postOwnerOtp,
    this.postOwnerOtpGeneratedAt,
    this.quoteOwnerOtp,
    this.quoteOwnerOtpGeneratedAt,
    this.details,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    dateTime: json["dateTime"],
    postId: json["postId"],
    vehicleNumber: json["vehicleNumber"],
    driverContact: json["driverContact"],
    postOwnerNumber: json["postOwnerNumber"],
    quoteOwnerNumber: json["quoteOwnerNumber"],
    postOwnerOtp: json["postOwnerOTP"],
    postOwnerOtpGeneratedAt: json["post_owner_otp_generated_at"],
    quoteOwnerOtp: json["quoteOwnerOTP"],
    quoteOwnerOtpGeneratedAt: json["quote_owner_otpGeneratedAt"],
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dateTime": dateTime,
    "postId": postId,
    "vehicleNumber": vehicleNumber,
    "driverContact": driverContact,
    "postOwnerNumber": postOwnerNumber,
    "quoteOwnerNumber": quoteOwnerNumber,
    "postOwnerOTP": postOwnerOtp,
    "post_owner_otp_generated_at": postOwnerOtpGeneratedAt,
    "quoteOwnerOTP": quoteOwnerOtp,
    "quote_owner_otpGeneratedAt": quoteOwnerOtpGeneratedAt,
    "details": details,
  };
}
