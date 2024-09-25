

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_colors.dart';
bool _isSnackBarVisible=false;
//
// showSnackBar({
//   String title = "",
//   String description = "",
//   int durationSec = 2,
//   required BuildContext context
//
// }) {
//
//   if(_isSnackBarVisible) {
//     _isSnackBarVisible=true;
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           elevation: 8,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           padding: EdgeInsets.all(10),
//           margin: EdgeInsets.only(
//             top: 20.0,
//             left: 10,
//             right: 10, // This positions the Snackbar at the top
//             bottom: MediaQuery.of(context).size.height * .77,
//           ),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleLarge
//                     ?.copyWith(color: AppColors.white),
//               ),
//               SizedBox(height: 4.0),
//               Text(
//                 description,
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(color: AppColors.white),
//               ),
//             ],
//           ),
//           duration: Duration(seconds: 3),
//           backgroundColor: AppColors.primary,
//           behavior: SnackBarBehavior.floating, // Enables floating positioning
//         ),
//       ).closed.then((value) {
//         _isSnackBarVisible=false;
//       },);
//   }
// }
//
//
// showSnackBarBottom({
//   String title = "",
//   String description = "",
//   int durationSec = 2,
//   required BuildContext context
//
// }) {
//   if(_isSnackBarVisible)
//   {
//     _isSnackBarVisible=true;
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           elevation: 8,
//           // width: MediaQuery.sizeOf(context).width*.9,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           padding: EdgeInsets.all(10),
//           // margin:  EdgeInsets.only(
//           //   top: 20.0,
//           //   left: 10,
//           //   right: 10,// This positions the Snackbar at the top
//           //   bottom: MediaQuery.of(context).size.height*.77,
//           // ),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleLarge
//                     ?.copyWith(color: AppColors.white),
//               ),
//               SizedBox(height: 4.0),
//               Text(
//                 description,
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium
//                     ?.copyWith(color: AppColors.white),
//               ),
//             ],
//           ),
//           duration: Duration(seconds: 3),
//           backgroundColor: AppColors.primary,
//           behavior: SnackBarBehavior.floating, // Enables floating positioning
//         ),
//       ).closed.then(
//         (value) {
//           _isSnackBarVisible = false;
//         },
//       );
//   }
// }
//
//
// showError({
//   String title = "",
//   String description = "",
//   required BuildContext context
//
// }){
//
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..clearSnackBars()
//       ..showSnackBar(
//
//     SnackBar(
//       width: MediaQuery.sizeOf(context).width*.95,
//
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//
//
//       content: Text(description,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),),
//       duration: Duration(seconds: 2),
//
//       backgroundColor: AppColors.black,
//       behavior: SnackBarBehavior.floating,
//
//     ),
//   );






// }
// void showTopSnackBar(BuildContext context, String message) {
//   final overlay = Overlay.of(context);
//   final mediaQuery = MediaQuery.of(context);
//
//   // Determine keyboard height
//   double keyboardHeight = mediaQuery.viewInsets.bottom;
//
//   final overlayEntry = OverlayEntry(
//     builder: (context) => Positioned(
//       bottom: mediaQuery.viewInsets.bottom + (keyboardHeight > 0 ? 16.0 : 80.0), // Adjust Bottom position based on keyboard visibility
//       left: 0,
//       right: 0,
//       child: Material(
//         color: Colors.transparent,
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 message,
//                 style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
//
//   // Insert the overlay entry
//   overlay?.insert(overlayEntry);
//
//   // Remove the overlay entry after a delay
//   Future.delayed(Duration(seconds: 3)).then((value) => overlayEntry.remove());
// }


void snackbar(BuildContext context, String msg) {
  if (!_isSnackBarVisible) {
    _isSnackBarVisible = true;

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );

    _isSnackBarVisible = false;
  }
}

abstract class ToastShow{
  static Future<bool?> returnToast(String msg){
    return  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}


