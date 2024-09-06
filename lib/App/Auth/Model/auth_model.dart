class AuthModel {
  String? status;
  String? message;
  LoginData? data;

  AuthModel({this.status, this.message, this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  int? userId;
  String? username;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? userRole;
  String? authToken;

  LoginData(
      {this.userId,
        this.username,
        this.userEmail,
        this.userNicename,
        this.userDisplayName,
        this.userRole,
        this.authToken});

  LoginData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    userRole = json['user_role'] ?? json['role'] ;
    authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    data['user_role']  = this.userRole;
    data['auth_token'] = this.authToken;
    return data;
  }
}