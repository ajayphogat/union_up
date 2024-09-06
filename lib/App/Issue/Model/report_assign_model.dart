class ReportAssignModel {
  String? status;
  String? message;
  List<AssignReport>? data;

  ReportAssignModel({this.status, this.message, this.data});

  ReportAssignModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AssignReport>[];
      json['data'].forEach((v) {
        data!.add(new AssignReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignReport {
  int? id;
  String? displayName;
  String? image;

  AssignReport({this.id, this.displayName, this.image});

  AssignReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['image'] = this.image;
    return data;
  }
}