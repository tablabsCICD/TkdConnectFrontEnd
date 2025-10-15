class TrackingResponse {
  String? message;
  List<Datum>? data;
  bool? success;

  TrackingResponse({
    this.message,
    this.data,
    this.success,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) => TrackingResponse(
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class Datum {
  int? id;
  String? latitude;
  String? longitude;
  String? speed;
  int? dateTime;

  Datum({
    this.id,
    this.latitude,
    this.longitude,
    this.speed,
    this.dateTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    speed: json["speed"],
    dateTime: json["dateTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "speed": speed,
    "dateTime": dateTime,
  };
}
