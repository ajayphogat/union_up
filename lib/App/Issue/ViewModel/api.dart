import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:union_up/Common/app_colors.dart';
import 'package:union_up/Common/snackbar.dart';
import 'package:union_up/Config/shared_prif.dart';

import '../../../Common/app_urls.dart';
import '../../../Utils/http_network.dart';
import '../Model/detail_comment_model.dart';
import '../Model/issue_category_model.dart';
import '../Model/issue_detail_model.dart';
import '../Model/issue_model.dart';
import '../Model/report_assign_model.dart';
import 'package:http/http.dart' as http;

import '../View/issue_detail_sceen.dart';
import '../View/issue_screen.dart';

class IssueApi {
  Future<IssueCategoryModel?> issueCategory(
    BuildContext context,
  ) async {
    try {
      final parse = await HttpService.getRequest(
        url: issueCategoryUrl,
        context: context,
      );
      if (parse == null) {
        return null;
      }

      if (parse["status"] == "success") {
        return IssueCategoryModel.fromJson(parse);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<List<IssueListModel>?> issueListing(
    BuildContext context,
    int page,
  ) async {
    try {
      print("start issue list");

      var headers = {
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };

      final parse = await HttpService.getWithHeaderRequest(
          url: "$issueListingUrl?page=$page&per_page=10",
          context: context,
          headers: headers);

      if (parse == null) {
        return null;
      }

      List a = parse as List;

      return a
          .map(
            (e) => IssueListModel.fromJson(e),
          )
          .toList();

      // IssueModel.fromJson(a as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<ReportAssignModel?> reportToCategory(
    BuildContext context,
  ) async {
    String? role =
        SharedStorage.localStorage?.getString(SharedStorage.userRole);
    var token = SharedStorage.localStorage?.getString(SharedStorage.token);
    print("token==$token}");
    var body = json.encode({"role": role});
    print(role);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
      'Cookie':
          'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724479308%7CJUbK1DSLFVNbm2LHTB7JxgcO5MUp5V82arnbCv7ew8g%7C0f8e669d530e03bb360424d52cdb2fbf38d89a6825fb48488b7bc90879142d62'
    };

    // print(issueReportUrl ==
    //     'https://wp-dev.rglabs.net/union-up/wp-json/custom/v1/issue_role_user');
    try {
      final parse = await HttpService.postRequest(
          url: issueReportUrl, context: context, body: body, headers: headers);

      if (parse == null) {
        return null;
      }

      if (parse["status"] == "success") {
        return ReportAssignModel.fromJson(parse);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<bool?> addIssue(BuildContext context, AddIssueModel data) async {
    var client = http.Client();
    var token = SharedStorage.localStorage?.getString(SharedStorage.token);
    var headers = {
      // 'Connection': 'keep-alive',
      'Authorization': "Bearer $token",
      'Cookie':
          'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873',
      // 'Content-Type': 'multipart/form-data',
    };

    var questionAnswer = [
      {
        "question": "What needs to be done?",
        "answer": data.question2 ?? "No Answer"
      },
      {"question": "What caused it?", "answer": data.question1 ?? "No Answer"}
    ];

    print("questionEncode====${jsonEncode(questionAnswer)}");
    try {
      final request = http.MultipartRequest('POST', Uri.parse(addIssueUrl));
      request.fields.addAll({
        'issue_location': data.issueLocation ?? "",
        'questions': jsonEncode(questionAnswer),
        // 'issue_category': data.category,
        'issue_description': data.description ?? "",
        'issue_priority': data.priority ?? "",
        'issue_title': data.title ?? "",
        'issue_type': data.category,
        'issue_status': data.status ?? "",
        'report_issue': data.reportIssue ?? "",
        'notify': data.notifyList.join(',')
      });

      print("====${data.notifyList.join(',')}");
      print("====${data.category}");
      // print("questionDecode====${jsonDecode("$questionAnswer")}");

      if (data.images != null) {
        for (File imagePath in data.images!) {
          if (await imagePath.exists()) {
            print('Adding image: ${imagePath.path}');
            request.files.add(await http.MultipartFile.fromPath(
                'issue_images[]', imagePath.path));
          } else {
            request.files
                .add(await http.MultipartFile.fromPath('issue_images[]', ""));

            print('Image not found: ${imagePath.path}');
          }
        }
      }

      // Handle video
      if (data.video != null && await File(data.video!.path).exists()) {
        print('Adding video: ${data.video!.path}');
        request.files.add(await http.MultipartFile.fromPath(
            'issue_videos[]', data.video!.path));
      } else {
        print('Video not found: ${data.video?.path}');
        // request.files.add(await http.MultipartFile.fromPath('issue_videos[]', ""));
      }
      request.headers.addAll(headers);

      var response = await client.send(request).timeout(
          const Duration(seconds: 60)); // Increase timeout if necessary

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        return true;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      print('Error: $e');
      if (e is SocketException) {
        print('Network error: ${e.osError}');
      } else if (e is TimeoutException) {
        print('Timeout error');
      } else if (e is ClientException) {
        print('ClientException: ${e.message}');
      }
      return false;
    } finally {
      client.close();
    }
  }

  Future<bool?> addIssueComment(
      BuildContext context, AddIssueCommentModel data) async {
    var token = SharedStorage.localStorage?.getString(SharedStorage.token);
    var headers = {
      'Authorization': 'Bearer $token',
      'Cookie':
          'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=Ajay%7C1725603496%7CIZZUHEQlLpoD35FHYouwRuVx5wxBQsy5QUIc21xYnCw%7C4255444d413668699e271b0f3e0f010f74509c022d410c1d1b71673e137859e4'
    };

    var request = http.MultipartRequest('POST', Uri.parse(issueCommentUrl));
    request.fields.addAll({
      'comment': data.comment ?? "",
      'post_id': data.postId,
      'comment_parent': data.commentParentId ?? ""
    });

    if (data.commentImage != "") {
      request.files.add(await http.MultipartFile.fromPath(
          'comment_image', data.commentImage ?? ""));
    }
    if (data.commentDocs != "") {
      request.files.add(await http.MultipartFile.fromPath(
          'comment_document', data.commentDocs ?? ""));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // showSnackBarBottom(context: context,
      //     title: "Success",description: "Comment added successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Comment added successfully",style: Theme.of(context).textTheme.labelLarge,),
          backgroundColor: AppColors.primary,
        ),
      );

      print("add comment==== ${await response.stream.bytesToString()}");
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<IssueDetailModel?> getIssueDetail(
      BuildContext context, String id) async {
    try {
      print("task deatal");
      var token = SharedStorage.localStorage?.getString(SharedStorage.token);
      var headers = {
        'Authorization': "Bearer $token",
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };
      var body = {'post_id': id};

      final parse = await HttpService.postRequest(
          url: issueDetailUrl, context: context, headers: headers, body: body);

      if (parse["status"] == "success") {
        return IssueDetailModel.fromJson(parse);
      } else {
        return null;
      }

      // IssueModel.fromJson(a as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<CommentModel?> getDetailComment(
      BuildContext context, String id) async {
    try {
      print(" get comment====");

      var token = SharedStorage.localStorage?.getString(SharedStorage.token);
      var headers = {
        'Authorization': "Bearer $token",
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };
      var body = {'post_id': id};

      final parse = await HttpService.postRequest(
          url: detailCommentUrl,
          context: context,
          headers: headers,
          body: body);

      if(parse != null) {
        if (parse["status"] == "success") {
          print("comment list=== $parse");
          return CommentModel.fromJson(parse);
        } else {
          return null;
        }
      }else{
        return null;
      }

      // IssueModel.fromJson(a as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<bool?> addArchive(BuildContext context, id) async {
    var token = SharedStorage.localStorage?.getString(SharedStorage.token);
    var headers = {
      'Authorization': 'Bearer $token',
      'Cookie':
          'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=Ajay%7C1725603496%7CIZZUHEQlLpoD35FHYouwRuVx5wxBQsy5QUIc21xYnCw%7C4255444d413668699e271b0f3e0f010f74509c022d410c1d1b71673e137859e4'
    };
    var body = {'post_id': id};

    final res = await HttpService.postRequest(
        url: addArchiveUrl, body: body, context: context, headers: headers);

    if (res["status"] == "success") {
      return true;
    } else {
      return false;
    }
  }
}
