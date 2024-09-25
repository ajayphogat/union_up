// import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Feed/ViewModel/feed_controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Config/shared_prif.dart';
import 'package:union_up/Widget/app_text_field.dart';
import 'package:union_up/Widget/routers.dart';

import '../../../Common/app_colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .sizeOf(context)
        .width;
    double height = MediaQuery
        .sizeOf(context)
        .height;
    return Consumer<FeedController>(builder: (context, controller, child) =>
        Scaffold(
          appBar: appBar(context),
          body: SafeArea(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              // physics: NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 10,),

                searchField(context, width, controller),

                const SizedBox(
                  height: 5,
                ),
                filterList(context, width),
                const SizedBox(
                  height: 5,
                ),

                Expanded(

                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: allFeedList(context, height, width, controller)),

              ],
            ),
          )),
        ),);
  }

  /// AppBar
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.white,
      leading: Center(
        child: Text(
          "Feeds",
          textAlign: TextAlign.center,
          style: Theme
              .of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.black),
        ),
      ),
      leadingWidth: 80,
      actions: [
        Icon(
          Icons.search,
          color: AppColors.grey,
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget searchField(BuildContext context, width, FeedController controller) {
    return AppTextFormWidget(
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      hintText: "Share what's on your mind ${SharedStorage.instance.userName}",
      controller: controller.ideasController,
      hintStyle: Theme
          .of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.grey),
      // style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
      prifixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              userImage, width: 20, height: 20, fit: BoxFit.cover,)),
      ),
    );
  }

  Widget filterList(BuildContext context, width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30,
        width: width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () {
                // filterDialogWithCategory(context, controller, width);
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
                          "All",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                // filterDialogWithCategory(context, controller, width);
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
                          "My Group",
                          style: Theme
                              .of(context)
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
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                // filterDialogWithCategory(context, controller, width);
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
                          "Connection",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allFeedList(context, height, width, controller) {
    return ListView.builder(
      itemCount: 3,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: feedCard(context, height, width, controller),
          ),);
  }

  Widget feedCard(BuildContext context, height, width,
      FeedController controller,) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [

          SizedBox(height: 10,),
          Row(children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    userImage, width: 45, height: 45, fit: BoxFit.cover,)),),

            SizedBox(width: 10,),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(SharedStorage.instance.userName ?? "", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),),
                   Text("2 year ago", style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                      fontWeight: FontWeight.normal, color: AppColors.black)),

                ],
              ),
            ),
            Expanded(child: const Icon(Icons.more_vert),)
          ],),

          SizedBox(height: 10,),
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(testImage, height: height * .3,
                width: width,
                fit: BoxFit.cover,)),
          const SizedBox(height: 2,),
          Row(children: [
            Expanded(flex: 2, child: Row(
              children: [
                Image.asset(likeIcon, width: 17, height: 17,),
                Image.asset(loveIcon, width: 15, height: 15),
                const SizedBox(width: 5,),
                Text("You & John", style: Theme
                    .of(context)
                    .textTheme
                    .labelSmall)
              ],
            )),
            Expanded(flex: 1,
                child: Text("${controller.comments.length} Comment",
                  textAlign: TextAlign.end, style: Theme
                      .of(context)
                      .textTheme
                      .labelSmall,)),

          ],),
          const SizedBox(height: 5,),
          const Divider(),
          const SizedBox(height: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(likeTextIcon, width: 70, height: 20,),
              GestureDetector(
                  onTap: () {
                    openAllCommentScreen(context);
                  },
                  child: Image.asset(commentTextIcon, width: 90, height: 25)),
            ],),
          const SizedBox(height: 5,),
          const Divider(),
          const SizedBox(height: 5,),

          commentList(context, controller)

        ],
      ),
    );
  }

  Widget commentList(BuildContext context, FeedController controller) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.visibleCommentsCount,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final comment = controller.comments[index];

        controller.visibleRepliesCount.putIfAbsent(index, () => 1);
        final isShowingAllReplies = controller.visibleRepliesCount[index]! >=
            (comment.replies?.length ?? 0);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CommentTreeWidget<Comment, Comment>(
                comment,
                comment.replies?.sublist(
                    0, controller.visibleRepliesCount[index]!) ?? [],
                // Limit replies shown
                treeThemeData: const TreeThemeData(
                  lineColor: Colors.grey,
                  lineWidth: 2,
                ),
                avatarRoot: (context, data) =>
                    PreferredSize(
                      preferredSize: const Size.fromRadius(18),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data.avatar ?? ''),
                        radius: 18,
                      ),
                    ),
                avatarChild: (context, data) =>
                    PreferredSize(
                      preferredSize: const Size.fromRadius(12),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data.avatar ?? ''),
                        radius: 12,
                      ),
                    ),
                contentRoot: (context, data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName ?? '',
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.content ?? '',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Like',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            'Reply',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            controller.convertDate(data.date ?? ""),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                contentChild: (context, data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName ?? '',
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.content ?? '',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  );
                },
              ),

              if (!isShowingAllReplies) ...[
                TextButton(
                  onPressed: () {
                    controller.showCommentIndex(index, comment.replies?.length ?? 0);
                  },
                  child: const Text("Show More Replies"),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

}

