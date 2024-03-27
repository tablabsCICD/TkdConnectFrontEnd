class JobList {
  List<JobData>? content;
  bool? last;
  int? totalPages;
  int? totalElements;
  String? sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  JobList(
      {this.content,
        this.last,
        this.totalPages,
        this.totalElements,
        this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  JobList.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <JobData>[];
      json['content'].forEach((v) {
        content!.add(new JobData.fromJson(v));
      });
    }
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    sort = json['sort'];
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['size'] = this.size;
    data['number'] = this.number;
    return data;
  }
}

class JobData {
  PostJob? postJob;
  String? profileImg;
  String? postingDate;
  String? name;
  int? isVerified;
  int? isPaid;
  int? transporterOrAgent;


  JobData(
      {this.postJob,
        this.profileImg,
        this.postingDate,
        this.name,
        this.isVerified,
        this.isPaid,
        this.transporterOrAgent
      });

  JobData.fromJson(Map<String, dynamic> json) {
    postJob =
    json['postJob'] != null ? new PostJob.fromJson(json['postJob']) : null;
    profileImg = json['profileImg'];
    postingDate = json['postingDate'];
    name = json['name'];
    isVerified = json['isVerified'];
    isPaid = json['isPaid'];
    transporterOrAgent = json['transporterOrAgent'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postJob != null) {
      data['postJob'] = this.postJob!.toJson();
    }
    data['profileImg'] = this.profileImg;
    data['postingDate'] = this.postingDate;
    data['name'] = this.name;
    data['isVerified'] = this.isVerified;
    data['isPaid'] = this.isPaid;
    data['transporterOrAgent'] = this.transporterOrAgent;

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
        this.topicName});

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
    return data;
  }
}
