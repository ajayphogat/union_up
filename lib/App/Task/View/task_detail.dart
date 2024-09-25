import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Task/View/task_screen.dart';
import 'package:union_up/App/Task/ViewModel/controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Widget/app_text_field.dart';

import '../../../Common/app_colors.dart';
import '../../../Widget/app_button.dart';
import '../../Issue/Model/detail_comment_model.dart';
import '../../Issue/Model/report_assign_model.dart';
import '../../Issue/View/issue_detail_sceen.dart';
import '../Model/group_model.dart';

class TaskDetailScreen extends StatelessWidget {
  String id;

  TaskDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Consumer<TaskController>(
      builder: (context, controller, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            toolbarHeight: 90,
            leading: Row(
              children: [const SizedBox(width: 20,),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                const SizedBox(
                  width: 5,
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Task Details",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.black),
                  ),
                ),
              ],
            ),
            actions: [

              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                constraints: BoxConstraints(
                  maxWidth: width * .35,
                  minWidth: width * .15,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: const EdgeInsets.only(left: 10, bottom: 0),
                      child: InkWell(
                        onTap: () {
                          controller.editDetail(
                            controller.taskData?.dueDate ??"",
                            controller.taskData?.title ??"",
                            controller.taskData?.content ??"",
                            controller.taskData?.priority ??"",
                            controller.taskData?.assigneUser?.split(",") ??[],
                            controller.taskData?.assigneGroup?.split(",") ??[],


                          );

                          // Close the popup before showing the bottom sheet
                          Navigator.pop(context);

                          // Show the bottom sheet
                          _editModalBottomSheetMenu(context, width, controller);
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF444444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
              ),

              // Icon(
              //   Icons.more_horiz,
              //   color: AppColors.grey,
              // ),
              const SizedBox(width: 15),
            ],
            centerTitle: false,
            leadingWidth: 250,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20.0),
              child: Align(
                alignment: Alignment.center,
                child: TabBar(
                  dividerColor: AppColors.white,
                  tabAlignment: TabAlignment.fill,
                  isScrollable: false,
                  indicatorColor: AppColors.black,
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.grey,
                  indicatorWeight: 2.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  // labelPadding:  EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tabs: const [
                    Tab(
                      text: "Task Detail",
                    ),
                    Tab(text: "Activity"),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            width: width,
            color: AppColors.white,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    // height: MediaQuery.sizeOf(context).height*.68,
                    child: TabBarView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        taskDetailTab(context, controller, width),
                        activityTab(context, controller, width),
                      ],
                    ),
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AppTextFormWidget(
                      hintText: "Add a comment or update",
                      controller: controller.commentController,
                      maxLines: 3,
                      minLine: 2,
                      style: Theme.of(context).textTheme.bodyMedium,
                      focusNode: controller.commentFocusMode,
                      sufixIcon: GestureDetector(
                        onTap: () {
                          var data = AddIssueCommentModel(
                              comment: controller.commentController.text,
                              postId: id,
                              commentParentId: "",
                              commentImage: [],
                              commentDocs: []);

                          controller.updateFocusNode();
                          controller.addDetailComment(
                            context,
                            data,
                            (value) {
                              if (value == true) {}
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            sendMsgIcon,
                            width: 5,
                            height: 5,
                          ),
                        ),
                      ),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey),
                    ),
                  ),
                  const SizedBox(height: 15,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  taskDetailTab(BuildContext context, TaskController controller, double width) {
    return Container(
      color: AppColors.white,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Image.asset(
                      calenderIcon,
                      width: 20,
                      height: 20,
                    )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.grey),
                      ),
                      Text(
                        controller.taskData?.date ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.black),
                      ),
                      Divider(color: AppColors.grey),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              controller.taskData?.title ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 24),
            ),
            const SizedBox(
              height: 5,
            ),

            /// read more

            Text.rich(
              TextSpan(
                text: controller.isExpanded
                    ? controller.taskData?.content ?? ""
                    : (controller.taskData?.content != null &&
                                controller.taskData!.content!.length > 150
                            ? controller.taskData?.content?.substring(0, 150)
                            : controller.taskData?.content) ??
                        "",
                // Show first 100 characters or full if less
                children: [
                  if ((controller.taskData?.content?.length ?? 0) > 150)
                    TextSpan(
                      text: controller.isExpanded ? " Show less" : " Read more",
                      style: TextStyle(
                          color: controller.isExpanded
                              ? AppColors.red
                              : AppColors.green),
                      // Style for 'Read more' link
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          controller
                              .updateExpand(); // This should toggle isExpanded state in controller
                        },
                    ),
                ],
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.grey, fontSize: 16),
            ),

            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 45,
                  width: 130,
                  decoration: BoxDecoration(
                    color: AppColors.lightOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "In-Progress",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.orange),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Priority",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                priorityIconImage,
                                width: 20,
                                height: 20,
                              )),
                          const SizedBox(
                            width: 5,
                          ),

                          // Spacer(),

                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      controller.taskData?.priority == "high" ||
                                              controller.taskData?.priority ==
                                                  "High"
                                          ? highImage
                                          : controller.taskData?.priority ==
                                                  "Medium"
                                              ? mediumImage
                                              : lowImage,
                                      height: 10,
                                      width: 10,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      controller.taskData?.priority ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: controller.taskData
                                                              ?.priority ==
                                                          "high" ||
                                                      controller.taskData
                                                              ?.priority ==
                                                          "High"
                                                  ? AppColors.red
                                                  : controller.taskData
                                                              ?.priority ==
                                                          "Medium"
                                                      ? AppColors.orange
                                                      : AppColors.primary),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 8,),

                                Divider(
                                  color: AppColors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Due Date",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                calenderIcon,
                                width: 15,
                                height: 15,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.taskData?.dueDate ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.grey),
                                ),
                                Divider(
                                  color: AppColors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Assignee",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                userIconImage,
                                width: 15,
                                height: 15,
                              )),
                          // Icon(Icons.priority_high,
                          //     color: Colors.grey),
                          const SizedBox(
                            width: 5,
                          ),

                          // Spacer(),

                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showMultiSelectUserBottomSheet(context, controller);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${controller.taskData?.assigneDisplayName?.length} User",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: AppColors.grey),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: AppColors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Assignee Group",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                userIconImage,
                                width: 20,
                                height: 20,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if(controller.taskData!.assigneGroupName!.isNotEmpty) {
                                      _showMultiSelectGroupBottomSheet(
                                          context, controller);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${controller.taskData?.assigneGroupName?.length} Group",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.grey),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down_outlined)
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: AppColors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Row(
              children: [
                Image.asset(
                  visibilityImage,
                  width: 20,
                ),
                // Icon(Icons.visibility_rounded, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  "Visible to anyone involved in the Task",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  activityTab(BuildContext context, TaskController controller, double width) {
    return Container(
      color: AppColors.white,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 35,
              width: width,
              child: ListView.builder(
                itemCount: controller.list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var data = controller.list[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        controller.updateActivityIndex(
                            index); // Update selected index
                        // });
                      },
                      child: Container(
                        // width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: controller.selectedActivityIndex != index
                              ? AppColors.lightGrey
                              : AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Text(
                              data["title"],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: controller.selectedActivityIndex ==
                                    index
                                    ? AppColors
                                    .primary // Change to primary color if selected
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Visibility(
                  visible: controller.selectedActivityIndex == 0
                      ? controller.all.isNotEmpty
                      : controller.selectedActivityIndex == 1
                      ? controller.commentData.isNotEmpty
                      : controller.historyComment.isNotEmpty,
                  replacement: Container(
                    height: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Comment not found",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  child: ListView.builder(

                    itemCount: controller.selectedActivityIndex == 0
                        ? controller.all.length
                        : controller.selectedActivityIndex == 1
                        ? controller.commentData.length
                        : controller.historyComment.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var comment = controller.selectedActivityIndex == 0
                          ? controller.all[index]
                          : controller.selectedActivityIndex == 1
                          ? controller.commentData[index]
                          : controller.historyComment[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              CommentTreeWidget<CommentData, CommentData>(
                                comment,
                                comment.replies ?? [], // Limit replies shown
                                treeThemeData: const TreeThemeData(
                                  lineColor: Colors.grey,
                                  lineWidth: 2,
                                ),
                                avatarRoot: (context, data) => PreferredSize(
                                  preferredSize: const Size.fromRadius(18),
                                  child: CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(data.userImage ?? ''),
                                    radius: 18,
                                  ),
                                ),
                                avatarChild: (context, data) => PreferredSize(
                                  preferredSize: const Size.fromRadius(12),
                                  child: CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(data.userImage ?? ''),
                                    radius: 12,
                                  ),
                                ),
                                contentRoot: (context, data) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.commentAuthor ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.commentContent ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            'Like',
                                            style:
                                            TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(width: 15),
                                          GestureDetector(
                                            onTap: () {
                                              // Set the active reply index to this comment's index
                                              controller.activeReplyIndex = index;
                                              controller.updateFocusNode(); // Optional: To focus on the reply box
                                            },
                                            child: const Text(
                                              'Reply',
                                              style:
                                              TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            // controller.convertDate(data.commentDate ?? ""),
                                            data.commentDate ?? "",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                contentChild: (context, data) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.commentAuthor ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        data.commentContent ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 10,),
                              // show only for index where i want reply
                              if (controller.activeReplyIndex == index)
                                AppTextFormWidget(
                                  // height: 40,
                                  hintText: "Enter your message",
                                  controller: controller.replyCommentController,
                                  fillColor: AppColors.lightGrey,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  hintStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                                  sufixIcon: GestureDetector(
                                    onTap: () {
                                      var data = AddIssueCommentModel(
                                          comment: controller.replyCommentController.text,
                                          postId: id,
                                          commentParentId: comment.id,
                                          commentImage:
                                          [],
                                          commentDocs: []);

                                      controller.updateFocusNode();
                                      controller.addDetailComment(
                                        context,
                                        data,
                                            (value) {
                                          if (value == true) {
                                            controller.replyCommentController.clear();
                                            controller.activeReplyIndex = null;
                                          }
                                        },
                                      );
                                    },
                                    child:  Padding(
                                      padding: const EdgeInsets.only(right: 24.0),
                                      child: Image.asset(
                                        sendMsgIcon,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                )

                            ],
                          ),
                        ),
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _showMultiSelectUserBottomSheet(BuildContext context, TaskController provider) {
    // Start with the full list of users
    List<String> filteredItems = List.from(provider.taskData?.assigneDisplayName ?? []);

    // TextEditingController to track search input
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Makes the bottom sheet expand based on content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Function to filter users based on search query
            void _filterUsers(String query) {
              setState(() {
                filteredItems = provider.taskData?.assigneDisplayName
                    ?.where((user) => user.toLowerCase().contains(query.toLowerCase()))
                    ?.toList() ?? [];
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10, // Adjust for keyboard
                top: 10.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height*.8,
                    minHeight: MediaQuery.sizeOf(context).height*.2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make the bottom sheet fit its content
                  children: <Widget>[
                    // Title for the bottom sheet
                    Text(
                      "Selected User",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      onChanged: _filterUsers, // Call the filter function on input change
                    ),
                    const SizedBox(height: 10),

                    // List of filtered users with checkboxes
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*.6),
                      child: ListView(
                        shrinkWrap: true,
                        children: filteredItems.map((category) {
                          return CheckboxListTile(
                            activeColor: AppColors.primary,
                            value: provider.assigneeUserList.contains(category.toString()),
                            title: Text(category ?? ""),
                            onChanged: (bool? value) {
                              // setState(() {
                              //   if (value == true) {
                              //     provider.assigneeUserList.add(category.toString());
                              //   } else {
                              //     provider.assigneeUserList.remove(category.toString());
                              //   }
                              // });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // Close button at the bottom of the bottom sheet
                    TextButton(
                      child: Text(
                        "Close",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _showMultiSelectGroupBottomSheet(BuildContext context, TaskController provider) {
    List<String> filteredItems = List.from(provider.taskData?.assigneGroupName ?? []);

    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Makes the bottom sheet expand based on content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Function to filter groups based on search query
            void _filterGroups(String query) {
              setState(() {
                filteredItems = provider.taskData?.assigneGroupName
                    ?.where((group) => group.toLowerCase().contains(query.toLowerCase())).toList() ?? [];
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10, // Adjust for keyboard
                top: 10.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height*.8,
                  minHeight: MediaQuery.sizeOf(context).height*.2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make the bottom sheet fit its content
                  children: <Widget>[
                    // Title for the bottom sheet
                    Text(
                      "Selected Group",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextField(
                      controller: searchController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      onChanged: _filterGroups, // Call the filter function on input change
                    ),
                    const SizedBox(height: 10),

                    // List of filtered groups with checkboxes
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*.6),

                      child: ListView(
                        shrinkWrap: true,
                        children: filteredItems.map((category) {
                          return CheckboxListTile(
                            activeColor: AppColors.primary,
                            value: provider.assigneeGroupList.contains(category.toString()),
                            title: Text(category ?? ""),
                            onChanged: (bool? value) {
                              // setState(() {
                              //   if (value == true) {
                              //     provider.assigneeGroupList.add(category.toString());
                              //   } else {
                              //     provider.assigneeGroupList.remove(category.toString());
                              //   }
                              // });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // Close button at the bottom of the bottom sheet
                    TextButton(
                      child: Text(
                        "Close",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _editModalBottomSheetMenu(
      BuildContext context, width, TaskController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.white,
        context: context,
        builder: (builder) {
          return Consumer<TaskController>(
            builder: (context, read, child) => StatefulBuilder(
              builder: (context, setState) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.9, // Max height 80% of screen height
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: read.createTaskKey,
                    child: Container(
                        width: width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // Container(
                                //   height: 6,
                                //   width: 60,
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey[300],
                                //     borderRadius: BorderRadius.circular(2),
                                //   ),
                                // ),
                                // const SizedBox(height: 20),
                                const Text(
                                  "Edit Task",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Title and description text fields
                                AppTextFormWidget(
                                  hintText: "Tap to add title...",
                                  controller: read.editTitleController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  hintStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Task Title is required';
                                    }
                                    return null; // Return null if validation passes
                                  },

                                  onChanged: (p0) {

                                  },
                                ),
                                AppTextFormWidget(
                                  hintText: "Tap to add a description...",
                                  controller: read.editDescriptionController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontSize: 18,
                                  ),
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Task Description is required';
                                    }
                                    return null; // Return null if validation passes
                                  },
                                ),
                                const SizedBox(height: 20),

                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Priority",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppColors.grey),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 7,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Image.asset(
                                                  priorityIconImage,
                                                  width: 25,
                                                  height: 30,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    DropdownButtonFormField(
                                                      items: [
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: null,
                                                          // Default "Choose" option with null value
                                                          child: Text(
                                                            "Choose",
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                color: AppColors
                                                                    .grey),
                                                          ),
                                                        ),
                                                        ...controller
                                                            .priorityList
                                                            .map((category) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value:
                                                            category["name"]
                                                                .toString(),
                                                            // Ensure this is a String too
                                                            child: Row(
                                                              children: <Widget>[
                                                                Image.asset(
                                                                  category[
                                                                  'img'],
                                                                  height: 15,
                                                                  width: 15,
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  category[
                                                                  "name"],
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .titleMedium
                                                                      ?.copyWith(
                                                                      color:
                                                                      category['color']),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList()
                                                      ],
                                                      onChanged: (newValue) {
                                                        controller.setPriorityDetail(
                                                            newValue);

                                                      },
                                                      value: controller
                                                          .selectedPriorityDetail,
                                                      icon: Icon(
                                                        Icons.keyboard_arrow_down, // You can change this icon to whatever you want
                                                        color: AppColors.grey, // Set the color of the icon
                                                      ),
                                                      decoration:
                                                      const InputDecoration(
                                                        contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 5),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                        InputBorder.none,
                                                        // Remove underline
                                                        enabledBorder:
                                                        InputBorder.none,
                                                        // Remove underline for enabled state
                                                        focusedBorder: InputBorder
                                                            .none, // Remove underline for focused state
                                                      ),
                                                    ),

                                                    Divider(
                                                      color: AppColors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Due Date",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppColors.grey),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 7,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Image.asset(
                                                  calenderIcon,
                                                  width: 25,
                                                  height: 30,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                // width: 180,
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    AppTextFormWidget(
                                                      // height: 35,
                                                        hintText: "Due Date",
                                                        onTap: () {
                                                          read.selectDate(
                                                              context);
                                                        },
                                                        // enable: false,
                                                        readOnly: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                            color: AppColors
                                                                .grey),
                                                        controller: controller
                                                            .editDateToController,
                                                        // validator: (value) {
                                                        //   if (value!.isEmpty) {
                                                        //     return "Please Select a due date";
                                                        //   }
                                                        //   return null;
                                                        // },
                                                        hintStyle: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                            color: Colors
                                                                .grey)),
                                                    Divider(
                                                      color: AppColors.grey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),

                                ///Assign
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Assignees",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppColors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Image.asset(
                                                userIconImage,
                                                // Ensure this path is correct
                                                width: 25,
                                                height: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [

                                                  AppTextFormWidget(
                                                    readOnly: true,
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) =>
                                                            AlertDialog(
                                                              title: Text(
                                                                'Select User/Group',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .titleLarge,
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                MainAxisSize.min,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      _editShowMultiSelectUsersBottomSheet(
                                                                          context,
                                                                          controller);
                                                                    },
                                                                    child: Container(
                                                                      height: 50,
                                                                      width: 200,
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: AppColors
                                                                                  .primary),
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              10)),
                                                                      child: const Center(
                                                                          child: Text(
                                                                              "User")),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);


                                                                      _editShowMultiSelectGroupBottomSheet(
                                                                          context,
                                                                          controller);
                                                                    },
                                                                    child: Container(
                                                                      height: 50,
                                                                      width: 200,
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: AppColors
                                                                                  .primary),
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              10)),
                                                                      child: const Center(
                                                                          child: Text(
                                                                              "Group")),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                      );
                                                    },
                                                    hintText: controller.selectedReports
                                                        .isEmpty &&
                                                        controller
                                                            .selectedReportsId
                                                            .isEmpty
                                                        ? "Assign to"
                                                        : "${controller.selectedReportsUser.isEmpty ? "" : "${controller.selectedReportsUser.length} User"} ${controller.editSelectedReportsIdGroup.isEmpty ? "" : "${controller.editSelectedReportsIdGroup.length} Group"}",

                                                    controller: read.assigneeController,
                                                    sufixIcon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      color:
                                                      AppColors.grey,
                                                    ),
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        color: AppColors
                                                            .grey),
                                                    hintStyle:  Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        color: AppColors
                                                            .grey),
                                                  ),

                                                  // if (controller.isValid ==
                                                  //         true &&
                                                  //     controller
                                                  //         .selectedReports
                                                  //         .isEmpty &&
                                                  //     controller
                                                  //         .selectedReportsId
                                                  //         .isEmpty)
                                                  //   Padding(
                                                  //     padding: const EdgeInsets.only(left: 8.0),
                                                  //     child: Text(
                                                  //       "Please select a User or Group",
                                                  //       style: Theme.of(context)
                                                  //           .textTheme
                                                  //           .labelSmall
                                                  //           ?.copyWith(
                                                  //               color: AppColors
                                                  //                   .red),
                                                  //     ),
                                                  //   ),
                                                  Divider(
                                                    color: AppColors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Status",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppColors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              progressIcon,
                                              // Ensure this path is correct
                                              width: 25,
                                              height: 30,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "InProgress",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                        color:
                                                        AppColors.grey),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    color: AppColors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),
                                // Visibility toggle row
                                Row(
                                  children: [
                                    Image.asset(
                                      visibilityImage,
                                      width: 25,
                                    ),
                                    // Icon(Icons.visibility_rounded, color: Colors.grey),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Visible to anyone involved in the Task",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                          color: AppColors.grey,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Buttons row
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: AppButton(
                                          radius: 8,
                                          height: 50,
                                          bgColor: AppColors.grey,
                                          title: "CANCEL",
                                          onTap: () {

                                            Navigator.pop(context);
                                          },
                                        )),
                                    const SizedBox(width: 20),
                                    Expanded(
                                        child: AppButton(
                                            radius: 8,
                                            height: 50,
                                            bgColor: AppColors.primary,
                                            title: "CREATE",
                                            onTap: () async {



                                                final data = AddTaskModel(
                                                    taskTitle:
                                                    read.titleController.text,
                                                    description:
                                                    read.descriptionController.text,
                                                    priority:
                                                    controller.selectedPriority ??
                                                        "",
                                                    dueDate: controller
                                                        .dateToController.text,
                                                    assignUser:
                                                    controller.selectedReports ??
                                                        [],
                                                    assignGroup:
                                                    controller.selectedReportsId,
                                                    status: "In-Progress");

                                                read.addTaskList(context, data,
                                                      (value) {
                                                    if (value == true) {
                                                      read.titleController.clear();
                                                      read.descriptionController
                                                          .clear();
                                                      controller.selectedPriority =
                                                      null;
                                                      controller.dateToController
                                                          .clear();
                                                      controller.selectedReports
                                                          .clear();
                                                      controller.selectedReportsId
                                                          .clear();
                                                      controller.selectedDate = DateTime.now();

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                );
                                              }
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _editShowMultiSelectUsersBottomSheet(BuildContext context, TaskController provider) {
    TextEditingController searchController = TextEditingController();
    List<AssignReport> filteredItems = List.from(provider.assignReport);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Makes the bottom sheet expand based on content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Function to filter items based on search query
            void _filterItems(String query) {
              setState(() {
                filteredItems = provider.assignReport.where((category) {
                  return category.displayName!
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10, // Adjust for keyboard
                top: 10.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*.8),
                child: Column(
                  // physics: NeverScrollableScrollPhysics(),
                  mainAxisSize: MainAxisSize.min, // Make the bottom sheet fit its content
                  children: <Widget>[
                    // Title for the bottom sheet
                    Text(
                      "Assign to",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextField(
                      controller: searchController,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.primary),
                      decoration: InputDecoration(
                        hintText: 'Search User',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.primary),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => _filterItems(value),
                    ),
                    const SizedBox(height: 10),

                    // Filtered List with checkboxes
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: filteredItems.map((category) {
                          return CheckboxListTile(
                            activeColor: AppColors.primary,
                            value: provider.selectedReportsUser
                                .contains(category.id.toString()),
                            title: Row(
                              children: <Widget>[
                                Image.network(
                                  category.image ?? "",
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.fitWidth,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    category.displayName ?? "",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                provider.toggleReportSelectionDetail(category.id.toString());
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // Close button at the bottom of the bottom sheet
                    TextButton(
                      child: Text(
                        "Close",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _editShowMultiSelectGroupBottomSheet(
      BuildContext context, TaskController provider) {
    TextEditingController searchController = TextEditingController();
    List<TaskGroupData> filteredItems = List.from(provider.groupList);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Makes the bottom sheet expand based on content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Function to filter items based on search query
            void _filterItems(String query) {
              setState(() {
                filteredItems = provider.groupList.where((category) {
                  return category.name!
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10, // Adjust for keyboard
                top: 10.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height*.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make the bottom sheet fit its content
                  children: <Widget>[
                    // Title for the bottom sheet
                    Text(
                      "Assign to Group",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextField(
                      controller: searchController,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.primary),
                      decoration: InputDecoration(
                        hintText: 'Search Group',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.primary),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => _filterItems(value),
                    ),
                    const SizedBox(height: 10),

                    // Filtered List with checkboxes
                    Expanded(
                      child: ListView(
                        children: filteredItems.map((category) {
                          return CheckboxListTile(
                            activeColor: AppColors.primary,
                            value: provider.editSelectedReportsIdGroup
                                .contains(category.id),
                            title: Text(category.name ?? ""),
                            onChanged: (bool? value) {
                              setState(() {
                                provider.toggleReportSelection1Detail(
                                    category.id.toString());
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // Close button at the bottom of the bottom sheet
                    TextButton(
                      child: Text(
                        "Close",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
