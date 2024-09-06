

import 'package:flutter/material.dart';
import 'app_colors.dart';
bool _isSnackBarVisible=false;

showSnackBar({
  String title = "",
  String description = "",
  int durationSec = 2,
  required BuildContext context

}) {

  if(_isSnackBarVisible) {
    _isSnackBarVisible=true;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(
            top: 20.0,
            left: 10,
            right: 10, // This positions the Snackbar at the top
            bottom: MediaQuery.of(context).size.height * .77,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.white),
              ),
              SizedBox(height: 4.0),
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating, // Enables floating positioning
        ),
      ).closed.then((value) {
        _isSnackBarVisible=false;
      },);
  }
}


showSnackBarBottom({
  String title = "",
  String description = "",
  int durationSec = 2,
  required BuildContext context

}) {
  if(_isSnackBarVisible)
  {
    _isSnackBarVisible=true;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 8,
          // width: MediaQuery.sizeOf(context).width*.9,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(10),
          // margin:  EdgeInsets.only(
          //   top: 20.0,
          //   left: 10,
          //   right: 10,// This positions the Snackbar at the top
          //   bottom: MediaQuery.of(context).size.height*.77,
          // ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.white),
              ),
              SizedBox(height: 4.0),
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating, // Enables floating positioning
        ),
      ).closed.then(
        (value) {
          _isSnackBarVisible = false;
        },
      );
  }
}


showError({
  String title = "",
  String description = "",
  required BuildContext context

}){

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..clearSnackBars()
      ..showSnackBar(

    SnackBar(
      width: MediaQuery.sizeOf(context).width*.95,

      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),


      content: Text(description,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),),
      duration: Duration(seconds: 2),

      backgroundColor: AppColors.black,
      behavior: SnackBarBehavior.floating,

    ),
  );



}