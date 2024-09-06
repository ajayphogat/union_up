class TaskDetailModel {
  String? status;
  String? message;
  TaskData? data;

  TaskDetailModel({this.status, this.message, this.data});

  TaskDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new TaskData.fromJson(json['data']) : null;
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

class TaskData {
  String? taskCreatorId;
  String? title;
  String? content;
  String? date;
  String? priority;
  String? dueDate;
  String? status;
  String? assigneUser;
  List<String>? assigneDisplayName;
  String? assigneGroup;
  List<String>? assigneGroupName;

  TaskData(
      {this.taskCreatorId,
        this.title,
        this.content,
        this.date,
        this.priority,
        this.dueDate,
        this.status,
        this.assigneUser,
        this.assigneDisplayName,
        this.assigneGroup,
        this.assigneGroupName});

  TaskData.fromJson(Map<String, dynamic> json) {
    taskCreatorId = json['task_creator_id'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    priority = json['priority'];
    dueDate = json['due_date'];
    status = json['status'];
    assigneUser = json['assigne_user'];
    assigneDisplayName = json['assigne_display_name'].cast<String>();
    assigneGroup = json['assigne_group'];
    assigneGroupName = json['assigne_group_name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_creator_id'] = this.taskCreatorId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['priority'] = this.priority;
    data['due_date'] = this.dueDate;
    data['status'] = this.status;
    data['assigne_user'] = this.assigneUser;
    data['assigne_display_name'] = this.assigneDisplayName;
    data['assigne_group'] = this.assigneGroup;
    data['assigne_group_name'] = this.assigneGroupName;
    return data;
  }
}