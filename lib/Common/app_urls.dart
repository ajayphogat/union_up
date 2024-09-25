
///

///Server URL

const String serverURL = "https://wp-dev.rglabs.net/union-up/";

const String baseURL = "${serverURL}wp-json/custom/v1/";
const String baseURL2 = "${serverURL}wp-json/wp/v2/";


///Auth Urls
const String registerUrl = "${baseURL}register";
const String loginUrl = "${baseURL}login";
const String homeUrl = "${baseURL}home";

const String issueCategoryUrl = "${baseURL}issue_category";
const String issueReportUrl = "${baseURL}issue_role_user";

const String issueListingUrl = "${baseURL2}issues";
const String taskListingUrl = "${baseURL2}tasks";

const String addIssueUrl = "${baseURL}post_issue";
const String updateIssueUrl = "${baseURL}update_issue";
const String addTaskUrl = "${baseURL}add_task";
const String taskGroupUrl = "${baseURL}task_group";
const String taskDetailUrl = "${baseURL}task_detail";
const String issueDetailUrl = "${baseURL}issue_detail";
const String issueCommentUrl = "${baseURL}post_issue_comment";
const String detailCommentUrl = "${baseURL}comment_listing";
const String addArchiveUrl = "${baseURL}add_archive";

class ApiKeys{
  ApiKeys._();
  static const googleAPiKey = "AIzaSyACG0YonxAConKXfgaeVYj7RCRdXazrPYI";
}