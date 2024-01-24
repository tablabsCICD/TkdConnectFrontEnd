class MyJobList {
  String? message;
  List<MyJobData>? data;
  bool? success;

  MyJobList({this.message, this.data, this.success});

  MyJobList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MyJobData>[];
      json['data'].forEach((v) {
        data!.add(new MyJobData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class MyJobData {
  PostJob? postJob;
  String? profileImg;
  String? postingDate;
  String? name;


  MyJobData(
      {this.postJob,
        this.profileImg,
        this.postingDate,
        this.name,
        });

  MyJobData.fromJson(Map<String, dynamic> json) {
    postJob =
    json['postJob'] != null ? new PostJob.fromJson(json['postJob']) : null;
    profileImg = json['profileImg'];
    postingDate = json['postingDate'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postJob != null) {
      data['postJob'] = this.postJob!.toJson();
    }
    data['profileImg'] = this.profileImg;
    data['postingDate'] = this.postingDate;
    data['name'] = this.name;
    return data;
  }
}

class PostJob {
  int? id;
  String? companyName;
  String? emailId;
  int? contactNumber;
  String? jobLocation;
  String? jobDescription;
  String? jobType;
  String? experience;
  String? jobDepartment;
  String? salary;
  int? isSalaryNegotiable;
  String? message;
  int? isSelected;
  int? removedDate;
  String? os;
  String? loggedUserName;
  int? loggedTime;
  int? privatePost;
  String? tableName;
  String? mainTag;
  String? postingTime;
  String? type;
  String? topicName;
  int? userId;

  PostJob(
      {this.id,
        this.companyName,
        this.emailId,
        this.contactNumber,
        this.jobLocation,
        this.jobDescription,
        this.jobType,
        this.experience,
        this.jobDepartment,
        this.salary,
        this.isSalaryNegotiable,
        this.message,
        this.isSelected,
        this.removedDate,
        this.os,
        this.loggedUserName,
        this.loggedTime,
        this.privatePost,
        this.tableName,
        this.mainTag,
        this.postingTime,
        this.type,
        this.topicName,
        this.userId});

  PostJob.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    emailId = json['emailId'];
    contactNumber = json['contactNumber'];
    jobLocation = json['jobLocation'];
    jobDescription = json['jobDescription'];
    jobType = json['jobType'];
    experience = json['experience'];
    jobDepartment = json['jobDepartment'];
    salary = json['salary'];
    isSalaryNegotiable = json['isSalaryNegotiable'];
    message = json['message'];
    isSelected = json['isSelected'];
    removedDate = json['removedDate'];
    os = json['os'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    privatePost = json['privatePost'];
    tableName = json['tableName'];
    mainTag = json['mainTag'];
    postingTime = json['postingTime'];
    type = json['type'];
    topicName = json['topicName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['emailId'] = this.emailId;
    data['contactNumber'] = this.contactNumber;
    data['jobLocation'] = this.jobLocation;
    data['jobDescription'] = this.jobDescription;
    data['jobType'] = this.jobType;
    data['experience'] = this.experience;
    data['jobDepartment'] = this.jobDepartment;
    data['salary'] = this.salary;
    data['isSalaryNegotiable'] = this.isSalaryNegotiable;
    data['message'] = this.message;
    data['isSelected'] = this.isSelected;
    data['removedDate'] = this.removedDate;
    data['os'] = this.os;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    data['privatePost'] = this.privatePost;
    data['tableName'] = this.tableName;
    data['mainTag'] = this.mainTag;
    data['postingTime'] = this.postingTime;
    data['type'] = this.type;
    data['topicName'] = this.topicName;
    data['userId'] = this.userId;
    return data;
  }
}
