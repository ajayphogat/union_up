
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Home/ViewModel/home_controller.dart';
import 'package:union_up/App/Task/ViewModel/controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Widget/routers.dart';

import '../../../Common/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Consumer<HomeController>(
      builder: (context, controller, child) => Scaffold(
        // appBar: appBar(),
        body: SafeArea(
            child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            assignTask(context, width),
            const SizedBox(
              height: 10,
            ),
            top(context, controller),
            const SizedBox(
              height: 10,
            ),
            task(context, width, height, controller),
            const SizedBox(
              height: 15,
            ),
            activity(context, width, height, controller),
            const SizedBox(
              height: 15,
            ),
            event(context, width, height, "Group", controller.groups),
            const SizedBox(
              height: 15,
            ),
            event(context, width, height, "Event", controller.events),
            const SizedBox(
              height: 30,
            ),
          ],
        )),
      ),
    );
  }

  Widget assignTask(BuildContext context, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: RichText(
                      text: TextSpan(
                          text: "John Doe",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                          children: [
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: "assigned",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.black)),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        const TextSpan(text: "You"),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 5,
                        )),
                        TextSpan(
                            text: "a Task. Aug 8,2024 at 11:25 AM",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.black)),
                      ])),
                ),
                Expanded(
                    flex: 1,
                    child: Image.asset(
                      close,
                      width: 25,
                      height: 25,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget top(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Card(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Issues",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.black)),
                            Text("${controller.homeData?.issuesCount ?? 0}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black)),
                          ],
                        ),
                        Image.asset(
                          issue,
                          height: 35,
                        )
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Card(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Heads Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.black)),
                            Text("${controller.homeData?.headsUpCount ?? 0}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black)),
                          ],
                        ),
                        Image.asset(
                          headsUp,
                          height: 35,
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget task(
      BuildContext context, double width, height, HomeController controller) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tasks",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    openAllTaskScreen(
                      context,
                    );
                  },
                  child: Text(
                    "See All",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 45,
                child: ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      controller.updateTaskIndex(
                          index); // Update selected index on tap
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: controller.selectedIndexTask == index
                              ? AppColors.containerColor // Selected color
                              : AppColors.scaffoldColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Text(
                                index == 0 ? "Assign to you" : "OverDue",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        color: controller.selectedIndexTask ==
                                                index
                                            ? AppColors.primary
                                            : AppColors.black),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color:
                                          controller.selectedIndexTask == index
                                              ? AppColors.primary
                                              : AppColors.black,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: Text(
                                    index == 0
                                        ? "${controller.homeData?.assignedCount}"
                                        : "${controller.homeData?.overdueCount}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: AppColors.white),
                                  )))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            controller.selectedIndexTask == 0
                ? taskBody(controller.assignedTasks)
                : taskBody(controller.overdueTasks)
          ],
        ),
      ),
    );
  }

  Widget taskBody(list) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) => ListView.separated(
        itemCount: list.length > 3 ? 3 : list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Divider(
            color: AppColors.grey,
          ),
        ),
        itemBuilder: (context, index) {
          var task = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () {
                  taskController.taskDetail(
                    context,
                    task.taskId.toString(),
                    (value) {
                      if (value == true) {
                        openTaskDetail(context, task.taskId.toString());
                      }
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskTitle ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        // Icon(
                        //   Icons.calendar_month_outlined,
                        //   color: AppColors.grey,
                        // ),
                        Image.asset(calenderIcon,width: 15,),
                        SizedBox(width: 5,),
                        Text(
                          "Due on ${task.dueDate}" ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          task.priority == "High" || task.priority == "high"
                              ? highImage
                              : task.priority == "Medium" || task.priority == "medium"
                                  ? mediumImage
                                  : lowImage,
                          width: 12,
                          height: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          task.priority ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: task.priority == "High" || task.priority == "high"
                              ? AppColors.red
                              : task.priority == "Medium" || task.priority == "medium"
                              ? AppColors.orange
                              : AppColors.primary),
                        )
                      ],
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

  Widget activity(
      BuildContext context, double width, height, HomeController controller) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activity",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "See All",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              // height: 45,
              child: ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(
                    color: AppColors.grey,
                  ),
                ),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lorem ipsum is a dummy text without any sense",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Due to 23 Aug",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.grey),
                        )
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

  Widget event(BuildContext context, double width, height, title, list) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Open Dropdown
                    _showDropdown(context, list);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              "All $title",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.grey),
                            ),
                            Icon(Icons.keyboard_arrow_down_outlined,
                                color: AppColors.grey)
                          ],
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 200,
              child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var data = list[index];
                    return card(context, data.image ?? "", data.name ?? "",
                        data.type ?? "", data.memberCount ?? "");
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                openAllGroupEventScreen(context, list,title);
              },
              child: Container(
                width: width,
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text("See All",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.normal, color: AppColors.grey)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget card(BuildContext context, String img, String title, String subTitle,
      String member) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          // height: 50,
          width: 180,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    img,
                    height: 140,
                    width: 180,
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subTitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColors.grey),
                      ),
                      // SizedBox(width: 10,),

                      Text(
                        "${member} Members",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDropdown(BuildContext context, list) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          // height: MediaQuery.sizeOf(context).height*.7,
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var listData = list[index];
              return ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(listData.image,height: 50, width: 50,fit: BoxFit.fill)),
              title:  Text(listData.name,style: Theme.of(context).textTheme.bodyMedium,),
              subtitle: Text(listData.type,style: Theme.of(context).textTheme.labelSmall),
              onTap: () {
                // Handle selection for Option 1
                Navigator.pop(context);
              },
            );
            },

          ),
        );
      },
    );
  }
}
