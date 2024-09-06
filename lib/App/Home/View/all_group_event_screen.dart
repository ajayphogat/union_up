
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Home/Model/home_model.dart';

import '../../../Common/app_colors.dart';
class AllGroupEventScreen extends StatelessWidget {
  List<Groups> list;
  String title;
   AllGroupEventScreen({super.key,required this.list,required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) =>  Scaffold(
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
                  "All $title",
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
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              childAspectRatio: .86,crossAxisSpacing: 2,mainAxisSpacing: 4),
              itemBuilder: (context, index) {
                var data = list[index];
                return card(context, data.image ?? "", data.name ?? "",
                    data.type ?? "", data.memberCount ?? "");
              },),
        ),),
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
                    height: 135,
                    width: MediaQuery.sizeOf(context).width*.45,
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                            .titleMedium
                            ?.copyWith(color: AppColors.grey),
                      ),
                      // SizedBox(width: 10,),

                      Text(
                        "${member} Members",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
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

}
