
import 'package:flutter/material.dart';

import '../../../Common/app_colors.dart';

class DisputeController extends ChangeNotifier{

  final disputeKey = GlobalKey<FormState>();
  TextEditingController searchDisputeController =TextEditingController();

  TextEditingController companyNameController =TextEditingController();
  TextEditingController disputeNameController =TextEditingController();
  TextEditingController shortDescriptionController =TextEditingController();
  TextEditingController longDescriptionController =TextEditingController();

  String? selectedPriority;
  setPriority(value){
    selectedPriority =value;
    notifyListeners();
  }
  String selectedIssueStatus = "Open";


  List<Map<String, dynamic>> status = [
    {
      "id": 1,
      "name": "Open",
      "color": AppColors.lightRed,
      "txt_clr": AppColors.red,
    },
    {
      "id": 2,
      "name": "Close",
      "color": AppColors.lightGreen,
      "txt_clr": AppColors.green,
    },
  ];

}