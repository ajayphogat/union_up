import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Task/ViewModel/controller.dart';
import 'package:union_up/Common/snackbar.dart';
import 'package:union_up/Widget/routers.dart';

import '../../../Common/app_colors.dart';
import '../../../Common/image_path.dart';
import '../../../Widget/app_button.dart';
import '../../../Widget/app_text_field.dart';
import '../../Issue/Model/report_assign_model.dart';
import '../Model/group_model.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Consumer<TaskController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(
          leading: Center(
            child: Text(
              "Tasks",
              textAlign: TextAlign.center,
              style: Theme.of(context)
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
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            _modalBottomSheetMenu(context, width, controller);
          },
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ), // Adjust color accordingly
        ),
        body: SafeArea(
            child:   Column(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      if (!controller.isFetching) {

                        controller.setValue(true, true);
                        controller.setPage();
                        controller.getTaskList(context);

                        Future.delayed(const Duration(seconds: 1)).then(
                                (value) => controller.setValue(false, false));

                        print("isLoading");
                      }
                    }
                    return false;
                  },
                  child: Expanded(
                    child: ListView(

                              children: [body(context, controller, width)],
                            ),
                  ),
                ),

                if(controller.isFetching)
                  Container(
                      height:50,
                      width: width,
                      child: Center(child: CupertinoActivityIndicator(),)),
                if(controller.isFetching)
                  SizedBox(height: 50,)
              ],
            )),
      ),
    );
  }

  Widget body(
      BuildContext context, TaskController controller, double width) {
    return Visibility(
      visible: !controller.taskLoad,
      replacement:const Center(child: CircularProgressIndicator.adaptive(),),
      child: Visibility(
        visible: controller.task.isNotEmpty,
        replacement: Center(
          child: Text("No Issue found",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 35, width: width,
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        controller.updateIndex(index); // Update selected index
                        // });
                      },
                      child: Container(
                        // width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: controller.selectedIndex == index
                                ? AppColors
                                    .primary // Change to primary color if selected
                                : AppColors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Text(
                              "Assign to me",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: controller.selectedIndex == index
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
              height: 5,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.task.length,
              itemBuilder: (context, index) {
                var task = controller.task[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, right: 10, left: 10),
                  child: ListTile(
                    onTap: () {
                      controller.taskDetail(
                        context,
                        task.id.toString(),
                        (value) {
                          if (value == true) {
                            openTaskDetail(context,task.id.toString());
                          }
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title?.rendered ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppColors.black),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                controller.formatDates(task.modified ?? ""),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: AppColors.grey),
                                maxLines: 2,
                              ),
                              const SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                        if (task.status != "")
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: 78,
                              height: 25,
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Center(
                                  child: Text(
                                    task.status ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Row(
                      children: [

                        if(task.dueDate != "")
                        Image.asset(
                          calenderIcon,
                          height: 12,
                        ),
                        if(task.dueDate!="")
                        const SizedBox(
                          width: 5,
                        ),
                        if(task.dueDate != "")
                        Text(
                          "Due on ${controller.convertDate(task.dueDate ?? "" )}",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: AppColors.black),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if(task.priority !="")
                        Image.asset(
                          task.priority == "high" || task.priority == "High"
                              ? highImage
                              : task.priority == "medium"
                                  ? mediumImage
                                  : lowImage,
                          height: 12,
                          width: 12,
                        ),
                        if(task.priority !="")
                        const SizedBox(
                          width: 5,
                        ),
                        if(task.priority !="")
                        Text(
                          task.priority ?? "",
                          style: TextStyle(
                              fontSize: 10,
                              color: task.priority == "high" ||
                                      task.priority == "High"
                                  ? AppColors.red
                                  : task.priority == "medium"
                                      ? AppColors.orange
                                      : AppColors.primary),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (task.assigneUser!.isNotEmpty)
                          Image.asset(
                            userIconImage,
                            height: 12,
                            width: 12,
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (task.assigneUser!.isNotEmpty)
                        Container(
                          width: 70,
                          child: Text(
                            task.assigneUser?[0].name ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                               ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(
      BuildContext context, width, TaskController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
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
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                                const Text(
                                  "Create Task",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Title and description text fields
                                AppTextFormWidget(
                                  hintText: "Tap to add title...",
                                  controller: read.titleController,
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
                                ),
                                AppTextFormWidget(
                                  hintText: "Tap to add a description...",
                                  controller: read.descriptionController,
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
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    DropdownButtonFormField(

                                                      items:[
                                                        DropdownMenuItem<String>(
                                                          value: null,  // Default "Choose" option with null value
                                                          child: Text(
                                                            "Choose",
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                                                          ),
                                                        ),
                                                        ...controller.priorityList
                                                          .map((category) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: category["name"]
                                                              .toString(),
                                                          // Ensure this is a String too
                                                          child: Row(
                                                            children: <Widget>[
                                                              Image.asset(
                                                                category['img'],
                                                                height: 15,
                                                                width: 15,
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                category["name"],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium
                                                                    ?.copyWith(
                                                                        color: category[
                                                                            'color']),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList()],
                                                      onChanged: (newValue) {
                                                        controller.setPriority(newValue);
                                                        controller.updateGroupValue(1,false);
                                                      },
                                                      value:
                                                          controller.selectedPriority,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 10, 5),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                            border: InputBorder.none, // Remove underline
                                                            enabledBorder: InputBorder.none, // Remove underline for enabled state
                                                            focusedBorder: InputBorder.none, // Remove underline for focused state
                                                      ),
                                                    ),
                                                    if(controller.isValidPriority==true && controller.selectedReports.isEmpty )
                                                      Text("Please select a priority",style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.red),),
                Divider(color: AppColors.grey,)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
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
                                                  mainAxisSize: MainAxisSize.min,
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
                                                            color: AppColors.grey),
                                                        controller: controller
                                                            .dateToController,
                                                        validator: (value) {
                                                          if(value!.isEmpty){
                                                            return "Please Select a due date";
                                                          }
                                                          return null;

                                                        },
                                                        hintStyle:
                                                            Theme.of(context)
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                            'Select User/Group',
                                                            style:
                                                                Theme.of(context)
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
                                                                  _showMultiSelectDialog(
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
                                                                          BorderRadius.circular(
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
                                                                  _showMultiSelectGroup(
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
                                                                          BorderRadius.circular(
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
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            controller.selectedReports.isEmpty && controller.selectedReportsId.isEmpty? "Assign to"
                                                          : "${controller.selectedReports.isEmpty?"" :"${controller.selectedReports.length} User"} ${controller.selectedReportsId.isEmpty?"" :"${controller.selectedReportsId.length} Group"}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    color: AppColors
                                                                        .grey),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down_outlined,
                                                            color:
                                                                AppColors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  if(controller.isValid==true && controller.selectedReports.isEmpty &&controller.selectedReportsId.isEmpty )
                                                    Text("Please select a User or Group",style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.red),),



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
                                          ?.copyWith(color: AppColors.grey,fontStyle:FontStyle.italic ),
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
                                        read.titleController.clear();
                                        read.descriptionController.clear();
                                        controller.selectedPriority=null;
                                        controller.dateToController.clear();
                                        controller.selectedReports.clear();
                                        controller.selectedReportsId.clear();
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

                                        if (!controller.createTaskKey.currentState!.validate()) {

                                          if(controller.selectedPriority==null){
                                            controller.updateGroupValue(1,true);

                                          }
                                          if(controller.selectedReports.isEmpty && controller.selectedReportsId.isEmpty){
                                            controller.updateGroupValue(2,true);

                                          }

                                          return;
                                        }

                                        if(controller.selectedPriority==null){
                                          controller.updateGroupValue(1,true);
                                          // showSnackBar(context: context,
                                          //     title: "Warning",
                                          //     description: "Please select priority",);
                                          return;
                                        }
                                        controller.updateGroupValue(1,false);
                                        if(controller.selectedReports.isEmpty && controller.selectedReportsId.isEmpty){
                                          // controller.updateGroupValue(2,true);
                                          // // showError(context: context,description: "Please select Assign to user");
                                          //   showSnackBar(context: context,
                                          //   title: "Warning",
                                          //   description: "Please select Assign to user or Group",
                                          // );
                                            return;

                                        }
                                        controller.updateGroupValue(2,false);

                                        final data = AddTaskModel(
                                            taskTitle: read.titleController.text,
                                            description:
                                                read.descriptionController.text,
                                            priority: controller.selectedPriority ??"",
                                            dueDate:
                                                controller.dateToController.text,
                                            assignUser:
                                                controller.selectedReports ?? [],
                                            assignGroup:
                                                controller.selectedReportsId,
                                            status: "In-Progress");

                                        read.addTaskList(
                                          context,
                                          data,
                                          (value) {
                                            if (value == true) {
                                              read.titleController.clear();
                                              read.descriptionController.clear();
                                              controller.selectedPriority=null;
                                              controller.dateToController.clear();
                                              controller.selectedReports.clear();
                                              controller.selectedReportsId.clear();
                                              Navigator.pop(context);
                                            }
                                          },
                                        );
                                      },
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

  void _showMultiSelectDialog(
    BuildContext context,
    TaskController provider,
  ) {
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
                          hintText: 'Search User',
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
                          value: provider.selectedReports
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
                                child: Text(category.displayName ?? "",
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ],
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              provider.toggleReportSelection(
                                  category.id.toString());
                              // provider.toggleReportSelection1(category.id.toString());
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

  void _showMultiSelectGroup(
    BuildContext context,
    TaskController provider,
  ) {
    TextEditingController searchController = TextEditingController();
    List<TaskGroupData> filteredItems = List.from(provider.groupList);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Group",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: StatefulBuilder(
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
                          hintText: 'Search Group',
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
                          value: provider.selectedReportsId
                              .contains(category.id.toString()),
                          title: Text(category.name ?? ""),
                          onChanged: (bool? value) {
                            setState(() {
                              // provider.toggleReportSelection(category.id.toString());
                              provider.toggleReportSelection1(
                                  category.id.toString());
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
}

class AddTaskModel {
  String taskTitle;
  String? description;
  String? priority;
  String? status;
  String? dueDate;
  List<String>? assignUser;
  List<String>? assignGroup;

  AddTaskModel(
      {required this.taskTitle,
      this.status,
      this.priority,
      this.description,
      this.assignUser,
      this.dueDate,
      this.assignGroup});
}
