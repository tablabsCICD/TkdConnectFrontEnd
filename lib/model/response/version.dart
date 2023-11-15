class Version {
  int? id;
  String? version;

  Version({this.id, this.version});

  Version.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['version'] = this.version;
    return data;
  }
}
