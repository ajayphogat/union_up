import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Home/ViewModel/home_controller.dart';

import '../../../Common/app_colors.dart';
import '../../../Common/image_path.dart';
import '../../../Widget/routers.dart';
import '../../Task/ViewModel/controller.dart';

class AllTaskScreen extends StatelessWidget {
  const AllTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.sizeOf(context).width;
    return Consumer<HomeController>(
      builder: (context, controller, child) => Scaffold(
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

        ),

        body: SafeArea(
            child:   Padding(
              padding: const EdgeInsets.all(8.0),
              child: body(context, controller, width),
            )),
      ),
    );
  }
  Widget body(
      BuildContext context, HomeController controller, double width) {
    return Visibility(
      visible: controller.assignedTasks.isNotEmpty,
      replacement: Center(
        child: Text("No Issue found",
            style: Theme.of(context).textTheme.titleLarge),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          // Container(
          //   height: 35, width: width,
          //   child: ListView.builder(
          //     itemCount: 4,
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //         padding: const EdgeInsets.only(left: 8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             controller.updateIndex(index); // Update selected index
          //             // });
          //           },
          //           child: Container(
          //             // width: 120,
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: AppColors.white,
          //               borderRadius: BorderRadius.circular(20),
          //               border: Border.all(
          //                 color: controller.selectedIndex == index
          //                     ? AppColors
          //                     .primary // Change to primary color if selected
          //                     : AppColors.grey,
          //               ),
          //             ),
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(horizontal: 15.0),
          //               child: Center(
          //                 child: Text(
          //                   "Assign to me",
          //                   style: Theme.of(context)
          //                       .textTheme
          //                       .bodyMedium
          //                       ?.copyWith(
          //                     color: controller.selectedIndex == index
          //                         ? AppColors
          //                         .primary // Change to primary color if selected
          //                         : AppColors.grey,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          Consumer<TaskController>(
            builder: (context, taskController, child) =>  ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.assignedTasks.length,
              itemBuilder: (context, index) {
                var task = controller.assignedTasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.white,borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.grey,
                                ),
                                Text(
                                  "Due on ${task.dueDate}" ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppColors.grey),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  task.priority == "High"
                                      ? highImage
                                      : task.priority == "Medium"
                                      ? mediumImage
                                      : lowImage,
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  task.priority ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppColors.orange),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
