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
        content!.add(JobData.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['sort'] = sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    data['size'] = size;
    data['number'] = number;
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
    json['postJob'] != null ? PostJob.fromJson(json['postJob']) : null;
    profileImg = json['profileImg'];
    postingDate = json['postingDate'];
    name = json['name'];
    isVerified = json['isVerified'];
    isPaid = json['isPaid'];
    transporterOrAgent = json['transporterOrAgent'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (postJob != null) {
      data['postJob'] = postJob!.toJson();
    }
    data['profileImg'] = profileImg;
    data['postingDate'] = postingDate;
    data['name'] = name;
    data['isVerified'] = isVerified;
    data['isPaid'] = isPaid;
    data['transporterOrAgent'] = transporterOrAgent;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    data['emailId'] = emailId;
    data['contactNumber'] = contactNumber;
    data['jobLocation'] = jobLocation;
    data['jobDescription'] = jobDescription;
    data['jobType'] = jobType;
    data['experience'] = experience;
    data['jobDepartment'] = jobDepartment;
    data['salary'] = salary;
    data['isSalaryNegotiable'] = isSalaryNegotiable;
    data['message'] = message;
    data['isSelected'] = isSelected;
    data['removedDate'] = removedDate;
    data['os'] = os;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    data['privatePost'] = privatePost;
    data['tableName'] = tableName;
    data['mainTag'] = mainTag;
    data['postingTime'] = postingTime;
    data['type'] = type;
    data['topicName'] = topicName;
    return data;
  }
}
