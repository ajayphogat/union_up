import 'dart:convert';
import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:union_up/Common/app_colors.dart';
import 'package:union_up/Widget/app_button.dart';
import 'package:union_up/Widget/app_text_field.dart';
import 'package:union_up/Widget/routers.dart';
import 'package:video_player/video_player.dart';

import '../../../Common/image_path.dart';
import '../Model/issue_category_model.dart';
import '../Model/report_assign_model.dart';
import '../ViewModel/issue_controller.dart';

class IssueScreen extends StatelessWidget {
  IssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Consumer<IssueController>(
      builder: (context, controller, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Text(
              "Issue",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.black),
            ),
            leadingWidth: 80,
            actions: [
              Icon(
                Icons.search,
                color: AppColors.grey,
              ),
              const SizedBox(width: 15),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  dividerColor: AppColors.white,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: AppColors.black,
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.grey,
                  indicatorWeight: 2.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  // labelPadding:  EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tabs: const [
                    Tab(text: "Issue"),
                    Tab(text: "Archive"),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                RefreshIndicator(
                    onRefresh: () {
                      return controller.getIssueList(context);
                    },
                    child: firstTab(context, controller, width)),
                secondTab(context, controller)
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              if (controller.categoryList.isEmpty) {
                controller.getCategory(context);
              }
              controller.updateGroupValue(1,false);
              controller.updateGroupValue(2,false);
              controller.updateGroupValue(3,false);
              controller.dateToController.clear();
              controller.titleController.clear();
              controller.descriptionController
                  .clear();
              controller.locationController.clear();
              controller.firstAnswerController
                  .clear();
              controller.secondAnswerController
                  .clear();
              controller.selectedIssueStatus = "Open";
              controller.selectedCategory = null;
              controller.selectedCategoryId = null;
              controller.selectedCountryId = null;
              controller.selectedReportIs =
              null;
              controller.selectedPriority =
              null;
              controller.selectedReportId = "";
              controller.selectedReportsId = [];
              controller.videoFile = null;
              controller.images = [];
              controller.files = [];
              _modalBottomSheetMenu(context, width);
            },
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.add,
              color: AppColors.white,
            ), // Adjust color accordingly
          ),
        ),
      ),
    );
  }

  Widget firstTab(
      BuildContext context, IssueController controller, double width) {
    return Visibility(
      visible: !controller.taskLoad,
      replacement: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      child: Visibility(
        visible: controller.issueList.isNotEmpty,
        replacement: Center(
          child: Text("No Issue found",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 35,
                width: width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        filterDialogWithCategory(context, controller, width);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  "Category",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.grey,
                                      ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.keyboard_arrow_down_outlined)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  if (!controller.isFetching) {
                    controller.setValue(true, true);
                    controller.setPage();
                    controller.getIssueList(context);

                    Future.delayed(const Duration(seconds: 1))
                        .then((value) => controller.setValue(false, false));

                    print("isLoading");
                  }
                }
                return false;
              },
              child: Expanded(
                child: ListView.builder(
                  itemCount: controller.issueList.length,
                  itemBuilder: (context, index) {
                    var issue = controller.issueList[index];
                    return Dismissible(
                      key: Key(issue.id.toString()),
                      // Unique key for each item
                      direction: DismissDirection.endToStart,
                      // Enable swipe from right to left
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: Colors.red, // Background color when swiped
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.archive, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Archive',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        // Ask for confirmation before dismissing the item
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Archive Issue",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              content: Text(
                                "Are you sure you want to archive this issue?",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    "Cancel",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: AppColors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.archiveIssue(
                                        context, issue.id.toString(), (value) {
                                      if (value == true) {
                                        // Remove the issue from the list in the controller
                                        controller.removeIssue(index);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Issue archive added successfully'),
                                        ));
                                      }
                                    });
                                  },
                                  child: Text(
                                    "Archive",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        // This will be handled by the archiveIssue callback
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, right: 10, left: 10),
                        child: ListTile(
                          onTap: () {
                            controller.getIssueDetail(
                                context, issue.id.toString(), (value) {
                              if (value == true) {
                                openIssueDetail(context, issue.id.toString());
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          title: Text(
                            issue.title?.rendered ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.black),
                            maxLines: 2,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                controller.dayDiff(issue.date) == 0
                                    ? "Today"
                                    : "${controller.dayDiff(issue.date)} Days ago",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: AppColors.grey),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                issue.issuePriority == "High"
                                    ? highImage
                                    : issue.issuePriority == "Medium"
                                        ? mediumImage
                                        : lowImage,
                                height: 12,
                                width: 12,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                issue.issuePriority ?? "Low",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: issue.issuePriority == "High"
                                      ? AppColors.red
                                      : issue.issuePriority == "Medium"
                                          ? AppColors.orange
                                          : AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 70,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: issue.issueStatus != "1"
                                      ? AppColors.lightRed
                                      : AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Center(
                                    child: Text(
                                      issue.issueStatus != "1"
                                          ? "Open"
                                          : "Resolve",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              color: issue.issueStatus != "1"
                                                  ? AppColors.red
                                                  : AppColors.green),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (controller.isFetching)
              Container(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  )),
            if (controller.isFetching)
              const SizedBox(
                height: 50,
              )
          ],
        ),
      ),
    );
  }

  Widget secondTab(BuildContext context, IssueController controller) {
    return Visibility(
      visible: controller.archiveList.isNotEmpty,
      replacement: Center(
        child: Text("No Archive found",
            style: Theme.of(context).textTheme.titleLarge),
      ),
      child: ListView.builder(
        itemCount: controller.archiveList.length,
        itemBuilder: (context, index) {
          var issue = controller.archiveList[index];
          return Dismissible(
            key: Key(issue.id.toString()),
            // Unique key for each item
            direction: DismissDirection.endToStart,
            // Enable swipe from right to left
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: Colors.green, // Background color when swiped
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.archive, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Un-Archive',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              // Ask for confirmation before dismissing the item
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "UnArchive Issue",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    content: Text(
                      "Are you sure you want to unarchive this issue?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          "Cancel",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          "UnArchive",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              // Handle archive action
              // controller.archiveIssue(issue.id);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Issue unarchived'),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 10, left: 10),
              child: ListTile(
                tileColor: AppColors.white,
                onTap: () {
                  controller.getIssueDetail(context, issue.id.toString(),
                      (value) {
                    if (value == true) {
                      openIssueDetail(context, issue.id.toString());
                    }
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Text(
                  issue.title?.rendered ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.black),
                  maxLines: 2,
                ),
                subtitle: Row(
                  children: [
                    Text(
                      controller.dayDiff(issue.date) == 0
                          ? "Today"
                          : "${controller.dayDiff(issue.date)} Days ago",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      issue.issuePriority == "High"
                          ? highImage
                          : issue.issuePriority == "Medium"
                              ? mediumImage
                              : lowImage,
                      height: 12,
                      width: 12,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      issue.issuePriority ?? "Low",
                      style: TextStyle(
                          fontSize: 12,
                          color: issue.issuePriority == "High"
                              ? AppColors.red
                              : issue.issuePriority == "Medium"
                                  ? AppColors.orange
                                  : AppColors.primary),
                    ),
                    const Spacer(),
                    Container(
                      width: 70,
                      height: 24,
                      decoration: BoxDecoration(
                        color: issue.issueStatus != "1"
                            ? AppColors.lightRed
                            : AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: Text(
                            issue.issueStatus != "1" ? "Open" : "Resolve",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: issue.issueStatus != "1"
                                        ? AppColors.red
                                        : AppColors.green),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _modalBottomSheetMenu(
    BuildContext context,
    width,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Consumer<IssueController>(
            builder: (context, read, child) => StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "New Issue",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Date picker row
                            GestureDetector(
                              onTap: () {
                                read.selectDate(context);
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        read.dateToController.text.isNotEmpty
                                            ? read.dateToController.text
                                            : "Enter date        ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Divider(
                              color: AppColors.grey,
                              indent: 30,
                            ),
                            if (read.isIssue == 1 &&
                                read.dateToController.text.isEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 28.0),
                                  child: Text(
                                    "* Please select a date",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: AppColors.red),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            // Category picker row

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.list, color: Colors.grey),
                                // Prefix icon
                                const SizedBox(width: 10),
                                //
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    value: read.selectedCountryId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                    iconStyleData: IconStyleData(
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      iconSize: 30,
                                      iconEnabledColor: AppColors.black,
                                    ),
                                    isExpanded: true,
                                    hint: Text(
                                      "Category",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                    items: [
                                      ...read.categoryList
                                          .map((e) => DropdownMenuItem(
                                                value: e.id.toString(),
                                                child: SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  child: Text(
                                                      e.issueCategoryName ?? "",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey)),
                                                ),
                                                onTap: () {
                                                  // Navigator.pop(context);
                                                  read.setCategoryName(e.id,
                                                      e.issueCategoryName, e);
                                                },
                                              ))
                                          .toList(),
                                    ],
                                    onChanged: (String? value) {
                                      read.setCategory(value);
                                    },
                                    menuItemStyleData:
                                        const MenuItemStyleData(height: 35),
                                    buttonStyleData: ButtonStyleData(
                                      height: 30,
                                      width: width * .8,
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: AppColors.white,
                                      ),
                                      elevation: 0,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight:
                                          MediaQuery.sizeOf(context).height *
                                              .8,
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                      ),
                                      offset: const Offset(-10, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness: WidgetStateProperty.all(6),
                                        thumbVisibility:
                                            WidgetStateProperty.all(true),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColors.grey,
                              indent: 30,
                            ),
                            if (read.isIssue == 2 &&
                                read.selectedCountryId == null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 28.0),
                                  child: Text(
                                    "*Please select a category",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: AppColors.red),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),
                            // Visibility toggle row
                            Row(
                              children: [
                                Image.asset(
                                  visibilityImage,
                                  width: 20,
                                ),
                                // Icon(Icons.visibility_rounded, color: Colors.grey),
                                const SizedBox(width: 10),
                                Text(
                                  "Visible to anyone involved in the Issue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.grey,
                                          fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            // Buttons row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: AppButton(
                                  bgColor: AppColors.grey,
                                  radius: 8,
                                  height: 45,
                                  title: "CANCEL",
                                  onTap: () {
                                    read.dateToController.clear();
                                    read.selectedCountryId = null;
                                    Navigator.pop(context);
                                  },
                                )),
                                const SizedBox(width: 20),
                                Expanded(
                                    child: AppButton(
                                  bgColor: AppColors.primary,
                                  radius: 8,
                                  height: 45,
                                  title: "NEXT",
                                  onTap: () {
                                    if (read.dateToController.text.isEmpty) {
                                      read.updateIssueT(1);

                                    } else if (read.selectedCountryId == null) {
                                      read.updateIssueT(2);

                                    } else {
                                      read.updateIssueT(0);
                                      Navigator.pop(context);
                                      modalBottomSheetMenu(
                                          context, width, read);
                                    }
                                  },
                                )),
                              ],
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        });
  }

  void modalBottomSheetMenu(
      BuildContext context, width, IssueController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Consumer<IssueController>(
            builder: (context, read, child) => StatefulBuilder(
              builder: (context, setState) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.9, // Max height 80% of screen height
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: read.issueAddFormKey,
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 6,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text("New Issue",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),

                                // Date picker row
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month,
                                        color: Colors.grey),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                        Text(
                                          read.dateToController.text.isNotEmpty
                                              ? read.dateToController.text
                                              : "Enter date        ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Title and description text fields
                                AppTextFormWidget(
                                  hintText: "Tap to add title...",
                                  controller: read.titleController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.black),
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty && value == "") {
                                      return "Please enter title";
                                    }
                                  },
                                ),
                                AppTextFormWidget(
                                  hintText: "Tap to add a description...",
                                  controller: read.descriptionController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 14,
                                      ),
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty && value == "") {
                                      return "Please enter description";
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),

                                // Open/Closed dropdown
                                Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              controller.selectedIssueStatus ==
                                                      "Open"
                                                  ? AppColors.lightGreen
                                                  : AppColors.lightRed),
                                      child: DropdownButtonFormField(
                                        itemHeight: 55,
                                        isExpanded: true,
                                        dropdownColor: Colors.white,
                                        elevation: 0,
                                        items:
                                            controller.status.map((category) {
                                          return DropdownMenuItem<String>(
                                            value: category["name"].toString(),
                                            child: Container(
                                              height: 45,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: category['color'],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  category["name"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color:
                                                            category['txt_clr'],
                                                      ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          controller
                                              .updateIssueStatus(newValue);
                                        },
                                        value: controller.selectedIssueStatus,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          // Remove the underline
                                          enabledBorder: InputBorder.none,
                                          // Remove the underline when not focused
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Category",
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
                                                    listIconImage,
                                                    width: 30,
                                                    height: 40,
                                                  )),
                                              // Icon(Icons.list, color: Colors.grey),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: Text(
                                                  read.selectedCategory
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              AppColors.grey),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),

                                ///Priority
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                              Image.asset(
                                                priorityIconImage,
                                                width: 25,
                                                height: 25,
                                              ),
                                              // Icon(Icons.priority_high,
                                              //     color: Colors.grey),
                                              const SizedBox(
                                                width: 5,
                                              ),

                                              // Spacer(),

                                              Expanded(
                                                // width: 180,
                                                child: Column(
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
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                          color:
                                                                              category['color']),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ],
                                                      onChanged: (newValue) {
                                                        controller.setPriority(
                                                            newValue);
                                                        controller
                                                            .updateGroupValue(
                                                                1, false);
                                                      },
                                                      value: controller
                                                              .selectedPriority ??
                                                          null,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 20, 10, 20),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            InputBorder.none,
                                                        // Remove underline
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        // Remove underline for enabled state
                                                        focusedBorder:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    if (controller
                                                                .isValidPriority ==
                                                            true &&
                                                        controller
                                                            .selectedReports
                                                            .isEmpty)
                                                      Text(
                                                        "Please select a priority",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .red),
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

                                ///location

                                if (read.selectedCategoryData?.hasAsterisk == 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Location",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: AppColors.grey),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 7,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  locationImage,
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  // width: 180,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      AppTextFormWidget(
                                                        hintText:
                                                            "Select Location",
                                                        controller: read
                                                            .locationController,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 14,
                                                            ),
                                                        sufixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Image.asset(
                                                            location2Image,
                                                            width: 35,
                                                            height: 35,
                                                          ),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        // validator: (value) {
                                                        //   if(value!.isEmpty && value==""){
                                                        //     return "Please enter Location";
                                                        //   }
                                                        // },
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

                                /// Question Answer
                                if (read.selectedCategoryData?.hasAsterisk == 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Question",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: AppColors.grey),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 7,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  questionMarkImage,
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  // width: 180,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "What needs to be done?",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      AppTextFormWidget(
                                                        hintText: "UnAnswered",
                                                        controller: read
                                                            .secondAnswerController,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 14,
                                                            ),
                                                        hintStyle:
                                                            const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        // validator: (value) {
                                                        //   if(value!.isEmpty && value==""){
                                                        //     return "Please enter Location";
                                                        //   }
                                                        // },
                                                      ),
                                                      Text(
                                                        "What caused it?",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      AppTextFormWidget(
                                                        hintText: "UnAnswered",
                                                        controller: read
                                                            .firstAnswerController,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 14,
                                                            ),
                                                        hintStyle:
                                                            const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        // validator: (value) {
                                                        //   if(value!.isEmpty && value==""){
                                                        //     return "Please enter Location";
                                                        //   }
                                                        // },
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Report to delegate",
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
                                                width: 25,
                                                height: 25,
                                              ),
                                            ),
                                            // const Icon(Icons.report, color: Colors.grey),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              flex: 8,
                                              // width: 180,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DropdownButtonFormField<
                                                      String>(
                                                    items: [
                                                      DropdownMenuItem<String>(
                                                        value: null,
                                                        // Default "Choose" option
                                                        child: Text(
                                                          "Choose",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey),
                                                        ),
                                                      ),
                                                      ...controller.assignReport
                                                          .map((category) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          onTap: () {
                                                            controller.setReportId(
                                                                category.id
                                                                    .toString());
                                                            // Navigator.pop(context);
                                                          },
                                                          value: category
                                                              .displayName
                                                              .toString(),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Image.network(
                                                                category.image ??
                                                                    "",
                                                                height: 15,
                                                                width: 15,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                category.displayName ??
                                                                    "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                        color: AppColors
                                                                            .grey),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                    ],
                                                    onChanged: (newValue) {
                                                      controller
                                                          .setReport(newValue);
                                                      controller
                                                          .updateGroupValue(2, false);
                                                    },
                                                    value: controller
                                                        .selectedReportIs,
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 20, 5, 20),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border: InputBorder.none,
                                                      // Remove underline
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      // Remove underline for enabled state
                                                      focusedBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                  if (controller.isValid == true)
                                                    Text(
                                                      "Please select a Delegate",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .red),
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

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Notify Safety Rep",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppColors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Image.asset(
                                                alertIconImage,
                                                // Ensure this path is correct
                                                width: 25,
                                                height: 25,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showMultiSelectAssignReport(
                                                          context, controller);
                                                    },
                                                    child: Container(
                                                        height: 40,
                                                        // width: 200,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .transparent)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            controller
                                                                    .selectedReports
                                                                    .isNotEmpty
                                                                ? AvatarStack(
                                                                    height:
                                                                        25.isFinite
                                                                            ? 25
                                                                            : 0,
                                                                    width: 160,
                                                                    settings:
                                                                        settings,
                                                                    avatars: [
                                                                      for (var n =
                                                                              0;
                                                                          n <
                                                                              controller.selectedReports.length;
                                                                          n++)
                                                                        NetworkImage(
                                                                            controller.selectedReports[n]),
                                                                    ],
                                                                    infoWidgetBuilder: (surplus) =>
                                                                        _infoWidget(
                                                                            surplus,
                                                                            context),
                                                                  )
                                                                : Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child: Text(
                                                                      "Select",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium
                                                                          ?.copyWith(
                                                                              color: AppColors.grey),
                                                                    )),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          8.0),
                                                              child: Icon(Icons
                                                                  .keyboard_arrow_down_outlined),
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                  if(controller.isValidNotify==true)
                                                    Text(
                                                      "Please select Notify safety rep",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                          color: AppColors
                                                              .red),
                                                    ),
                                                  const Divider()
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Attachment",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: AppColors.grey),
                                    )),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    // Add your attachment widget here
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text(
                                              'Choose Attachment',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge,
                                            ),
                                            actions: <Widget>[
                                              // TextButton(
                                              //   onPressed: () {
                                              //     controller.pickFile();
                                              //     Navigator.pop(context);
                                              //   },
                                              //   child: Text('File',
                                              //       style: Theme.of(context)
                                              //           .textTheme
                                              //           .titleLarge),
                                              // ),
                                              TextButton(
                                                onPressed: () async {
                                                  controller.pickImage(
                                                      ImageSource.gallery);
                                                  Navigator.pop(context);
                                                  // Get.back();
                                                },
                                                child: Text(
                                                  'Gallery',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  controller.pickVideo();
                                                  Navigator.pop(context);
                                                  // Get.back();
                                                },
                                                child: Text(
                                                  'Video',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.add,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Example attachment preview

                                    Container(
                                      height: 60,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          width: 4,
                                        ),
                                        itemCount: controller.images.length + controller.files.length + (controller.videoFile != null
                                                ? 1
                                                : 0),
                                        itemBuilder: (context, index) {
                                          if (index <
                                              controller.images.length) {
                                            final image =
                                                controller.images[index];
                                            return Stack(
                                              children: [
                                                Image.file(
                                                  image,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  right: -10,
                                                  top: -10,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.grey),
                                                    onPressed: () {
                                                      setState(() {
                                                        controller.images
                                                            .removeAt(index);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (index < controller.images.length + controller.files.length) {
                                            final fileIndex = index - controller.images.length;
                                            final file =
                                            controller.files[fileIndex];
                                            return Stack(
                                              children: [
                                                const Icon(
                                                  Icons.attach_file,
                                                  size: 60,
                                                  color: Colors.grey,
                                                ),
                                                Positioned(
                                                  right: -10,
                                                  top: -10,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.grey),
                                                    onPressed: () {
                                                      setState(() {
                                                        controller.files
                                                            .removeAt(
                                                                fileIndex);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Stack(
                                              children: [
                                                controller.videoLoader==true && controller.video != null?
                                                    CircularProgressIndicator(color: AppColors.primary,):
                                                AspectRatio(
                                                  aspectRatio: controller
                                                      .vController!
                                                      .value
                                                      .aspectRatio,
                                                  child: VideoPlayer(
                                                      controller.vController!),
                                                ),
                                                Positioned(
                                                  right: -10,
                                                  top: -10,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.grey),
                                                    onPressed: () {
                                                      setState(() {
                                                        controller.videoFile =
                                                            null;
                                                        controller.vController
                                                            ?.dispose();
                                                        controller.vController =
                                                            null;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

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
                                        read.dateToController.clear();
                                        read.titleController.clear();
                                        read.descriptionController
                                            .clear();
                                        read.locationController.clear();
                                        read.firstAnswerController
                                            .clear();
                                        read.secondAnswerController
                                            .clear();
                                        read.selectedIssueStatus = "Open";
                                        read.selectedCategory = null;
                                        read.selectedCategoryId = null;
                                        read.selectedCountryId = null;
                                        controller.selectedReportIs =
                                        null;
                                        controller.selectedPriority =
                                        null;
                                        controller.selectedReportId = "";
                                        controller.selectedReportsId = [];
                                        controller.videoFile = null;
                                        controller.images = [];
                                        controller.files = [];
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
                                      onTap: () {
                                        // print(jsonDecode('[{"question": "What needs to be done?",\n"answer": "all the best"},\n{"question": "What caused it?",\n "answer": "No idea"}\n]'));
                                        // print(jsonEncode('[{question: What needs to be done?, answer: all the best}, {question: What caused it?, answer: No idea}]'));

                                        print(
                                            "=-=-=099${controller.selectedPriority}");

                                        if (!read.issueAddFormKey.currentState!
                                            .validate()) {
                                          if (controller.selectedPriority ==
                                              null) {
                                            controller.updateGroupValue(
                                                1, true);
                                          }
                                          if (controller.selectedReportIs ==
                                              null) {
                                            controller.updateGroupValue(
                                                2, true);
                                          }
                                          if (controller
                                              .selectedReports.isEmpty) {
                                            controller.updateGroupValue(
                                                3, true);
                                          }
                                          return;
                                        }

                                        if (controller.selectedPriority ==
                                            null) {
                                          controller.updateGroupValue(1, true);
                                          return;
                                        }

                                        if (controller.selectedReportIs == null) {
                                          controller.updateGroupValue(2, true);
                                          return;
                                        }

                                        if (controller.selectedReports.isEmpty) {
                                          controller.updateGroupValue(3, true);
                                          return;
                                        }

                                        final data = AddIssueModel(
                                            date: read.dateToController.text,
                                            title: read.titleController.text,
                                            description:
                                                read.descriptionController.text,
                                            issueLocation:
                                                read.locationController.text,
                                            question1:
                                                read.firstAnswerController.text,
                                            question2: read
                                                .secondAnswerController.text,
                                            status:
                                                controller.selectedIssueStatus,
                                            category:
                                                read.selectedCategoryId ?? "",
                                            priority:
                                                controller.selectedPriority ??
                                                    "",
                                            reportIssue:
                                                controller.selectedReportId,
                                            notifyList:
                                                controller.selectedReportsId,
                                            video: controller.videoFile,
                                            images: controller.images,
                                            files: controller.files);
                                        print(jsonDecode(
                                            '[{"question": "What needs to be done?",\n"answer": "all the best"},\n{"question": "What caused it?",\n "answer": "No idea"}\n]'));

                                        controller.addIssue(
                                          context,
                                          data,
                                          (value) {
                                            if (value == true) {
                                              read.dateToController.clear();
                                              read.titleController.clear();
                                              read.descriptionController
                                                  .clear();
                                              read.locationController.clear();
                                              read.firstAnswerController
                                                  .clear();
                                              read.secondAnswerController
                                                  .clear();
                                              read.selectedIssueStatus = "Open";
                                              read.selectedCategory = null;
                                              read.selectedCategoryId = null;
                                              read.selectedCountryId = null;
                                              controller.selectedReportIs =
                                                  null;
                                              controller.selectedPriority =
                                                  null;
                                              controller.selectedReportId = "";
                                              controller.selectedReportsId = [];
                                              controller.videoFile = null;
                                              controller.images = [];
                                              controller.files = [];
                                              Navigator.pop(context);
                                            }
                                          },
                                        );
                                      },
                                    )),
                                  ],
                                ),
                                const SizedBox(height: 20),
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

  final settings = RestrictedPositions(
    maxCoverage: -0.1,
    minCoverage: -0.5,
    align: StackAlign.left,
  );

  Widget _infoWidget(int surplus, BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '+$surplus',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  void _showMultiSelectAssignReport(
      BuildContext context, IssueController provider) {
    TextEditingController searchController = TextEditingController();

    List<AssignReport> filteredItems = List.from(provider.assignReport);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select User",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
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

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Search TextField
                    TextField(
                      controller: searchController,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.primary),
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColors.primary),
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder()),
                      onChanged: (value) => _filterItems(value),
                    ),
                    const SizedBox(height: 10),
                    // Add spacing between the search field and list

                    // Filtered List
                    ListBody(
                      children: filteredItems.map((category) {
                        return CheckboxListTile(
                          activeColor: AppColors.primary,
                          value: provider.selectedReportsId.contains(category.id.toString()),
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
                              )),
                            ],
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              provider.toggleReportSelection(category.image.toString());
                              provider.toggleReportSelection1(category.id.toString());
                              provider.updateGroupValue(3, false);
                            });
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

  /// Filter Dialog
  void filterDialogWithCategory(
      BuildContext context, IssueController controller, double width) {
    TextEditingController searchController = TextEditingController();

    // Define a list to hold the filtered items
    List<CategoryData> filteredItems = List.from(controller.categoryList);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Consumer<IssueController>(
            builder: (context, read, child) => StatefulBuilder(
              builder: (context, setState) {
                // Initialize the checkbox states
                void _filterItems(String query) {
                  setState(() {
                    filteredItems = read.categoryList.where((category) {
                      return category.issueCategoryName!
                          .toLowerCase()
                          .contains(query.toLowerCase());
                    }).toList();
                  });
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: width * 1.8,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Category Filters",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: searchController,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.primary),
                            decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: AppColors.primary),
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder()),
                            onChanged: (value) => _filterItems(value),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "All Filters",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: AppColors.primary),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        value: read.checkboxStates[index],
                                        onChanged: (bool? value) {
                                          // Toggle the checkbox state
                                          setState(() {
                                            read.updateCheckBoxIndex(
                                                index, value!);

                                            if (value) {
                                              // Add category to filter list
                                              read.filterCategoryList.add(
                                                  read.categoryList[index]);
                                            } else {
                                              // Remove category from filter list
                                              read.filterCategoryList.remove(
                                                  read.categoryList[index]);
                                            }
                                            // print(read.filterCategoryList.length);
                                          });
                                        },
                                      ),
                                      Text(filteredItems[index]
                                              .issueCategoryName ??
                                          ""),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  void filterWithStatus(
      BuildContext context, IssueController controller, double width) {
    TextEditingController searchController = TextEditingController();

    // Define a list to hold the filtered items
    List<CategoryData> filteredItems = List.from(controller.categoryList);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Consumer<IssueController>(
            builder: (context, read, child) => StatefulBuilder(
              builder: (context, setState) {
                // Initialize the checkbox states
                void _filterItems(String query) {
                  setState(() {
                    filteredItems = read.categoryList.where((category) {
                      return category.issueCategoryName!
                          .toLowerCase()
                          .contains(query.toLowerCase());
                    }).toList();
                  });
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: width * 1.8,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Category Filters",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: searchController,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.primary),
                            decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: AppColors.primary),
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder()),
                            onChanged: (value) => _filterItems(value),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "All Filters",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: AppColors.primary),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        value: read.checkboxStates[index],
                                        onChanged: (bool? value) {
                                          // Toggle the checkbox state
                                          setState(() {
                                            read.updateCheckBoxIndex(
                                                index, value!);

                                            if (value) {
                                              // Add category to filter list
                                              read.filterCategoryList.add(
                                                  read.categoryList[index]);
                                            } else {
                                              // Remove category from filter list
                                              read.filterCategoryList.remove(
                                                  read.categoryList[index]);
                                            }
                                            // print(read.filterCategoryList.length);
                                          });
                                        },
                                      ),
                                      Text(filteredItems[index]
                                              .issueCategoryName ??
                                          ""),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

class AddIssueModel {
  String? date;
  String? title;
  String? description;
  String? status;

  String? issueLocation;
  String? question1;
  String? question2;
  String category;
  String? priority;

  // String? type;
  String? reportIssue;
  List<String> notifyList;
  List<File>? images;
  List<File>? files;
  File? video;

  AddIssueModel(
      {this.date,
      this.issueLocation,
      this.question1,
      this.question2,
      required this.category,
      this.description,
      this.priority,
      // this.type,
      this.title,
      this.status,
      this.reportIssue,
      required this.notifyList,
      this.images,
      this.files,
      this.video});
}
