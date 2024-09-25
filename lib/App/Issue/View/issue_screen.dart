import 'dart:io';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:union_up/Common/app_colors.dart';
import 'package:union_up/Common/snackbar.dart';
import 'package:union_up/Config/shared_prif.dart';
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Issues",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppColors.black),
                    ),
                  ),
                ],
              ),
              toolbarHeight: 80,
              leadingWidth: 150,
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
                // controller.updateGroupValue(1,false);
                // controller.updateGroupValue(2,false);
                // controller.updateGroupValue(3,false);
                // controller.dateToController.clear();
                // controller.titleController.clear();
                // controller.descriptionController
                //     .clear();
                // controller.locationController.clear();
                // controller.firstAnswerController
                //     .clear();
                // controller.secondAnswerController
                //     .clear();
                // controller.selectedIssueStatus = "Open";
                // controller.selectedCategory = null;
                // controller.selectedCategoryId = null;
                // controller.selectedCountryId = null;
                // controller.selectedReportIs =
                // null;
                // controller.selectedPriority =
                // null;
                // controller.selectedReportId = "";
                // controller.selectedReportsId = [];
                // controller.videoFile = null;
                // controller.images = [];
                // controller.files = [];

                // controller.dateAdd();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Issue found", style: Theme.of(context).textTheme.titleLarge),
              GestureDetector(
                  onTap: () => controller.getIssueList(context),
                  child: Text("Re-try", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary))),

            ],
          ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.keyboard_arrow_down_outlined)
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
                    // controller.getIssueList(context);

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
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 12, right: 12),
                      child: Stack(
                        children: [

                          Container(height: 70,
                          width: width,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                            color: AppColors.white),
                            child: Row(children: [
                              Expanded(
                                flex:8,
                                child: GestureDetector(
                                  onTap: () {
                                    print("issue id===${issue.id}");
                                    if (!controller.isTaskDetailOpening) {
                                      controller.updateRoute(true);
                                      controller.getIssueDetail(
                                          context, issue.id.toString(), (value) {
                                        if (value == true) {
                                          openIssueDetail(
                                              context, issue.id.toString());
                                        }
                                        controller.updateRoute(false);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: width*.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          issue.title?.rendered ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(color: AppColors.black),
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
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
                                            // const Spacer(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Container(
                                      width: 70,
                                      height: 22,
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

                            ],),
                          ),

                       /*   ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            title: GestureDetector(
                              onTap: () {
                                print("issue id===${issue.id}");
                                if (!controller.isTaskDetailOpening) {
                                  controller.updateRoute(true);
                                  controller.getIssueDetail(
                                      context, issue.id.toString(), (value) {
                                    if (value == true) {
                                      openIssueDetail(
                                          context, issue.id.toString());
                                    }
                                    controller.updateRoute(false);
                                  });
                                }
                              },
                              child: Text(
                                issue.title?.rendered ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: AppColors.black),
                                maxLines: 2,
                              ),
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
                                // const Spacer(),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                const SizedBox(
                                  height: 32,
                                ),
                                Container(
                                  width: 70,
                                  height: 22,
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
                          ),*/
                          Positioned(
                            top: 0,
                            right: 0,
                            child: PopupMenuButton(
                              icon: const Icon(Icons.more_horiz),
                              constraints: BoxConstraints(
                                  // maxHeight: size.height(context) * .04,
                                  maxWidth: width * .4,
                                  minWidth: width * .15),
                              itemBuilder: (context) {
                                return [

                                  PopupMenuItem(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        if (!controller.isTaskDetailOpening) {
                                          controller.updateRoute(true);
                                          controller.getIssueDetail(
                                              context, issue.id.toString(), (value) {
                                            if (value == true) {
                                              openIssueDetail(
                                                  context, issue.id.toString());
                                            }
                                            controller.updateRoute(false);
                                          });
                                        }

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(viewIcon,width: 15,height: 15,),
                                            SizedBox(width: 10,),
                                            const Text(
                                              "View",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF444444),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);


                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(downloadIcon,width: 15,height: 15,),
                                            SizedBox(width: 10,),
                                            const Text(
                                              "Download Pdf",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF444444),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.archiveIssue(
                                            context, issue.id.toString(),
                                            (value) {
                                          if (value == true) {

                                            snackbar(context,
                                                "Issue archive added successfully");
                                          }
                                        });

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(archiveIcon,width: 15,height: 15,),
                                            SizedBox(width: 10,),
                                            const Text(
                                              "Archive",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF444444),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (controller.isFetching)
              Container(
                  // height: 50,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  )),
            if (controller.isFetching)
              const SizedBox(
                  // height: 50,
                  )
          ],
        ),
      ),
    );
  }

  Widget secondTab(BuildContext context, IssueController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Visibility(
              visible: controller.archiveList.isNotEmpty,
              replacement: Center(
                child: Text("No Archive found",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              child: ListView.builder(
                itemCount: controller.archiveList.length,
                itemBuilder: (context, index) {
                  var issue = controller.archiveList[index];
                  return ListTile(
                    tileColor: AppColors.white,
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: GestureDetector(
                      onTap: () {
                        controller.getIssueDetail(context, issue.id.toString(),
                            (value) {
                          if (value == true) {
                            openIssueDetail(context, issue.id.toString());
                          }
                        });
                      },
                      child: Text(
                        issue.title?.rendered ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.black),
                        maxLines: 2,
                      ),
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
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 1),
                            child: Icon(Icons.more_horiz),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Container(
                          width: 70,
                          height: 22,
                          decoration: BoxDecoration(
                            color: issue.issueStatus != "1"
                                ? AppColors.lightRed
                                : AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _modalBottomSheetMenu(
    BuildContext context,
    width,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.white,
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
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            // Container(
                            //   height: 4,
                            //   width: 40,
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey[300],
                            //     borderRadius: BorderRadius.circular(2),
                            //   ),
                            // ),
                            // const SizedBox(height: 20),
                            const Text(
                              "New Issue",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Date picker row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 9,
                                  child: Column(
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
                                      GestureDetector(
                                        onTap: () {
                                          read.selectDate(context,0);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          // Ensure the container takes the full width of its parent
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          // Optional: Add padding to increase touch area

                                          child: Text(
                                            read.dateToController.text
                                                    .isNotEmpty
                                                ? read.dateToController.text
                                                : "Enter date                                          ",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                Expanded(
                                    flex: 1,
                                    child: const Icon(Icons.list, color: Colors.grey)),
                                // Prefix icon
                                const SizedBox(width: 10),
                                //
                                // DropdownButtonHideUnderline(
                                //   child: DropdownButton2<String>(
                                //     value: read.selectedCountryId,
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .bodyMedium
                                //         ?.copyWith(color: Colors.grey),
                                //     iconStyleData: IconStyleData(
                                //       icon: const Icon(
                                //           Icons.keyboard_arrow_down_outlined),
                                //       iconSize: 30,
                                //       iconEnabledColor: AppColors.black,
                                //     ),
                                //     isExpanded: true,
                                //     hint: Text(
                                //       "Category",
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .bodyMedium
                                //           ?.copyWith(color: Colors.grey),
                                //     ),
                                //     items: [
                                //       ...read.categoryList
                                //           .map((e) => DropdownMenuItem(
                                //                 value: e.id.toString(),
                                //                 child: SizedBox(
                                //                   height:
                                //                       MediaQuery.sizeOf(context)
                                //                           .width,
                                //                   width:
                                //                       MediaQuery.sizeOf(context)
                                //                           .width,
                                //                   child: Text(
                                //                       e.issueCategoryName ?? "",
                                //                       style: Theme.of(context)
                                //                           .textTheme
                                //                           .bodyMedium
                                //                           ?.copyWith(
                                //                               color:
                                //                                   Colors.grey)),
                                //                 ),
                                //                 onTap: () {
                                //                   // Navigator.pop(context);
                                //                   read.setCategoryName(e.id,
                                //                       e.issueCategoryName, e);
                                //                 },
                                //               ))
                                //           .toList(),
                                //     ],
                                //     onChanged: (String? value) {
                                //       print("seee==$value");
                                //       read.setCategory(value);
                                //     },
                                //     menuItemStyleData:
                                //         const MenuItemStyleData(height: 35),
                                //     buttonStyleData: ButtonStyleData(
                                //       height: 30,
                                //       width: width * .8,
                                //       padding: const EdgeInsets.only(
                                //           left: 0, right: 14),
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(14),
                                //         color: AppColors.white,
                                //       ),
                                //       elevation: 0,
                                //     ),
                                //     dropdownStyleData: DropdownStyleData(
                                //       maxHeight:
                                //           MediaQuery.sizeOf(context).height *
                                //               .8,
                                //       width: MediaQuery.sizeOf(context).width,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(14),
                                //         color: Colors.white,
                                //       ),
                                //       offset: const Offset(-10, 0),
                                //       scrollbarTheme: ScrollbarThemeData(
                                //         radius: const Radius.circular(40),
                                //         thickness: WidgetStateProperty.all(6),
                                //         thumbVisibility:
                                //             WidgetStateProperty.all(true),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Expanded(
                                  flex: 8,
                                  child: GestureDetector(
                                      onTap: () {
                                        showCategoryBottomSheet(context, read);
                                      },
                                      child: Row(

                                        children: [
                                          Expanded(
                                              flex:9,
                                              child: Text(read.selectedCategory != null ? read.selectedCategory ??"":"Choose category",
                                                  style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(color: Colors.grey),)),
                                          Expanded(
                                              flex: 1,
                                              child: Icon(Icons.keyboard_arrow_down))
                                        ],
                                      )),
                                )
                              ],
                            ),
                            Divider(
                              color: AppColors.grey,
                              indent: 30,
                            ),
                            if (read.isIssue == 2 && read.selectedCountryId == null)
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
                                    read.selectedReports.clear();
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

  void showCategoryBottomSheet(BuildContext context, IssueController read) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Full-screen bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (context) {
        final width = MediaQuery.sizeOf(context).width;
        final height = MediaQuery.sizeOf(context).height;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight:height * 0.7 ),
               // Set the height of the ListView
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: read.categoryList.length,
                  itemBuilder: (context, index) {
                    final category = read.categoryList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                      onTap: () {
                        // Handle item selection
                        read.setCategoryName(
                          category.id,
                          category.issueCategoryName,
                          category,
                        );
                        read.setCategory(category.id);
                        Navigator.pop(context); // Close the bottom sheet after selection
                      },
                       child:  Text(
                          category.issueCategoryName ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),

                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void modalBottomSheetMenu(
      BuildContext context, width, IssueController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.white,

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
                            // Row(
                            //   children: [
                            //     ConstrainedBox(
                            //       constraints:
                            //           const BoxConstraints(maxHeight: 500),
                            //       child: Container(
                            //         width: 130,
                            //         height: 50,
                            //         decoration: BoxDecoration(
                            //             borderRadius:
                            //                 BorderRadius.circular(10),
                            //             color: controller
                            //                         .selectedIssueStatus ==
                            //                     "Open"
                            //                 ? AppColors.lightRed
                            //                 : AppColors.lightGreen),
                            //         child: DropdownButtonHideUnderline(
                            //           child: DropdownButton2<String>(
                            //             value:
                            //                 controller.selectedIssueStatus,
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .bodyMedium
                            //                 ?.copyWith(color: Colors.grey),
                            //             iconStyleData: IconStyleData(
                            //               icon: const Icon(Icons
                            //                   .keyboard_arrow_down_outlined),
                            //               iconSize: 30,
                            //               iconEnabledColor: AppColors.black,
                            //             ),
                            //             isExpanded: true,
                            //             hint: Text(
                            //               "Category",
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .bodyMedium
                            //                   ?.copyWith(
                            //                       color: Colors.grey),
                            //             ),
                            //             items: [
                            //               ...controller.status
                            //                   .map((e) => DropdownMenuItem(
                            //                         value: e['name']
                            //                             .toString(),
                            //                         child: Padding(
                            //                           padding:
                            //                               const EdgeInsets
                            //                                   .all(8.0),
                            //                           child: Center(
                            //                             child: Container(
                            //                               height: MediaQuery
                            //                                       .sizeOf(
                            //                                           context)
                            //                                   .width,
                            //                               width: MediaQuery
                            //                                       .sizeOf(
                            //                                           context)
                            //                                   .width,
                            //                               decoration: BoxDecoration(
                            //                                   borderRadius:
                            //                                       BorderRadius
                            //                                           .circular(
                            //                                               10)),
                            //                               child: Text(
                            //                                 e['name'] ?? "",
                            //                                 style: Theme.of(
                            //                                         context)
                            //                                     .textTheme
                            //                                     .titleMedium
                            //                                     ?.copyWith(
                            //                                       color: e[
                            //                                           'txt_clr'],
                            //                                     ),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         onTap: () {},
                            //                       ))
                            //                   .toList(),
                            //             ],
                            //             onChanged: (String? newValue) {
                            //               controller
                            //                   .updateIssueStatus(newValue);
                            //             },
                            //             menuItemStyleData:
                            //                 const MenuItemStyleData(
                            //                     height: 35),
                            //             buttonStyleData: ButtonStyleData(
                            //               height: 30,
                            //               width: width * .4,
                            //               padding: const EdgeInsets.only(
                            //                   left: 0, right: 14),
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(14),
                            //                 color: controller
                            //                             .selectedIssueStatus ==
                            //                         "Open"
                            //                     ? AppColors.lightRed
                            //                     : AppColors.lightGreen,
                            //               ),
                            //               elevation: 0,
                            //             ),
                            //             dropdownStyleData:
                            //                 DropdownStyleData(
                            //               maxHeight:
                            //                   MediaQuery.sizeOf(context)
                            //                           .height *
                            //                       .8,
                            //               width: MediaQuery.sizeOf(context)
                            //                       .width *
                            //                   .35,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(14),
                            //                 color: Colors.white,
                            //               ),
                            //               offset: const Offset(-10, 0),
                            //               scrollbarTheme:
                            //                   ScrollbarThemeData(
                            //                 radius:
                            //                     const Radius.circular(40),
                            //                 thickness:
                            //                     WidgetStateProperty.all(6),
                            //                 thumbVisibility:
                            //                     WidgetStateProperty.all(
                            //                         true),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // ),
                       /*   Row(
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 500),
                                child: Container(
                                  width: 130,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.selectedIssueStatus == "Open"
                                        ? AppColors.lightRed
                                        :controller.selectedIssueStatus !=null ? AppColors.lightGreen :AppColors.lightGrey,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      // Set default value here
                                      value: controller.selectedIssueStatus,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                      iconStyleData: IconStyleData(
                                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                        iconSize: 30,
                                        iconEnabledColor: AppColors.black,
                                      ),
                                      isExpanded: true,
                                      hint: Text(
                                        "Category",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                 "Choose",
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...controller.status.map((e) {
                                          return DropdownMenuItem(
                                            value: e['name'].toString(),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  e['name'] ?? "",
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: e['txt_clr'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      ],
                                      onChanged: (String? newValue) {
                                        controller.updateIssueStatus(newValue);
                                      },
                                      menuItemStyleData: const MenuItemStyleData(height: 35),
                                      buttonStyleData: ButtonStyleData(
                                        height: 30,
                                        width: width * .4,
                                        padding: const EdgeInsets.only(left: 0, right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: controller.selectedIssueStatus == "Open"
                                              ? AppColors.lightRed
                                              :controller.selectedIssueStatus !=null ? AppColors.lightGreen :AppColors.lightGrey,
                                        ),
                                        elevation: 0,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: MediaQuery.sizeOf(context).height * .8,
                                        width: MediaQuery.sizeOf(context).width * .35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(-10, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness: WidgetStateProperty.all(6),
                                          thumbVisibility: WidgetStateProperty.all(true),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),*/

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 130,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.lightRed
                                      // :controller.selectedIssueStatus !=null ? AppColors.lightGreen : AppColors.lightGrey,
                                ),
                                child: Center(
                                  child: Text(
                                     "Open",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.red,
                                    ),
                                  ),
                                )
                              ),
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
                                            width: 10,
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
                                          Expanded(
                                            flex:1,
                                            child: Image.asset(
                                              priorityIconImage,
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 8,
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
                                                      .selectedPriority,
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down,
                                                    // You can change this icon to whatever you want
                                                    color: AppColors
                                                        .grey, // Set the color of the icon
                                                  ),
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
                                                // if (controller
                                                //             .isValidPriority ==
                                                //         true &&
                                                //     controller
                                                //         .selectedReports
                                                //         .isEmpty)
                                                //   Text(
                                                //     "Please select a priority",
                                                //     style: Theme.of(context)
                                                //         .textTheme
                                                //         .labelSmall
                                                //         ?.copyWith(
                                                //             color: AppColors
                                                //                 .red),
                                                //   ),
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
                                        child: Column(
                                          children: [
                                            Row(
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
                                                        style: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontSize: 14,
                                                            ),
                                                        onChanged: (query) {
                                                          print(
                                                              "query===$query");
                                                          read.searchCityList(
                                                              query);
                                                        },
                                                        sufixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child:
                                                              Image.asset(
                                                            location2Image,
                                                            width: 35,
                                                            height: 35,
                                                          ),
                                                        ),
                                                        hintStyle:
                                                            const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                        ),
                                                        // validator: (value) {
                                                        //   if(value!.isEmpty && value==""){
                                                        //     return "Please enter Location";
                                                        //   }
                                                        // },
                                                      ),
                                                      Divider(
                                                        color:
                                                            AppColors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: read
                                                      .locationController
                                                      .text
                                                      .isNotEmpty &&
                                                  controller.searchPlace
                                                          .length >
                                                      1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(15)),
                                                width: double.infinity,
                                                child: ListView.builder(
                                                    padding:
                                                        EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount: controller
                                                        .searchPlace.length,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            ListTile(
                                                              onTap: () {
                                                                setState(
                                                                    () {
                                                                  read.locationController
                                                                      .text = controller
                                                                          .searchPlace[index]
                                                                          .description ??
                                                                      "";
                                                                  setState(
                                                                      () {
                                                                    controller
                                                                        .searchPlace
                                                                        .clear();
                                                                  });
                                                                });
                                                              },
                                                              horizontalTitleGap:
                                                                  0,
                                                              title: Text(
                                                                controller
                                                                        .searchPlace[index]
                                                                        .description ??
                                                                    "",
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )),
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
                                            Expanded(
                                              flex: 1,
                                              child: Image.asset(
                                                questionMarkImage,
                                                width: 25,
                                                height: 25,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              flex: 8,
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
                                      SharedStorage.instance.role ==
                                              "worker"
                                          ? "Report to delegate"
                                          : "Report Issue to",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: AppColors.grey),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex:1,
                                          child: Image.asset(
                                            userIconImage,
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _showAssignReportBottomSheet(context, controller);
                                                },
                                                child: InputDecorator(
                                                  decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.fromLTRB(10, 20, 8, 20),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [

                                                      Text(

                                                        controller.selectedReportIs ?? 'Choose',
                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                          color: AppColors.grey,
                                                        ),
                                                      ),
                                                       Spacer(),
                                                      if(controller.selectedReportIs != null)
                                                        Image.network(
                                                          controller.selectedReportUser?.image ??
                                                              "",
                                                          height: 25,
                                                          width: 25,
                                                          fit: BoxFit
                                                              .fitWidth,
                                                        ),
                                                      SizedBox(width: 10,),
                                                       Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
                                                    ],
                                                  ),
                                                ),
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
                                      SharedStorage.instance.role ==
                                              "worker"
                                          ? "Notify Safety Rep"
                                          : "Notify Others",
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
                                                                height: 30.isFinite ? 30
                                                                        : 0,
                                                                width: 150,
                                                                settings: settings,

                                                                avatars: [
                                                                  for (var n = 0; n < controller.selectedReports.length; n++)
                                                                    NetworkImage(controller.selectedReports[n].image ?? ""),
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
                                                                  "Choose",
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
                                              // if(controller.isValidNotify==true)
                                              //   Text(
                                              //     "Please select Notify safety rep",
                                              //     style: Theme.of(context)
                                              //         .textTheme
                                              //         .labelSmall
                                              //         ?.copyWith(
                                              //         color: AppColors
                                              //             .red),
                                              //   ),
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
                                    _imageBottomSheetMenu(
                                        context, width, controller);
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
                                    itemCount: controller.images.length +
                                        controller.files.length +
                                        (controller.videoFile != null
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
                                              File(image),
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
                                      } else if (index <
                                          controller.images.length +
                                              controller.files.length) {
                                        final fileIndex = index -
                                            controller.images.length;
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
                                            controller.videoLoader ==
                                                        true &&
                                                    controller.video != null
                                                ? CircularProgressIndicator(
                                                    color:
                                                        AppColors.primary,
                                                  )
                                                : AspectRatio(
                                                    aspectRatio: controller
                                                        .vController!
                                                        .value
                                                        .aspectRatio,
                                                    child: VideoPlayer(
                                                        controller
                                                            .vController!),
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
                                    read.dateToController.text = controller.formatDate(controller.defaultDate);
                                    read.titleController.clear();
                                    read.descriptionController.clear();
                                    read.locationController.clear();
                                    read.firstAnswerController.clear();
                                    read.secondAnswerController.clear();
                                    read.selectedIssueStatus = "Open";
                                    read.selectedCategory = null;
                                    read.selectedCategoryId = null;
                                    read.selectedCountryId = null;
                                    read.selectedId = null;
                                    read.selectedReportUser = null;

                                    read.selectedReports.clear();
                                    controller.selectedReportIs = null;
                                    controller.selectedPriority = null;
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
                                  onTap:  read.isAddIssue==false ?  () {
                                    if (!read.issueAddFormKey.currentState!
                                        .validate()) {
                                      // if (controller.selectedPriority ==
                                      //     null) {
                                      //   controller.updateGroupValue(
                                      //       1, true);
                                      // }
                                      // if (controller.selectedReportIs ==
                                      //     null) {
                                      //   controller.updateGroupValue(
                                      //       2, true);
                                      // }
                                      // if (controller.selectedReports.isEmpty) {
                                      //   controller.updateGroupValue(
                                      //       3, true);
                                      // }
                                      return;
                                    }
                                    // else if (controller.selectedPriority ==
                                    //     null) {
                                    //   print(
                                    //       "---- ${controller.selectedPriority}");
                                    //   controller.updateGroupValue(1, true);
                                    //   return;
                                    // } else if (controller
                                    //         .selectedReportIs ==
                                    //     null) {
                                    //   controller.updateGroupValue(2, true);
                                    //   return;
                                    // }
                                    // else if (controller.selectedReports.isEmpty) {
                                    //   controller.updateGroupValue(3, true);
                                    //   return;
                                    // }
                                    else {
                                      final data = AddIssueModel(
                                          date: read.dateToController.text,
                                          title: read.titleController.text,
                                          description: read
                                              .descriptionController.text,
                                          issueLocation:
                                              read.locationController.text,
                                          question1: read
                                              .firstAnswerController.text,
                                          question2: read
                                              .secondAnswerController.text,
                                          status: controller
                                              .selectedIssueStatus,
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
                                      // print("img===${controller.images.first}");
                                      controller.addIssue(
                                        context,
                                        data,
                                        (value) {
                                          if (value == true) {
                                            read.dateToController.text = controller.formatDate(controller.defaultDate);

                                            read.titleController.clear();
                                            read.descriptionController
                                                .clear();
                                            read.locationController.clear();
                                            read.firstAnswerController
                                                .clear();
                                            read.secondAnswerController
                                                .clear();
                                            read.selectedIssueStatus =
                                                "Open";
                                            read.selectedCategory = null;
                                            read.selectedCategoryId = null;
                                            read.selectedCountryId = null;
                                            read.selectedReportUser = null;
                                            controller.selectedReportIs =
                                                null;
                                            read.selectedReports.clear();
                                            controller.selectedPriority =
                                                null;
                                            controller.selectedReportId = "";
                                            controller.selectedId = null;

                                            controller.selectedReportsId =
                                                [];
                                            controller.videoFile = null;
                                            controller.images = [];
                                            controller.files = [];
                                            Navigator.pop(context);
                                          }
                                        },
                                      );
                                    }
                                  } :
                                  (){
                                    snackbar(context, "Please Wait...");
                                  },
                                )),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _imageBottomSheetMenu(
      BuildContext context, width, IssueController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.4, // Max height 80% of screen height
              ),
              child: SingleChildScrollView(
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
                  child: Column(
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
                      Text("Attachment",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          controller.pickImage(ImageSource.camera,0);
                          Navigator.pop(context);
                        },
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                        horizontalTitleGap: 5,
                        leading: Image.asset(
                          cameraIcon,
                          width: 20,
                          height: 20,
                        ),
                        title: const Text("Take photo"),
                      ),
                      ListTile(
                        onTap: () {
                          controller.pickImage(ImageSource.gallery,0);
                          Navigator.pop(context);
                        },
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                        horizontalTitleGap: 5,
                        leading: Image.asset(
                          albumIcon,
                          width: 20,
                          height: 20,
                        ),
                        title: const Text("Select Image"),
                      ),
                      // ListTile(
                      //   onTap: () {
                      //     // controller.pickFile();
                      //     Navigator.pop(context);
                      //   },
                      //   contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                      //
                      //   horizontalTitleGap: 5,
                      //   leading: Image.asset(fileIcon,width: 20,height: 20,),
                      //   title: const Text("Upload File"),),
                      ListTile(
                        onTap: () {
                          controller.pickVideo(0);
                          Navigator.pop(context);
                        },
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                        horizontalTitleGap: 5,
                        leading: Image.asset(
                          videoCamera,
                          width: 20,
                          height: 20,
                        ),
                        title: const Text("add video"),
                      ),
                    ],
                  ),
                ),
              )),
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

  void _showMultiSelectAssignReport(BuildContext context, IssueController provider) {
    TextEditingController searchController = TextEditingController();
    List<AssignReport> filteredItems = List.from(provider.assignReport);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Makes the bottom sheet full-height when necessary
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: StatefulBuilder(
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

              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8,),
                // Set height to 90% of screen
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Title of the bottom sheet
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Assign to",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
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
                        hintText: 'Search',
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
                    // const SizedBox(height: 5),
                    // Text("If you can’t find your Delegate, please contact your Union to add them.",
                    //   style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.grey),),
                    const SizedBox(height: 10),
                    Text("Notify safety",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),

                    // Filtered List
                    Expanded(
                      child: ListView(
                        children: filteredItems.map((category) {
                          return CheckboxListTile(
                            activeColor: AppColors.primary,
                            value: provider.selectedReportsId
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
                                provider.toggleReportSelection();
                                provider.toggleReportSelection1(
                                    category.id.toString());
                                provider.updateGroupValue(3, false);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
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
                                  ?.copyWith(color: AppColors.grey),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: AppColors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: AppColors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: AppColors.grey)),
                            ),
                            onChanged: (value) => _filterItems(value),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
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

  void _showAssignReportBottomSheet(BuildContext context, IssueController controller) {
    TextEditingController searchController = TextEditingController();
    List<AssignReport> filteredItems = List.from(controller.assignReport); // Create a filtered list

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Allows the bottom sheet to expand
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Function to filter items based on search query
            void _filterItems(String query) {
              setState(() {
                filteredItems = controller.assignReport.where((category) {
                  return category.displayName!
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList();
              });
            }

            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .8,
              minHeight: MediaQuery.sizeOf(context).height * .2 ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 10.0,right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make the bottom sheet fit its content
                  children: [
                    // Title for the bottom sheet
                    Text(
                      "Assign to",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextField(
                      controller: searchController,
                      style:Theme.of(context).textTheme.bodyMedium ,
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: _filterItems, // Filter items when text changes
                    ),
                    // Text(
                    //   "If you can’t find your Delegate, please contact your Union to add them.",
                    //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                    // ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Delegate",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // List of reports from controller
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .6,),
                      child: ListView(
                        children: [
                          // Default "Choose" option
                          ListTile(
                            trailing: Checkbox(
                              value: controller.selectedId == null || controller.selectedId == "null",
                              activeColor: controller.selectedId == null || controller.selectedId == "null"
                                  ? AppColors.primary
                                  : AppColors.secondaryColor,
                              onChanged: (bool? value) {
                                if (value == true) {
                                  setState(() {
                                    controller.setReport(null, null);
                                    Navigator.pop(context);
                                  });
                                }
                              },
                            ),
                            title: Text(
                              "Choose",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                controller.setReport(null, null);
                              });
                              Navigator.pop(context); // Close bottom sheet
                            },
                          ),
                          // Dynamic filtered report items
                          ...filteredItems.map((category) {
                            return ListTile(
                              trailing: Checkbox(
                                activeColor: controller.selectedId == category.id.toString()
                                    ? AppColors.primary
                                    : AppColors.secondaryColor,
                                value: controller.selectedId == category.id.toString(),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      controller.setReport(category.displayName.toString(), category.id);
                                    });
                                    Navigator.pop(context); // Close bottom sheet
                                  }
                                },
                              ),
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
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  controller.setReport(category.displayName.toString(), category.id);
                                });
                                Navigator.pop(context); // Close bottom sheet
                              },
                            );
                          }).toList(),
                        ],
                      ),
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
  List<String>? images;
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
