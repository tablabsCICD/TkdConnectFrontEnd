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
    final _data = <String, dynamic>{};
    _data['content'] = content.map((e)=>e.toJson()).toList();
    _data['totalPages'] = totalPages;
    _data['totalElements'] = totalElements;
    _data['last'] = last;
    _data['size'] = size;
    _data['number'] = number;
    _data['sort'] = sort;
    _data['first'] = first;
    _data['numberOfElements'] = numberOfElements;
    return _data;
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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['routeSource'] = routeSource;
    _data['routeDestination'] = routeDestination;
    _data['loggedUserName'] = loggedUserName;
    _data['loggedTime'] = loggedTime;
    return _data;
  }
}