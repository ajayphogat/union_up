class HomeModel {
  String? status;
  String? message;
  HomeData? data;

  HomeModel({this.status, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HomeData {
  int? issuesCount;
  int? headsUpCount;
  int? assignedCount;
  int? overdueCount;
  List<AssignedTasks>? assignedTasks;
  List<AssignedTasks>? overdueTasks;
  List<Groups>? groups;
  List<Groups>? events;

  HomeData(
      {this.issuesCount,
        this.headsUpCount,
        this.assignedCount,
        this.overdueCount,
        this.assignedTasks,
        this.overdueTasks});

  HomeData.fromJson(Map<String, dynamic> json) {
    issuesCount = json['issues_count'];
    headsUpCount = json['heads_up_count'];
    assignedCount = json['assignedCount'];
    overdueCount = json['overdueCount'];
    if (json['assignedTasks'] != null) {
      assignedTasks = <AssignedTasks>[];
      json['assignedTasks'].forEach((v) {
        assignedTasks!.add(new AssignedTasks.fromJson(v));
      });
    }
    if (json['overdueTasks'] != null) {
      overdueTasks = <AssignedTasks>[];
      json['overdueTasks'].forEach((v) {
        overdueTasks!.add(new AssignedTasks.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
    if (json['events'] != null) {
      events = <Groups>[];
      json['events'].forEach((v) {
        events!.add(new Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['issues_count'] = this.issuesCount;
    data['heads_up_count'] = this.headsUpCount;
    data['assignedCount'] = this.assignedCount;
    data['overdueCount'] = this.overdueCount;
    if (this.assignedTasks != null) {
      data['assignedTasks'] =
          this.assignedTasks!.map((v) => v.toJson()).toList();
    }
    if (this.overdueTasks != null) {
      data['overdueTasks'] = this.overdueTasks!.map((v) => v.toJson()).toList();
    }
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignedTasks {
  int? taskId;
  String? taskTitle;
  String? priority;
  String? dueDate;

  AssignedTasks({this.taskId, this.taskTitle, this.priority, this.dueDate});

  AssignedTasks.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskTitle = json['task_title'];
    priority = json['priority'];
    dueDate = json['due_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['task_title'] = this.taskTitle;
    data['priority'] = this.priority;
    data['due_date'] = this.dueDate;
    return data;
  }
}

class Groups {
  String? image;
  String? name;
  String? type;
  String? memberCount;

  Groups({this.image, this.name, this.type, this.memberCount});

  Groups.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    type = json['type'];
    memberCount = json['member_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['type'] = this.type;
    data['member_count'] = this.memberCount;
    return data;
  }
}