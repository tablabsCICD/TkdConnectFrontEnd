class RatingRequest {
  int? companyId;
  int? rating;
  String? review;
  int? userId;

  RatingRequest({this.companyId, this.rating, this.review, this.userId});

  RatingRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    rating = json['rating'];
    review = json['review'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyId'] = companyId;
    data['rating'] = rating;
    data['review'] = review;
    data['userId'] = userId;
    return data;
  }
}