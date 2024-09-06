import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Issue/ViewModel/issue_controller.dart';
import 'package:union_up/App/Task/ViewModel/controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Widget/app_text_field.dart';

import '../../../Common/app_colors.dart';
import '../../Issue/View/issue_detail_sceen.dart';

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

          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
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
                    "Task Detail",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.black),
                  ),
                ),
              ],
            ),
            centerTitle: false,
            leadingWidth: 150,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        physics: AlwaysScrollableScrollPhysics(),
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
                                commentImage: "",
                                commentDocs: "");

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
                    SizedBox(height: 15,)
                  ],
                ),
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
                                    _showMultiSelectuser(context, controller);
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
                                            "Assignee User",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: AppColors.grey),
                                          ),
                                        ],
                                      ),
                                      Icon(
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
                                    _showMultiSelectGroup(context, controller);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Assignee Group",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.grey),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_outlined)
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
    return Expanded(
      child: Container(
        color: AppColors.white,
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
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
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                child: ListView.builder(
                  itemCount: controller.selectedActivityIndex == 0
                      ? controller.all.length
                      : controller.selectedActivityIndex == 1
                          ? controller.commentData.length
                          : controller.historyComment.length,
                  // itemCount: 4,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var comment = controller.selectedActivityIndex == 0
                        ? controller.all[index]
                        : controller.selectedActivityIndex == 1
                            ? controller.commentData[index]
                            : controller.historyComment[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          comment.userImage != ""
                                              ? comment.userImage ?? ""
                                              : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8f5l8yq2MvvdIp9t88gx92Gtv_3i4tLxFcQ&s",
                                          fit: BoxFit.cover,
                                          width: 35,
                                          height: 35,
                                        ))),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.commentAuthor ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(comment.commentDate ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(color: AppColors.black)),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //     flex: 1,
                                //     child: GestureDetector(
                                //         onTap: () {
                                //
                                //         },
                                //         child: Icon(Icons.thumb_up_alt_outlined, )))
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              comment.commentContent ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: AppColors.grey),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showMultiSelectuser(
    BuildContext context,
    TaskController provider,
  ) {
    List<String> filteredItems =
        List.from(provider.taskData?.assigneDisplayName ?? []);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Selected User",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListBody(
                      children: filteredItems.map((category) {
                        return CheckboxListTile(
                          activeColor: AppColors.primary,
                          value: provider.assigneeUserList
                              .contains(category.toString()),
                          title: Text(category ?? ""),
                          onChanged: (bool? value) {
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
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
        );
      },
    );
  }

  void _showMultiSelectGroup(
    BuildContext context,
    TaskController provider,
  ) {
    List<String> filteredItems =
        List.from(provider.taskData?.assigneGroupName ?? []);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Selected Group",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListBody(
                      children: filteredItems.map((category) {
                        return CheckboxListTile(
                          activeColor: AppColors.primary,
                          value: provider.assigneeGroupList
                              .contains(category.toString()),
                          title: Text(category ?? ""),
                          onChanged: (bool? value) {
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
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
        );
      },
    );
  }
}
