import 'package:flutter/cupertino.dart';
import 'package:union_up/App/Task/Model/group_model.dart';
import 'package:union_up/App/Task/Model/task_detail_model.dart';
import 'package:union_up/Config/shared_prif.dart';

import '../../../Common/app_urls.dart';
import '../../../Utils/http_network.dart';
import '../Model/task_model.dart';
import '../View/task_screen.dart';

class TaskApi {
  Future<List<TaskListModel>?> taskListing(
    BuildContext context, int page,
  ) async {
    try {
      print("start issue list");

      var headers = {
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };

      final parse = await HttpService.getWithHeaderRequest(
          url: "$taskListingUrl?page=$page&per_page=10", context: context, headers: headers);

      if (parse == null) {
        return null;
      }

      List a = parse as List;

      return a
          .map(
            (e) => TaskListModel.fromJson(e),
          )
          .toList();

      // IssueModel.fromJson(a as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<bool?> addTask(BuildContext context, AddTaskModel data) async {
    try {
      print("start issue list");

      var token = SharedStorage.localStorage?.getString(SharedStorage.token);
      var headers = {
        'Authorization': 'Bearer $token',
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };
      var body = {
        'task_title': data.taskTitle,
        'description': data.description,
        'priority': data.priority,
        'status': data.status,
        'due_date': data.dueDate,
        'assigne_user[]': data.assignUser?.join(','),
        'assigne_group[]': data.assignGroup?.join(',')
      };

      print(body);
      final parse = await HttpService.postRequest(
          url: addTaskUrl, context: context, headers: headers, body: body);

      if (parse['status'] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<TaskDetailModel?> taskDetail(BuildContext context, String id) async {
    try {
      print("start issue list");

      var token = SharedStorage.localStorage?.getString(SharedStorage.token);
      var headers = {
        'Authorization': 'Bearer $token',
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };
      print("id===>>>>$id");
      var body = {
        'post_id': id,
      };

      final parse = await HttpService.postRequest(
          url: taskDetailUrl, context: context, headers: headers, body: body);

      if (parse['status'] == "success") {
        return TaskDetailModel.fromJson(parse);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

  Future<TaskGroupModel?> taskGroup(BuildContext context) async {
    try {
      var token = SharedStorage.localStorage?.getString(SharedStorage.token);
      var headers = {
        'Authorization': 'Bearer $token',
        'Cookie':
            'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };

      final parse = await HttpService.getWithHeaderRequest(
        url: taskGroupUrl,
        context: context,
        headers: headers,
      );

      if (parse['status'] == "success") {
        return TaskGroupModel.fromJson(parse);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }
}
