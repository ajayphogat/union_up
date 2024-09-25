import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:union_up/App/Issue/ViewModel/issue_controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Common/snackbar.dart';
import 'package:video_player/video_player.dart';

import '../../../Common/app_colors.dart';
import '../../../Config/shared_prif.dart';
import '../../../Widget/app_button.dart';
import '../../../Widget/app_text_field.dart';
import '../Model/detail_comment_model.dart';
import '../Model/report_assign_model.dart';
import 'issue_screen.dart';

class IssueDetailSceen extends StatelessWidget {
  String id;

  IssueDetailSceen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    ;
    return Consumer<IssueController>(
      builder: (context, controller, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.white,
          appBar: AppBar(
            toolbarHeight: 90,
            leading: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () {
                      controller.controllerList.clear();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                const SizedBox(
                  width: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Issue Details",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.black),
                  ),
                ),
              ],
            ),
            centerTitle: false,
            leadingWidth: 250,
            actions: [
              // PopupMenuButton(
              //   icon: const Icon(Icons.more_vert),
              //   constraints: BoxConstraints(
              //     maxWidth: width * .35,
              //     minWidth: width * .15,
              //   ),
              //   itemBuilder: (context) {
              //     return [
              //       PopupMenuItem(
              //         padding: const EdgeInsets.only(left: 10, bottom: 0),
              //         child: InkWell(
              //           onTap: () {
              //             controller.editDetail(
              //               controller.issueData?.date,
              //               controller.issueData?.title,
              //               controller.issueData?.content,
              //               controller.issueData?.issueStatus == "0"
              //                   ? "Open"
              //                   : "Close",
              //               controller.issueData?.issueCategoryNames?[0],
              //               controller.issueData?.issuePriority,
              //               controller.issueData?.reportIssue,
              //               controller.issueData?.notify?.split(","),
              //               controller.issueData?.issueLocation,
              //
              //               controller.issueData!.questionsAnswers!.isNotEmpty ?  controller.issueData!.questionsAnswers![0].answer :"",
              //               controller.issueData!.questionsAnswers!.isNotEmpty && controller.issueData!.questionsAnswers!.length > 1 ?  controller.issueData!.questionsAnswers![1].answer :"",
              //
              //
              //             );
              //
              //             // Close the popup before showing the bottom sheet
              //             Navigator.pop(context);
              //
              //             // Show the bottom sheet
              //             modalBottomSheetMenu(context, width, controller);
              //           },
              //           child: const Text(
              //             "Edit",
              //             style: TextStyle(
              //               fontSize: 14,
              //               color: Color(0xFF444444),
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ];
              //   },
              // ),
              GestureDetector(
                  onTap: () {
                    popUpBottomsheet(context, width, controller);
                  },
                  child: Icon(Icons.more_horiz)),
              const SizedBox(width: 15),
            ],
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
                    Tab(text: "Issue Detail"),
                    Tab(text: "Activity"),
                  ],
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Container(
                // height: height,
                // width: width,
                color: AppColors.white,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              tab1(context, controller, width),
                              activityTab(context, controller, width),
                              // Container()
                            ],
                          ),
                        ),
                        const Divider(),
                        // Divider at the bottom
                        if (controller.commentImage.isNotEmpty ||
                            controller.commentFiles.isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 50,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 4,
                                ),
                                itemCount: controller.commentImage.length +
                                    controller.commentFiles.length,
                                itemBuilder: (context, index) {
                                  if (index < controller.commentImage.length) {
                                    final image =
                                        controller.commentImage[index];
                                    return Stack(
                                      children: [
                                        Image.file(
                                          File(image),
                                          width: 50,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          right: -10,
                                          top: -10,
                                          child: IconButton(
                                            icon: const Icon(Icons.cancel,
                                                color: Colors.grey),
                                            onPressed: () {
                                              // setState(() {
                                              controller.images.removeAt(index);
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (index <
                                      controller.commentImage.length +
                                          controller.commentFiles.length) {
                                    final fileIndex =
                                        index - controller.commentImage.length;
                                    final file =
                                        controller.commentFiles[fileIndex];
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
                                            icon: const Icon(Icons.cancel,
                                                color: Colors.grey),
                                            onPressed: () {
                                              // setState(() {
                                              controller.commentFiles
                                                  .removeAt(fileIndex);
                                              // });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 0),
                          child: AppTextFormWidget(
                            hintText: "Add a comment or update",
                            controller: controller.commentController,
                            maxLines: 3,
                            minLine: 2,
                            style: Theme.of(context).textTheme.bodyMedium,
                            focusNode: controller.commentFocusMode,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.grey),
                          ),
                        ),

                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                                onTap: () {
                                  _imageBottomSheetMenu(
                                      context, width, controller);
                                },
                                child: Image.asset(
                                  attach,
                                  width: 20,
                                  height: 20,
                                )),
                            const Spacer(),
                            GestureDetector(
                              onTap: controller.commentAdded == false
                                  ? () {
                                      if (controller.commentController.text
                                              .isNotEmpty ||
                                          controller.commentImage.isNotEmpty ||
                                          controller.commentFiles.isNotEmpty) {
                                        var data = AddIssueCommentModel(
                                            comment: controller
                                                .commentController.text,
                                            postId: id,
                                            commentParentId: "",
                                            commentImage: controller
                                                    .commentImage.isNotEmpty
                                                ? controller.commentImage
                                                : [],
                                            commentDocs: controller
                                                    .commentFiles.isNotEmpty
                                                ? controller.commentFiles
                                                : []);

                                        controller.addDetailComment(
                                          context,
                                          data,
                                          (value) {
                                            if (value == true) {
                                              controller.updateFocusNode();
                                            }
                                          },
                                        );
                                      }
                                    }
                                  : () {
                                      snackbar(context, "Please wait...");
                                    },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Image.asset(
                                  sendMsgIcon,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                    if (controller.commentAdded)
                      const Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(child: CircularProgressIndicator()))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  popUpBottomsheet(BuildContext context, width, IssueController controller){
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.white,
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
                        children:[
                          Align(
                            alignment: Alignment.center,
                            child: Text("Issue Option",style: Theme.of(context).textTheme.titleMedium,),
                          ),

                          ListTile(
                            onTap: () {
                              controller.editDetail(
                                controller.issueData?.date,
                                controller.issueData?.title,
                                controller.issueData?.content,
                                controller.issueData?.issueStatus == "0"
                                    ? "Open"
                                    : "Close",
                                controller.issueData?.issueCategoryNames?[0],
                                controller.issueData?.issuePriority,
                                controller.issueData?.reportIssue,
                                controller.issueData?.notify?.split(","),
                                controller.issueData?.issueLocation,

                                controller.issueData!.questionsAnswers!.isNotEmpty ?  controller.issueData!.questionsAnswers![0].answer :"",
                                controller.issueData!.questionsAnswers!.isNotEmpty && controller.issueData!.questionsAnswers!.length > 1 ?  controller.issueData!.questionsAnswers![1].answer :"",


                              );

                              // Close the popup before showing the bottom sheet
                              Navigator.pop(context);

                              // Show the bottom sheet
                              modalBottomSheetMenu(context, width, controller);
                            },
                            contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                            horizontalTitleGap: 5,
                            leading: Image.asset(
                              viewReportIcon,
                              width: 20,
                              height: 20,
                            ),
                            title: const Text("Edit Issue"),
                          ),
                          ListTile(
                            onTap: () {
                              controller.pickCommentImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                            contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                            horizontalTitleGap: 5,
                            leading: Image.asset(
                              viewReportIcon,
                              width: 20,
                              height: 20,
                            ),
                            title: const Text("View Report"),
                          ),

                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              controller.archiveIssue(
                                  context, controller.issueData!.id.toString(),
                                      (value) {
                                    if (value == true) {

                                      snackbar(context,
                                          "Issue archive added successfully");
                                    }
                                  });
                            },
                            contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                            horizontalTitleGap: 5,
                            leading: Image.asset(
                              archiveIcon,
                              width: 20,
                              height: 20,
                            ),
                            title: const Text("Archive"),
                          ),
                          ListTile(
                            onTap: () {
                              controller.pickCommentImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                            contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                            horizontalTitleGap: 5,
                            leading: Image.asset(
                              createTaskIcon,
                              width: 20,
                              height: 20,
                            ),
                            title: const Text("Create Task"),
                          ),

                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  tab1(BuildContext context, IssueController controller, double width) {
    return ListView(
      children: [
        detailPart(context, controller, width),
        if (controller.questionsAnswers.isNotEmpty)
          Container(
            height: 10,
            width: width,
            color: AppColors.scaffoldColor,
          ),
        if (controller.questionsAnswers.isNotEmpty)
          question(context, controller, width),
        if (controller.issueData?.issueLocation != "")
          Container(
            height: 10,
            width: width,
            color: AppColors.scaffoldColor,
          ),
        if (controller.issueData?.issueLocation != "")
          googleMap(context, controller, width),
        if (controller.issueDetailImage.isNotEmpty ||
            controller.issueDetailVideo.isNotEmpty)
          Container(
            height: 10,
            width: width,
            color: AppColors.scaffoldColor,
          ),
        if (controller.issueDetailImage.isNotEmpty ||
            controller.issueDetailVideo.isNotEmpty)
          attachment(context, controller, width),
        Container(
          height: 10,
          width: width,
          color: AppColors.white,
        ),
      ],
    );
  }

  activityTab(BuildContext context, IssueController controller, double width) {
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
                                      if (data.commentMeta != null)
                                        if (data.commentMeta!.isNotEmpty)
                                          Container(
                                            height: 50,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  data.commentMeta?.length,
                                              itemBuilder: (context, index) =>
                                                  Image.network(data
                                                          .commentMeta?[index]
                                                          .metaValue ??
                                                      ""),
                                            ),
                                          ),
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
                                              controller.activeReplyIndex =
                                                  index;
                                              controller
                                                  .updateFocusNode(); // Optional: To focus on the reply box
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

                              const SizedBox(
                                height: 10,
                              ),
                              // show only for index where i want reply
                              if (controller.activeReplyIndex == index)
                                AppTextFormWidget(
                                  // height: 40,
                                  hintText: "Enter your message",
                                  controller: controller.replyCommentController,
                                  fillColor: AppColors.lightGrey,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.grey),
                                  sufixIcon: GestureDetector(
                                    onTap: () {
                                      var data = AddIssueCommentModel(
                                          comment: controller
                                              .replyCommentController.text,
                                          postId: id,
                                          commentParentId: comment.id,
                                          commentImage: [],
                                          commentDocs: []);

                                      controller.updateFocusNode();
                                      controller.addDetailComment(
                                        context,
                                        data,
                                        (value) {
                                          if (value == true) {
                                            controller.replyCommentController
                                                .clear();
                                            controller.activeReplyIndex = null;
                                          }
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 24.0),
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

  detailPart(BuildContext context, IssueController controller, double width) {
    // print("location==== ${controller.issueData?.issueLocation ??""}");
    return Container(
      color: AppColors.white,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        controller.issueData?.date ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.grey),
                      ),
                      Divider(
                        color: AppColors.grey,
                      )
                      // AppTextFormWidget(
                      //     hintText: "Date", controller: controller.showDateController, hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.grey))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              controller.issueData?.title ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 24),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              controller.issueData?.content ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.grey, fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                    color: controller.issueData?.issueStatus == "1" ||controller.issueData?.issueStatus == "Close"
                        ? AppColors.lightGreen
                        : AppColors.lightRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      controller.issueData?.issueStatus == "1" ||controller.issueData?.issueStatus == "Close"
                          ? "Close"
                          : "Open",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              color: controller.issueData?.issueStatus == "1" || controller.issueData?.issueStatus == "Close"
                                  ? AppColors.green
                                  : AppColors.red),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                listIconImage,
                                width: 20,
                                height: 20,
                              )),
                          // Icon(Icons.list, color: Colors.grey),
                          const SizedBox(
                            width: 5,
                          ),
                          if (controller.issueData != null)
                            if (controller.issueData!.issueCategoryNames !=
                                null)
                              if (controller
                                  .issueData!.issueCategoryNames!.isNotEmpty)
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    controller.issueData
                                                ?.issueCategoryNames?[0] !=
                                            null
                                        ? controller.issueData
                                                ?.issueCategoryNames?.first ??
                                            ""
                                        : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.grey),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.issueData?.issuePriority != "" ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      controller.issueData?.issuePriority ==
                                              "High"
                                          ? highImage
                                          : controller.issueData
                                                      ?.issuePriority ==
                                                  "Medium"
                                              ? mediumImage
                                              : lowImage,
                                      height: 15,
                                      width: 15,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      controller.issueData?.issuePriority ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: controller.issueData
                                                          ?.issuePriority ==
                                                      "High"
                                                  ? AppColors.red
                                                  : controller.issueData
                                                              ?.issuePriority ==
                                                          "Medium"
                                                      ? AppColors.orange
                                                      : AppColors.primary),
                                    ),
                                  ],
                                ) :Text(""),
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
                      SharedStorage.instance.role == "worker"
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          if (controller.issueData != null)
                            if (controller.issueData?.reportIssueUser != null)
                              controller
                                  .issueData!.reportIssueUser!.isNotEmpty?
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.issueData?.reportIssueUser
                                                ?.first ??
                                            "",
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
                                ) :Expanded(
                                  flex: 7,
                                  child: Column(
                                    children: [
                                      Text(
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.grey),
                                      ),
                                      Divider(
                                        color: AppColors.grey,
                                      )
                                    ],
                                  )),
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
                      SharedStorage.instance.role == "worker"
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
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            alertIconImage, // Ensure this path is correct
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showMultiSelectGroup(context, controller);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AvatarStack(
                                      height: 25.isFinite ? 25 : 0,
                                      width: 160,
                                      settings: settings,
                                      avatars: [
                                        for (var n = 0;
                                            n <
                                                controller
                                                    .issueData!.notifyUser!.length;
                                            n++)
                                          NetworkImage(controller
                                                  .issueData!.notifyUser![n] ??
                                              ""),
                                      ],
                                      infoWidgetBuilder: (surplus) =>
                                          _infoWidget(surplus, context),
                                    ),
                                    Icon(Icons.keyboard_arrow_down)
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
                    ),
                  ),
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
                  "Visible to anyone involved in the Issue",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.grey),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  question(BuildContext context, IssueController controller, double width) {
    // Ensure controllers and icon states are initialized

    return Container(
      width: width,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.grey),
                ),
                // Icon(Icons.edit, color: AppColors.grey),
              ],
            ),
            const SizedBox(height: 15),
            ListView.builder(
              itemCount: controller.questionsAnswers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = controller.questionsAnswers[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Q.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            data.question ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("A."),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            data.answer != ""
                                ? data.answer ?? ""
                                : "Un Answered",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget googleMap(
      BuildContext context, IssueController controller, double width) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.grey),
                ),
                // Icon(Icons.edit, color: AppColors.grey),
              ],
            ),
            Text(
              controller.issueData?.issueLocation ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.grey),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white),
              height: MediaQuery.sizeOf(context).height * .22,
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  child: GoogleMap(
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    myLocationEnabled: false,
                    compassEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.location?.latitude ?? 0.0,
                        controller.location?.longitude ?? 0.0,
                      ),
                      zoom: 14.5,
                    ),
                    onMapCreated: controller.onMapCreated,
                    markers: controller.markers.values.toSet(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  attachment(BuildContext context, IssueController controller, double width) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "File",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.grey),
                ),
                // Icon(Icons.edit, color: AppColors.grey),
              ],
            ),
            Container(
              color: AppColors.white,
              width: width,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (controller.issueDetailImage.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.issueDetailImage.length,
                          itemBuilder: (context, index) {
                            var data = controller.issueDetailImage[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    data,
                                    width: 110,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (controller.issueDetailVideo.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.issueDetailVideo.length,
                          itemBuilder: (context, index) {
                            var videoUrl = controller.issueDetailVideo;
                            controller.initializeControllers(videoUrl);
                            return Stack(
                              children: [
                                Container(
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Center(
                                      child: FutureBuilder(
                                        future: controller
                                            .initializeVideoFutures[index],
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: AspectRatio(
                                                aspectRatio: 1.4,
                                                child: VideoPlayer(controller
                                                    .videoControllers[index]),
                                              ),
                                            );
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.videoControllers[index]
                                          .value.isPlaying) {
                                        controller.pause(index);
                                      } else {
                                        controller.play(index);
                                      }
                                    },
                                    child: Icon(
                                      controller.videoControllers[index].value
                                              .isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _imageBottomSheetMenu(
      BuildContext context, width, IssueController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
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
                          controller.pickCommentImage(ImageSource.camera);
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
                          controller.pickCommentImage(ImageSource.gallery);
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
                      ListTile(
                        onTap: () {
                          controller.pickFile();
                          Navigator.pop(context);
                        },
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                        horizontalTitleGap: 5,
                        leading: Image.asset(
                          fileIcon,
                          width: 20,
                          height: 20,
                        ),
                        title: const Text("Upload File"),
                      ),
                      // ListTile(
                      //   onTap: () {
                      //     // controller.pickVideo();
                      //     Navigator.pop(context);
                      //   },
                      //   contentPadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                      //
                      //   horizontalTitleGap: 5,
                      //   leading: Image.asset(videoCamera,width: 20,height: 20,),
                      //   title: const Text("add video"),),
                    ],
                  ),
                ),
              )),
            ),
          );
        });
  }
}

void _showMultiSelectGroup(
  BuildContext context,
  IssueController provider,
) {
  List<String> filteredItems = List.from(provider.issueData?.notifyUser ?? []);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Selected Notify User",
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
                        value: provider.issueData?.notifyUser
                            ?.contains(category.toString()),
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

class AddIssueCommentModel {
  String? comment;
  String postId;
  String? commentParentId;
  List<String>? commentImage;
  List<String>? commentDocs;

  AddIssueCommentModel(
      {this.comment,
      required this.postId,
      this.commentParentId,
      this.commentImage,
      this.commentDocs});
}

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  PdfViewerPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
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
                    0.8, // Max height 80% of screen height
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text("Edit Issue",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),

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
                                          read.selectDate(context,1);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          // Ensure the container takes the full width of its parent
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          // Optional: Add padding to increase touch area

                                          child: Text(
                                            read.editDateToController.text
                                                    .isNotEmpty
                                                ? read.editDateToController.text
                                                : "Enter date                                          ",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: Colors.grey),
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

                            const SizedBox(height: 10),

                            // Title and description text fields
                            AppTextFormWidget(
                              hintText: "Tap to add title...",
                              controller: read.edittitleController,
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
                              controller: read.editdescriptionController,
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
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 500),
                                  child: Container(
                                    width: 130,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        color:
                                            controller.selectedIssueStatus ==
                                                    "Open"
                                                ? AppColors.lightRed
                                                : AppColors.lightGreen),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        value: controller.selectedIssueStatus,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey),
                                        iconStyleData: IconStyleData(
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
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
                                          ...controller.status
                                              .map((e) => DropdownMenuItem(
                                                    value:
                                                        e['name'].toString(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                      child: Center(
                                                        child: Container(
                                                          height: MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width,
                                                          width: MediaQuery
                                                                  .sizeOf(
                                                                      context)
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            e['name'] ?? "",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                  color: e[
                                                                      'txt_clr'],
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  ))
                                              .toList(),
                                        ],
                                        onChanged: (String? newValue) {
                                          controller
                                              .updateIssueStatus(newValue);
                                        },
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                                height: 35),
                                        buttonStyleData: ButtonStyleData(
                                          height: 30,
                                          width: width * .4,
                                          padding: const EdgeInsets.only(
                                              left: 0, right: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: controller
                                                        .selectedIssueStatus ==
                                                    "Open"
                                                ? AppColors.lightRed
                                                : AppColors.lightGreen,
                                          ),
                                          elevation: 0,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight:
                                              MediaQuery.sizeOf(context)
                                                      .height *
                                                  .8,
                                          width: MediaQuery.sizeOf(context)
                                                  .width *
                                              .35,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Colors.white,
                                          ),
                                          offset: const Offset(-10, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                WidgetStateProperty.all(6),
                                            thumbVisibility:
                                                WidgetStateProperty.all(true),
                                          ),
                                        ),
                                      ),
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
                                              read.selectedCategory.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: AppColors.grey),
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
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField(
                                                  items: [
                                                    DropdownMenuItem<String>(
                                                      value: null,
                                                      // Default "Choose" option with null value
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
                                                    ...controller.priorityList
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
                                                              category['img'],
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
                                                                      color: category[
                                                                          'color']),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                  onChanged: (newValue) {
                                                    print("newValue===$newValue");
                                                    controller.setPriorityDetail(
                                                        newValue);

                                                  },
                                                  value: controller.selectedPriorityDetail,
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
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
                                                    border: InputBorder.none,
                                                    // Remove underline
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    // Remove underline for enabled state
                                                    focusedBorder:
                                                        InputBorder.none,
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

                            ///location

                            if (read.selectedCategoryDataDetail?.hasAsterisk == 1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Location",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.grey),
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
                                                        readOnly: true,
                                                        hintText:
                                                            "Select Location",
                                                        controller: read
                                                            .locationController,
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  fontSize:
                                                                      14,
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
                                                        color: AppColors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        )),
                                  ],
                                ),
                              ),

                            /// Question Answer
                            if (read.selectedCategoryDataDetail?.hasAsterisk == 1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                            ?.copyWith(color: AppColors.grey),
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
                                                    CrossAxisAlignment.start,
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
                                                        .editsecondAnswerController,
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
                                                        .editfirstAnswerController,
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
                                      SharedStorage.instance.role == "worker"
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
                                      children: [
                                        Image.asset(
                                          userIconImage,
                                          width: 25,
                                          height: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DropdownButtonFormField<String>(
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: null,
                                                    // Default "Choose" option
                                                    child: Text(
                                                      "Choose",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .grey),
                                                    ),
                                                  ),
                                                  ...controller.assignReport
                                                      .map((category) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      onTap: () {
                                                        // controller.setReportId(
                                                        //     category.id
                                                        //         .toString());
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
                                                                .bodySmall
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
                                                  controller.setReportDetail(newValue);

                                                },
                                                value: controller.selectedReportIsDetail,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  // You can change this icon to whatever you want
                                                  color: AppColors
                                                      .grey, // Set the color of the icon
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10, 20, 8, 20),
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
                                      SharedStorage.instance.role == "worker"
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
                                                                .selectedReportsDetail
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
                                                                          controller
                                                                              .selectedReportsDetail.length;
                                                                      n++)
                                                                    NetworkImage(
                                                                        controller.selectedReportsDetail[n].image ??
                                                                            ""),
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
                                                                          color:
                                                                              AppColors.grey),
                                                                )),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 8.0),
                                                          child: Icon(Icons
                                                              .keyboard_arrow_down_outlined),
                                                        )
                                                      ],
                                                    )),
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
                                    _imageBottomSheetMenu(
                                        context, width, controller);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child:
                                          Icon(Icons.add, color: Colors.grey),
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
                                    itemCount: controller.imagesDetail.length +
                                        controller.filesDetail.length +
                                        (controller.videoFileDetail != null
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      if (index < controller.imagesDetail.length) {
                                        final image =
                                            controller.imagesDetail[index];
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
                                                icon: const Icon(Icons.cancel,
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
                                          controller.imagesDetail.length +
                                              controller.filesDetail.length) {
                                        final fileIndex =
                                            index - controller.imagesDetail.length;
                                        final file =
                                            controller.filesDetail[fileIndex];
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
                                                icon: const Icon(Icons.cancel,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  setState(() {
                                                    controller.files
                                                        .removeAt(fileIndex);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            controller.videoLoader == true &&
                                                    controller.video != null
                                                ? CircularProgressIndicator(
                                                    color: AppColors.primary,
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
                                                icon: const Icon(Icons.cancel,
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
                                    read.descriptionController.clear();
                                    read.locationController.clear();
                                    read.firstAnswerController.clear();
                                    read.secondAnswerController.clear();
                                    read.selectedIssueStatus = "Open";
                                    read.selectedCategory = null;
                                    read.selectedCategoryId = null;
                                    read.selectedCountryId = null;
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
                                  title: "UPDATE",
                                  onTap: () {

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
                                              controller.selectedIssueStatus =="Open" ? "0":"1",
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
                                      print(
                                          "img===${controller.images.first}");
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
                                            read.selectedReports.clear();
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
                                    }

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
                            controller.pickImage(ImageSource.camera,1);
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
                            controller.pickImage(ImageSource.gallery,1);
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
                            controller.pickVideo(1);
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


void _showMultiSelectAssignReport(BuildContext context, IssueController provider) {
  TextEditingController searchController = TextEditingController();
  List<AssignReport> filteredItems = List.from(provider.assignReport);

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    isScrollControlled: true, // Makes the bottom sheet full-height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0), // Padding for content
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
              // color: AppColors.white,
              // decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
              // padding: const EdgeInsets.all(16.0), // General padding for bottom sheet content
              // height: MediaQuery.of(context).size.height * 0.85, // Adjust height of bottom sheet
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title of the bottom sheet
                  Text(
                    "Select User",
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
                  const SizedBox(height: 5),
                  Text("If you can’t find your Delegate, please contact your Union to add them.",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.grey),),
                  const SizedBox(height: 10),

                  // Filtered List of AssignReports
                  Expanded(
                    child: ListView(
                      children: filteredItems.map((category) {
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          activeColor: AppColors.primary,

                          value: provider.selectedReportsIdDetail
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
                              provider.toggleReportSelectionDetail();
                              provider.toggleReportSelection1Deatil(
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

