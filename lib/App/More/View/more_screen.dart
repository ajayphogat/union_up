
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/More/ViewModel/more_controller.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Config/shared_prif.dart';
import 'package:union_up/Widget/routers.dart';
import '../../../Common/app_colors.dart';
import '../../Auth/View/login_screen.dart';


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
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: tile(contactIcon,"Contact us",(){

                  }),
                ),
              ),
              titles("Boring Stuff"),
              community(controller,controller.stuff),
              // titles("LOGOUT"),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,),

                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: tile(logoutIcon,"Log out",(){
                    showAlertDialog(context);
                  }),
                ),
              ),
              SizedBox(height: 35,)
            ],
          ),
        ),
      ),
    );
  }





showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget remindButton = TextButton(
    child:  Text("Logout",style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),),
    onPressed: () {
      String deviceId=  SharedStorage.localStorage?.getString(SharedStorage.deviceId) ?? "";
      SharedStorage.localStorage?.clear();
      SharedStorage.localStorage?.setString(SharedStorage.deviceId,deviceId);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));

    },
  );
  Widget cancelButton = TextButton(
    child:  Text("Cancel",style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.red),),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title:  Text("Logout",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),),
    content: const Text("Are you sure you want to logout ?"),
    actions: [
      cancelButton,
      remindButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  Widget community(MoreController controller,list,){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              return tile(data['img']!, data["title"] ??"",(){

                if( list==controller.libraries){
                  if(index==0){
                    openDisputeScreen(context);
                  }
                }

              });
            },
          ),
        ),
      ),
    );
  }

  Widget tile(img,title,onTap){
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      horizontalTitleGap: 10,
      leading: img != "" ?
      Image.asset(
        img,
        width: 22,
        height: 22,

        fit: BoxFit.contain,

      ):null,
      title: Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.grey)),
      trailing:  Icon(Icons.chevron_right, color: AppColors.grey,),
    );
  }

  Widget titles(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 10,),
        Text(title,style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
      ],),
    );
  }

}


PreferredSizeWidget appBar(BuildContext context,String title) {
  return AppBar(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.white,
    leading: Center(
      child: Text(
        title,
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