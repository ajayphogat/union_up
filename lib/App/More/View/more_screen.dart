
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/More/ViewModel/more_controller.dart';
import 'package:union_up/Common/image_path.dart';
import '../../../Common/app_colors.dart';


class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key,}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MoreController>(
        builder: (context, controller, child) => SafeArea(
          child: ListView(
            children: [
              titles("Community"),
              community(controller,controller.community),
              titles("Public Libraries"),
              community(controller,controller.libraries),
              titles("Contact"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                    decoration: BoxDecoration(color: AppColors.white,borderRadius: BorderRadius.circular(10)),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: tile(highImage,"Contact us"),
                    )),
              ),
              titles("Boring Stuff"),
              community(controller,controller.stuff),
            ],
          ),
        ),
      ),
    );
  }

  Widget community(MoreController controller,list,){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        decoration: BoxDecoration(color: AppColors.white,borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (BuildContext context, int index) {
              return  Divider(color: AppColors.grey,thickness: .1,);
            },
            itemBuilder: (context, index) {
              var data =list[index];
              return tile(data['img']!, data["title"] ??"");
            },
          ),
        ),
      ),
    );
  }

  Widget tile(img,title){
    return ListTile(
      dense: true,
      onTap: () {

      },
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      horizontalTitleGap: 10,
      leading: Image.asset(
        img,
        width: 25,
        height: 25,

        fit: BoxFit.contain,

      ),
      title: Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.grey)),
      trailing:  Icon(Icons.chevron_right, color: AppColors.grey,),
    );
  }

  Widget titles(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 10,),
        Text(title,style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
      ],),
    );
  }

}
