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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['userId'] = this.userId;
    return data;
  }
}