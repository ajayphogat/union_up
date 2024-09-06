

class IssueDetailModel {
  String? status;
  String? message;
  IssueDeatilData? data;

  IssueDetailModel({this.status, this.message, this.data});

  IssueDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new IssueDeatilData.fromJson(json['data']) : null;
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

class IssueDeatilData  {
  String? issueLocation;
  String? id;
  String? title;
  String? content;
  String? date;
  List<QuestionsAnswers>? questionsAnswers;
  String? issueCategory;
  String? issueCreatedUserId;
  String? issuePriority;
  String? issueType;
  List<String>? issueCategoryNames;
  String? issueStatus;
  String? reportIssue;
  List<String>? reportIssueUser;
  String? issueImages;
  String? issueVideos;
  String? notify;
  List<String>? notifyUser;
  String? isArchive;

  IssueDeatilData(
      {this.issueLocation,
        this.id,
        this.title,
        this.content,
        this.date,
        this.questionsAnswers,
        this.issueCategory,
        this.issueCreatedUserId,
        this.issuePriority,
        this.issueType,
        this.issueCategoryNames,
        this.issueStatus,
        this.reportIssue,
        this.reportIssueUser,
        this.issueImages,
        this.issueVideos,
        this.notify,
        this.notifyUser,
        this.isArchive});

  IssueDeatilData.fromJson(Map<String, dynamic> json) {
    issueLocation = json['issue_location'];
    id = json['id'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    if (json['questions_answers'] != null) {
      questionsAnswers = <QuestionsAnswers>[];
      json['questions_answers'].forEach((v) {
        questionsAnswers!.add(new QuestionsAnswers.fromJson(v));
      });
    }
    issueCategory = json['issue_category'];
    issueCreatedUserId = json['issue_created_user_id'];
    issuePriority = json['issue_priority'];
    issueType = json['issue_type'];
    issueCategoryNames = json['issue_category_names'].where((element) => element != null)
        .cast<String>()
        .toList();
    issueStatus = json['issue_status'].toString();
    reportIssue = json['report_issue'];
    reportIssueUser = json['report_issue_user'].where((element) => element != null)
        .cast<String>()
        .toList();
    issueImages = json['issue_images'];
    issueVideos = json['issue_videos'];
    notify = json['notify'];
    notifyUser = json['notify_user'].where((element) => element != null)
        .cast<String>()
        .toList();
    isArchive = json['is_archive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['issue_location'] = this.issueLocation;
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    if (this.questionsAnswers != null) {
      data['questions_answers'] =
          this.questionsAnswers!.map((v) => v.toJson()).toList();
    }
    data['issue_category'] = this.issueCategory;
    data['issue_created_user_id'] = this.issueCreatedUserId;
    data['issue_priority'] = this.issuePriority;
    data['issue_type'] = this.issueType;
    data['issue_category_names'] = this.issueCategoryNames;
    data['issue_status'] = this.issueStatus;
    data['report_issue'] = this.reportIssue;
    data['report_issue_user'] = this.reportIssueUser;
    data['issue_images'] = this.issueImages;
    data['issue_videos'] = this.issueVideos;
    data['notify'] = this.notify;
    data['notify_user'] = this.notifyUser;
    data['is_archive'] = this.isArchive;
    return data;
  }
}


class QuestionsAnswers {
  String? question;
  String? answer;

  QuestionsAnswers({this.question, this.answer});

  QuestionsAnswers.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}



