class SponserdPost {
  int? active;
  String? contractDetails;
  String? description;
  String? endDate;
  List<String>? images;
  String? loggedTime;
  String? loggedUserName;
  String? paymentStatus;
  int? sponsorshipAmount;
  int? sponsorshipId;
  String? startDate;
  String? title;
  String? typeName;

  SponserdPost(
      {this.active,
        this.contractDetails,
        this.description,
        this.endDate,
        this.images,
        this.loggedTime,
        this.loggedUserName,
        this.paymentStatus,
        this.sponsorshipAmount,
        this.sponsorshipId,
        this.startDate,
        this.title,
        this.typeName});

  SponserdPost.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    contractDetails = json['contractDetails'];
    description = json['description'];
    endDate = json['endDate'];
    images = json['images'].cast<String>();
    loggedTime = json['loggedTime'];
    loggedUserName = json['loggedUserName'];
    paymentStatus = json['paymentStatus'];
    sponsorshipAmount = json['sponsorshipAmount'];
    sponsorshipId = json['sponsorshipId'];
    startDate = json['startDate'];
    title = json['title'];
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['contractDetails'] = contractDetails;
    data['description'] = description;
    data['endDate'] = endDate;
    data['images'] = images;
    data['loggedTime'] = loggedTime;
    data['loggedUserName'] = loggedUserName;
    data['paymentStatus'] = paymentStatus;
    data['sponsorshipAmount'] = sponsorshipAmount;
    data['sponsorshipId'] = sponsorshipId;
    data['startDate'] = startDate;
    data['title'] = title;
    data['typeName'] = typeName;
    return data;
  }
}
