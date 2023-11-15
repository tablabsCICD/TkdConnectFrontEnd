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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['contractDetails'] = this.contractDetails;
    data['description'] = this.description;
    data['endDate'] = this.endDate;
    data['images'] = this.images;
    data['loggedTime'] = this.loggedTime;
    data['loggedUserName'] = this.loggedUserName;
    data['paymentStatus'] = this.paymentStatus;
    data['sponsorshipAmount'] = this.sponsorshipAmount;
    data['sponsorshipId'] = this.sponsorshipId;
    data['startDate'] = this.startDate;
    data['title'] = this.title;
    data['typeName'] = this.typeName;
    return data;
  }
}
