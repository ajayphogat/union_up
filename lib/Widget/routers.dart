import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_up/App/Bottom/View/bottom_bar_screen.dart';

import '../App/Dispute/View/dispute_screen.dart';
import '../App/Feed/View/all_comment_screen.dart';
import '../App/Home/View/all_group_event_screen.dart';
import '../App/Home/View/all_task_screen.dart';
import '../App/Issue/Model/issue_model.dart';
import '../App/Issue/View/issue_detail_sceen.dart';
import '../App/Task/View/task_detail.dart';



void openBottomScreen(BuildContext context) {
  openScreenAsPlatformWiseRoute(context, const BottomBarScreen(index: 0,));
}


void openIssueDetail(BuildContext context,String id) {
  openScreenAsPlatformWiseRoute(context,  IssueDetailSceen(id:id));
}

void openTaskDetail(BuildContext context,String id) {
  openScreenAsPlatformWiseRoute(context,  TaskDetailScreen(id: id,));
}

void openAllTaskScreen(BuildContext context) {
  openScreenAsPlatformWiseRoute(context,  AllTaskScreen());
}
void openAllGroupEventScreen(BuildContext context,list,title) {
  openScreenAsPlatformWiseRoute(context,  AllGroupEventScreen(list:list ,title: title,));
}

void openAllCommentScreen(BuildContext context) {
  openScreenAsPlatformWiseRoute(context,  const AllCommentScreen());
}

void openDisputeScreen(BuildContext context) {
  openScreenAsPlatformWiseRoute(context,  const DisputeScreen());
}




void openScreenAsPlatformWiseRoute(BuildContext context, Widget targetWidget,
    {bool isFullScreen = false}) async =>
    await Platform.isIOS
        ? Navigator.push(context,CupertinoPageRoute(
        builder: (BuildContext context) => targetWidget,
        fullscreenDialog: isFullScreen))
        : Navigator.push(context, MaterialPageRoute(builder: (context) => targetWidget,
    fullscreenDialog: isFullScreen));

