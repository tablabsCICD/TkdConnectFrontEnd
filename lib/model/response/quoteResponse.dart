// To parse this JSON data, do
//
//     final quoteResponse = quoteResponseFromJson(jsonString);


class QuoteResponse {
  String? message;
  List<MonthData>? data;
  bool? success;

  QuoteResponse({
    this.message,
    this.data,
    this.success,
  });

  factory QuoteResponse.fromJson(Map<String, dynamic> json) => QuoteResponse(
    message: json["message"],
    data: json["data"] == null ? [] : List<MonthData>.from(json["data"]!.map((x) => MonthData.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class MonthData {
  String? month;
  List<LabelValue>? list;

  MonthData({
    this.month,
    this.list,
  });

  factory MonthData.fromJson(Map<String, dynamic> json) => MonthData(
    month: json["month"],
    list: json["list"] == null ? [] : List<LabelValue>.from(json["list"]!.map((x) => LabelValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class LabelValue {
  String? label;
  String? value;

  LabelValue({
    this.label,
    this.value,
  });

  factory LabelValue.fromJson(Map<String, dynamic> json) => LabelValue(
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}
