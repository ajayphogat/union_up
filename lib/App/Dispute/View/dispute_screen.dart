
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Widget/app_text_field.dart';

import '../../../Common/app_colors.dart';
import '../../../Widget/app_button.dart';
import '../ViewModel/dispute_controller.dart';
import 'package:dotted_border/dotted_border.dart';

class DisputeScreen extends StatelessWidget {
  const DisputeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Consumer<DisputeController>(
      builder: (context, controller, child) =>  Scaffold(
        appBar: appBar(context, "Dispute",controller,width),
        body: SafeArea(child: ListView(
          children: [

          ],
        ),),
      ),
    );
  }
}


PreferredSizeWidget appBar(BuildContext context,String title,DisputeController controller,width) {
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
            title,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.black),
          )
        ],
      ),
    ),
    leadingWidth: 175,

    actions: [
      GestureDetector(
          onTap: () {
            _modalBottomSheetMenu(context, width, controller);
          },
          child
          : Image.asset(addButton,height: 30,)),
      const SizedBox(width: 15),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(65.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
        child: AppTextFormWidget(
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            fillColor: AppColors.lightGrey,
            prifixIcon: Icon(Icons.search,color: AppColors.grey,),
            hintText: "Search", controller: controller.searchDisputeController,
            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.grey)),
      ),
    ),
  );
}

void _modalBottomSheetMenu(
    BuildContext context, width, DisputeController controller) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Consumer<DisputeController>(
          builder: (context, read, child) => StatefulBuilder(
            builder: (context, setState) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.9, // Max height 80% of screen height
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: read.disputeKey,
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
                              const Text(
                                "Add Dispute",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Title and description text fields
                              AppTextFormWidget(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintText: "Company Name",
                                controller: read.companyNameController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                               hintStyle:Theme.of(context)
                                   .textTheme
                                   .bodyLarge?.copyWith(color: AppColors.grey) ,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Company Name required';
                                  }
                                  return null; // Return null if validation passes
                                },

                                onChanged: (p0) {

                                },
                              ),
                              Divider(),


                              AppTextFormWidget(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintText: "Dispute name",
                                controller: read.disputeNameController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                                hintStyle:Theme.of(context)
                                    .textTheme
                                    .bodyLarge?.copyWith(color: AppColors.grey) ,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Dispute name is required';
                                  }
                                  return null; // Return null if validation passes
                                },
                              ),
                              Divider(),
                              AppTextFormWidget(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintText: "Short Description",
                                maxLength: 150,

                                controller: read.shortDescriptionController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                                hintStyle:Theme.of(context)
                                    .textTheme
                                    .bodyLarge?.copyWith(color: AppColors.grey) ,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Short description is required';
                                  }
                                  return null; // Return null if validation passes
                                },
                              ),
                              Divider(),

                              Align(
                                alignment: Alignment.topRight,
                                child: Text("Max 150 character",style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.grey),),),
                              AppTextFormWidget(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                hintText: "Full Description",
                                controller: read.longDescriptionController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                                hintStyle:Theme.of(context)
                                    .textTheme
                                    .bodyLarge?.copyWith(color: AppColors.grey) ,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Full Description is required';
                                  }
                                  return null; // Return null if validation passes
                                },
                              ),
                              Divider(),

                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Add attachment",textAlign: TextAlign.start,style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),)),
                              SizedBox(height: 5,),
                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10),
                                padding: EdgeInsets.all(6),
                                dashPattern: [6, 3,],
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  child: Container(
                                    height: 80,
                                    width: width,
                                    // color: Colors.amber,
                                    child: Center(child: Icon(Icons.add),),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
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
                                                    ...controller.status
                                                        .map((category) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value:
                                                        category["name"]
                                                            .toString(),
                                                        // Ensure this is a String too
                                                        child: Row(
                                                          children: <Widget>[
                                                            // Image.asset(
                                                            //   category[
                                                            //   'img'],
                                                            //   height: 15,
                                                            //   width: 15,
                                                            //   fit: BoxFit
                                                            //       .fitWidth,
                                                            // ),
                                                            // const SizedBox(
                                                            //   width: 5,
                                                            // ),
                                                            Text(
                                                              category["name"],
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.copyWith(
                                                                  color:
                                                                  AppColors.black),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList()
                                                  ],
                                                  onChanged: (newValue) {
                                                    controller.setPriority(
                                                    newValue);
                                                    // controller
                                                    //     .updateGroupValue(
                                                    //     1, false);
                                                  },
                                                  value: controller.selectedPriority,
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down, // You can change this icon to whatever you want
                                                    color: AppColors.grey, // Set the color of the icon
                                                  ),
                                                  decoration:
                                                  const InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10, 10, 10, 5),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border:
                                                    InputBorder.none,
                                                    // Remove underline
                                                    enabledBorder:
                                                    InputBorder.none,
                                                    // Remove underline for enabled state
                                                    focusedBorder: InputBorder
                                                        .none, // Remove underline for focused state
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
                                        ?.copyWith(
                                        color: AppColors.grey,
                                        fontStyle: FontStyle.italic),
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
                                          onTap: () async {
                                            if (!controller.disputeKey.currentState!.validate()) {
                                              // if (controller.selectedPriority ==
                                              //     null) {
                                              //   controller.updateGroupValue(
                                              //       1, true);
                                              // }
                                              // if (controller.selectedReports.isEmpty && controller.selectedReportsId.isEmpty) {
                                              //   controller.updateGroupValue(2, true);
                                              // }

                                              return;
                                            }
                                            else {
                                              //  if (controller.selectedPriority ==
                                              //      null) {
                                              //    controller.updateGroupValue(1, true);
                                              // return;
                                              //  }
                                              // else
                                              // controller.updateGroupValue(1, false);
                                              // if (controller
                                              //         .selectedReports.isEmpty &&
                                              //     controller
                                              //         .selectedReportsId.isEmpty) {
                                              //   controller.updateGroupValue(2,true);
                                              //
                                              //   return;
                                              // }
                                              // controller.updateGroupValue(2, false);


                                            }}
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