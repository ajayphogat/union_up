class TaskGroupModel {
  String? status;
  String? message;
  List<TaskGroupData>? data;

  TaskGroupModel({this.status, this.message, this.data});

  TaskGroupModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TaskGroupData>[];
      json['data'].forEach((v) {
        data!.add(new TaskGroupData.fromJson(v));
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

class TaskGroupData {
  String? id;
  String? name;

  TaskGroupData({this.id, this.name});

  TaskGroupData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}