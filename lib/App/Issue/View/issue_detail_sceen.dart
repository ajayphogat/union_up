import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:union_up/App/Issue/ViewModel/issue_controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:video_player/video_player.dart';

import '../../../Common/app_colors.dart';
import '../../../Widget/app_text_field.dart';

class IssueDetailSceen extends StatelessWidget {
  String id;

  IssueDetailSceen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.sizeOf(context).width;
    double height =  MediaQuery.sizeOf(context).height;;
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
              Icon(
                Icons.search,
                color: AppColors.grey,
              ),
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
                        if(controller.commentImage.isNotEmpty || controller.commentFiles.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 50,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => const SizedBox(width: 4,),
                              itemCount: controller.commentImage.length +
                                  controller.commentFiles.length,
                              itemBuilder: (context, index) {
                                if (index < controller.commentImage.length) {
                                  final image = controller.commentImage[index];
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
                                  final file = controller.commentFiles[fileIndex];
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
                          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 0),
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

                        Row(children: [
                        GestureDetector(
                            onTap: () {
                              controller.pickCommentImage(
                                  ImageSource.gallery);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Image.asset(
                                addImageIcon,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        GestureDetector(
                            onTap: () {
                              // var data = AddIssueCommentModel(
                              //     postId: id,
                              //     commentDocs: controller.commentImage.isNotEmpty ? controller.commentImage?[0].path :"");
                              controller.pickFile();

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Image.asset(
                                addFileIcon,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              var data = AddIssueCommentModel(
                                  comment: controller.commentController.text,
                                  postId: id,
                                  commentParentId: "",
                                  commentImage: controller.commentImage.isNotEmpty ? controller.commentImage[0].toString() :"",
                                  commentDocs:  controller.commentFiles.isNotEmpty ? controller.commentFiles[0].toString() :""
                              );

                              controller.updateFocusNode();
                              controller.addDetailComment(
                                context,
                                data,
                                    (value) {
                                  if (value == true) {

                                  }
                                },
                              );
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
                        ],),
                        SizedBox(height: 15,)
                      ],
                    ),
                    if(controller.commentAdded)
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

  tab1(BuildContext context, IssueController controller, double width) {
    return ListView(
      children: [
        detailPart(context, controller, width),

        if(controller.questionsAnswers.isNotEmpty)
        Container(
          height: 10,
          width: width,
          color: AppColors.scaffoldColor,
        ),
        if(controller.questionsAnswers.isNotEmpty)
        question(context, controller, width),


        if(controller.issueData?.issueLocation !="")
         Container(
          height: 10,
           width: width,
           color: AppColors.scaffoldColor,
        ),

        if(controller.issueData?.issueLocation !="")
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
                      Text("Comment not found",style: Theme.of(context).textTheme.titleLarge,),
                    ],
                  ),
                ),

                child: ListView.builder(
                  itemCount: controller.selectedActivityIndex == 0
                      ? controller.all.length
                      : controller.selectedActivityIndex == 1
                      ? controller.commentData.length
                      : controller.historyComment.length,
                  // itemCount: 4,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var comment = controller.selectedActivityIndex == 0
                        ? controller.all[index]
                        : controller.selectedActivityIndex == 1
                        ? controller.commentData[index]
                        : controller.historyComment[index];
                    return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15.0,
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
                                ),

                                SizedBox(height: 5,),
                                if(comment.commentMeta !=null)
                                if(comment.commentMeta!.isNotEmpty)
                                Container(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: comment.commentMeta?.length,
                                    itemBuilder: (context, i) {
                                      var meta = comment.commentMeta?[i];
                                      return Padding(padding: EdgeInsets.only(right: 8),

                                        child: meta?.metaValue?.split(".").last !="pdf" ?
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Image View", style: Theme.of(context).textTheme.titleLarge,),
                                                  content: Image.network(meta?.metaValue??"",width: 300,height: 350,fit: BoxFit.fill,),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: Text("OK", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.black),),
                                                    ),

                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.grey),borderRadius: BorderRadius.circular(5)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Image.network(meta?.metaValue ??"",width: 100,height: 100,fit: BoxFit.fill,)),
                                          )):
                                      GestureDetector(
                                        onTap: () {

                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(pdfUrl: meta?.metaValue ??""),));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color: AppColors.grey),borderRadius: BorderRadius.circular(5)),

                                          child: const Icon(
                                            Icons.attach_file,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )  ,
                                      );

                                    },),
                                )
                              ],
                            ),
                          ),
                        );
                  },
                ),
              ),
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
            SizedBox(height: 15,),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: controller.issueData?.issueStatus == "1"
                          ? AppColors.lightGreen
                          : AppColors.lightRed),
                  child: Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                      color: controller.issueData?.issueStatus == "1"
                          ? AppColors.lightGreen
                          : AppColors.lightRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        controller.issueData?.issueStatus == "0"
                            ? "Open"
                            : "Close",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: controller.issueData?.issueStatus == "1"
                                    ? AppColors.green
                                    : AppColors.red),
                      ),
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
                              if (controller.issueData!.issueCategoryNames!.isNotEmpty)
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    controller.issueData?.issueCategoryNames?[0] != null ?  controller.issueData?.issueCategoryNames?.first??
                                        "":"",
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
                              children: [
                                Row(
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          if (controller.issueData != null)
                            if (controller.issueData?.reportIssueUser != null)
                              if (controller
                                  .issueData!.reportIssueUser!.isNotEmpty)
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Notify User",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: AppColors.grey),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_down_outlined)
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

  // question1(BuildContext context, IssueController controller, double width) {
  //   controller.initialize();  // Ensure controllers and icon states are initialized
  //
  //   return Container(
  //     width: width,
  //     color: AppColors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(height: 10),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "Question",
  //                 style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.grey),
  //               ),
  //               Icon(Icons.edit, color: AppColors.grey),
  //             ],
  //           ),
  //           SizedBox(height: 15),
  //           ListView.builder(
  //             itemCount: controller.questionsAnswers.length,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               var data = controller.questionsAnswers[index];
  //               TextEditingController answerController = controller.getController(index);
  //
  //               return Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text(
  //                         "Q",
  //                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
  //                       ),
  //                       const SizedBox(width: 10),
  //                       Expanded(
  //                         child: Text(
  //                           data.question ?? "",
  //                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Text("A"),
  //                       const SizedBox(width: 10),
  //                       AppTextFormWidget(
  //                         width: width * 0.8,
  //                         hintText: "answer",
  //                         controller: answerController,
  //                         // focusNode:controller.shouldShowSuffixIcon(index) ? controller.answerFocusNode : ,
  //                         hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
  //                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
  //                         sufixIcon: controller.shouldShowSuffixIcon(index)
  //                             ? Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               var data = AddIssueCommentModel(
  //                                   comment: answerController.text,
  //                                   postId: id ,
  //                                   commentParentId: controller.issueData!.issueCreatedUserId.toString(),
  //                                   commentImage: "",
  //                                   commentDocs: "");
  //
  //                               controller.updateAnswer(index);  // Update answer and hide suffix icon
  //                               // controller.addIssueComment(context, data, (value) {
  //                               //
  //                               //   if(value==true){
  //                               //
  //                               //   }
  //                               //
  //                               // },);  // Update answer and hide suffix icon
  //                             },
  //                             child: Image.asset(sendMsgIcon, width: 10, height: 10),
  //                           ),
  //                         )
  //                             : null,
  //                         // onFocusChanged: (hasFocus) {
  //                         //   if (hasFocus) {
  //                         //     // Focus gained, show suffix icon
  //                         //     controller.updateFocusIndex(index);
  //                         //   } else {
  //                         //     // Focus lost, handle accordingly if needed
  //                         //     controller.clearFocus();
  //                         //   }
  //                         // },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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
            SizedBox(height: 10),
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
            SizedBox(height: 15),
            ListView.builder(
              itemCount: controller.questionsAnswers.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = controller.questionsAnswers[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Q",
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
                        const Text("A"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            data.answer ?? "",
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
            SizedBox(height: 20,)
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
              controller.issueData?.issueLocation??"",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.grey),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
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
                        controller.location?.latitude ??0.0,
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
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: AppColors.grey,),borderRadius: BorderRadius.circular(5)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    data,
                                    width: 100,
                                    height: 150,
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
                            var data = controller.issueDetailVideo[index];
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Center(
                                    child: FutureBuilder(
                                      future: controller.initializeVideoPlayerFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          return AspectRatio(
                                            aspectRatio: controller.viController.value.aspectRatio,
                                            child: VideoPlayer(controller.viController),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,left: 0,right: 0,bottom: 0,
                                    child: GestureDetector(
                                  onTap: () {
                                    if (controller.viController.value.isPlaying) {
                                      controller.pause();
                                    } else {
                                      controller.play();
                                    }
                                  },
                                  child: Icon(
                                    controller.viController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                ))
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  String? commentImage;
  String? commentDocs;

  AddIssueCommentModel(
      { this.comment,
      required this.postId,
       this.commentParentId,
       this.commentImage,
       this.commentDocs});
}

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl ;
  PdfViewerPage({super.key, required this.pdfUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}