

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Common/image_path.dart';

class FeedController extends ChangeNotifier {

  TextEditingController ideasController =TextEditingController();
  int visibleCommentsCount = 1;
  int? selectedCommentIndex;
  Map<int, int> visibleRepliesCount = {};
  Map<int, int> visibleRepliesCountAllScreen = {};


  showCommentIndex(index,value){
    visibleRepliesCount[index]= value;
    notifyListeners();

  }

  showCommentIndexAllCommentScreen(index,value){
    visibleRepliesCountAllScreen[index]= value;
    notifyListeners();

  }

  String convertDate(String date) {
    DateTime dateTime;

    try {
      // Try parsing ISO 8601 format (e.g., "2024-08-12T05:30:56")
      dateTime = DateTime.parse(date);
    } catch (e) {
      try {
        // Try parsing "MM/dd/yyyy hh:mm a" (e.g., "09/03/2024 10:59 AM")
        dateTime = DateFormat("MM/dd/yyyy hh:mm a").parse(date);
      } catch (e) {
        try {
          // Try parsing "MM/dd/yyyy" (e.g., "09/05/2024")
          dateTime = DateFormat("MM/dd/yyyy").parse(date);
        } catch (e) {
          try {
            // Try parsing "MMMM d, yyyy" (e.g., "September 10, 2024")
            dateTime = DateFormat("MMMM d, yyyy").parse(date);
          } catch (e) {
            try {
              // Try parsing "dd-MM-yyyy" (e.g., "24-9-2024")
              dateTime = DateFormat("dd-MM-yyyy").parse(date);
            } catch (e) {
              return "Invalid Date Format";
            }
          }
        }
      }
    }

    // Calculate the difference from today
    DateTime today = DateTime.now();
    Duration difference = today.difference(dateTime);

    // Format the date to "MMM d, yyyy" (e.g., "Sep 24, 2024")
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    final String formattedDate = formatter.format(dateTime);

    // Return the formatted date and the difference in days
    String differenceText = _formatDifference(difference);

    return differenceText;
  }

// Helper function to format the difference in a readable way
  String _formatDifference(Duration difference) {
    if (difference.isNegative) {

      difference = difference.abs();
      return '${difference.inDays} days from now';
    } else if (difference.inDays == 0) {
      return 'Today';
    } else {
      // The date is in the past
      return '${difference.inDays} days ago';
    }
  }

  // void main() {
  //   String date1 = "2024-08-12T05:30:56";
  //   String date2 = "09/03/2024 10:59 AM";
  //   String date3 = "September 10, 2024";
  //   String date4 = "24-09-2023";  // Date in past
  //
  //   print(convertDate(date1));  // Output: Formatted Date: Aug 12, 2024, Difference from today: XXX days from now
  //   print(convertDate(date2));  // Output: Formatted Date: Sep 3, 2024, Difference from today: XXX days from now
  //   print(convertDate(date3));  // Output: Formatted Date: Sep 10, 2024, Difference from today: XXX days from now
  //   print(convertDate(date4));  // Output: Formatted Date: Sep 24, 2023, Difference from today: XXX days ago
  // }




    final List<Comment> comments = [
    Comment(
      avatar: jenniferImage,
      userName: 'Jennifer',
      content: 'Where is that? Looks beautiful.',
      date: "2024-08-12T05:30:56",
      replies: [
        Comment(
          avatar: markImage,
          userName: 'Mark',
          content: 'It’s in the Swiss Alps.',
          date: "2024-08-22T05:30:56",
        ),
        Comment(
          avatar: userImage,
          userName: 'Mark@',
          content: 'In the Swiss Alps.',
          date: "2024-08-02T05:30:56",
        ),
      ],
    ),
    Comment(
      avatar: jenniferImage2,
      userName: 'Christina',
      content: 'I was there last summer, amazing place!',
      date: "2023-08-12T05:30:56",
      replies: [ Comment(
        avatar: jenniferImage2,
        userName: 'Christina',
        content: 'Summer is the best time!',
        date: "2022-10-07T05:30:56",
      ),],
    ),
    Comment(
      avatar: alisImage,
      userName: 'Alisa perry',
      content: 'Can anyone recommend a good time to visit?',
      date: "2022-09-18T05:30:56",
      replies: [
        Comment(
          avatar: jenniferImage2,
          userName: 'Christina',
          content: 'Summer is the best time!',
          date: "2022-10-07T05:30:56",
        ),
        Comment(
          avatar: johnImage,
          userName: 'John',
          content: 'Yes, June to August is perfect.',
          date: "2022-09-22T05:30:56",
        ),
      ],
    ),
  ];

}


class Comment {
  String? avatar;
  String? userName;
  String? content;
  String? date;
  List<Comment>? replies;

  Comment({
    required this.avatar,
    required this.userName,
    required this.content,
    required this.date,
    this.replies,
  });
}
