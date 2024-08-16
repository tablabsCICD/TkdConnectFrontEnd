class RouteModel {
  RouteModel({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    this.sort,
    required this.first,
    required this.numberOfElements,
  });
  late final List<RouteData> content;
  late final int totalPages;
  late final int totalElements;
  late final bool last;
  late final int size;
  late final int number;
  late final String? sort;
  late final bool first;
  late final int numberOfElements;

  RouteModel.fromJson(Map<String, dynamic> json){
    content = List.from(json['content']).map((e)=>RouteData.fromJson(e)).toList();
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = json['sort']??'';
    first = json['first'];
    numberOfElements = json['numberOfElements'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['content'] = content.map((e)=>e.toJson()).toList();
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['last'] = last;
    data['size'] = size;
    data['number'] = number;
    data['sort'] = sort;
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    return data;
  }
}

class RouteData {
  RouteData({
    required this.id,
    required this.userId,
    required this.routeSource,
    required this.routeDestination,
    required this.loggedUserName,
    this.loggedTime,
  });
  late final int? id;
  late final int? userId;
  late final String? routeSource;
  late final String? routeDestination;
  late final String? loggedUserName;
  late final int? loggedTime;

  RouteData.fromJson(Map<String, dynamic> json){
    id = json['id']?? 0;
    userId = json['userId']?? 0;
    routeSource = json['routeSource']?? '';
    routeDestination = json['routeDestination']?? '';
    loggedUserName = json['loggedUserName']?? '';
    loggedTime = json['loggedTime']?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['routeSource'] = routeSource;
    data['routeDestination'] = routeDestination;
    data['loggedUserName'] = loggedUserName;
    data['loggedTime'] = loggedTime;
    return data;
  }
}