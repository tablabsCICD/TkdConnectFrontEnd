import 'package:tkd_connect/model/request/register_company.dart';

class RegistrationUserWithRoute {
  List<RouteReq>? route;
  RegisterCompany? user;

  RegistrationUserWithRoute({this.route, this.user});

  RegistrationUserWithRoute.fromJson(Map<String, dynamic> json) {
    if (json['route'] != null) {
      route = <RouteReq>[];
      json['route'].forEach((v) {
        route!.add(new RouteReq.fromJson(v));
      });
    }
    user = json['user'] != null ? new RegisterCompany.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.route != null) {
      data['route'] = this.route!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class RouteReq {
  String? destination;
  String? source;

  RouteReq({this.destination, this.source});

  RouteReq.fromJson(Map<String, dynamic> json) {
    destination = json['destination'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['destination'] = this.destination;
    data['source'] = this.source;
    return data;
  }
}

