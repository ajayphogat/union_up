
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Feed/ViewModel/feed_controller.dart';

import '../../../Common/app_colors.dart';

class AllCommentScreen extends StatelessWidget {
  const AllCommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedController>(
      builder: (context, controller, child) =>  Scaffold(
        appBar: appBar(context),
        body: SafeArea(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
          
              // Initialize visible replies count for each comment (if not already done)
              controller.visibleRepliesCountAllScreen.putIfAbsent(index, () => 1);
          
              // Check if all replies are shown for this comment
              final isShowingAllReplies = controller.visibleRepliesCountAllScreen[index]! >= (comment.replies?.length ?? 0);
          
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.white,
                  borderRadius: BorderRadius.circular(10)),
                  
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      CommentTreeWidget<Comment, Comment>(
                        comment,
                        comment.replies?.sublist(0, controller.visibleRepliesCountAllScreen[index]!) ?? [], // Limit replies shown
                        treeThemeData: const TreeThemeData(
                          lineColor: Colors.grey,
                          lineWidth: 2,
                        ),
                        avatarRoot: (context, data) => PreferredSize(
                          preferredSize: const Size.fromRadius(18),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(data.avatar ?? ''),
                            radius: 18,
                          ),
                        ),
                        avatarChild: (context, data) => PreferredSize(
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
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data.content ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
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
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data.content ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          );
                        },
                      ),
                  
                      // Show "Show More Replies" button for each comment within the list view builder
                      if (!isShowingAllReplies) ...[
                        TextButton(
                          onPressed: () {

                            controller.showCommentIndexAllCommentScreen(index,comment.replies?.length ?? 0);
                  
                          },
                          child: const Text("Show More Replies"),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.white,
      leading: Center(
        child: Row(
          children: [
            SizedBox(width: 20,),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios)),
            SizedBox(width: 10,),
            Text(
              "All Comments",
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.black),
            ),
          ],
        ),
      ),
      leadingWidth: 175,
      // actions: [
      //   Icon(
      //     Icons.search,
      //     color: AppColors.grey,
      //   ),
      //   const SizedBox(width: 15),
      // ],
    );
  }
}
