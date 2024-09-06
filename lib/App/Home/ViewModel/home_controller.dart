
import 'package:flutter/material.dart';
import 'package:union_up/App/Home/ViewModel/home_api.dart';

import '../Model/home_model.dart';

class HomeController extends ChangeNotifier{

  HomeApi homeApi=HomeApi();

  List<AssignedTasks> assignedTasks = [];
  List<AssignedTasks> overdueTasks = [];
  List<Groups> groups=[];
  List<Groups> events=[];
  HomeData? homeData;

  int selectedIndexTask = 0;
  int get selectedIndex => selectedIndexTask;

  updateTaskIndex(value){
    selectedIndexTask =value;
    notifyListeners();
  }

  getHomeData(BuildContext context)async {
    final result = await homeApi.getHomeData(context);
    if(result != null){
      homeData = result.data;
      assignedTasks = homeData?.assignedTasks ??[];
      overdueTasks = homeData?.overdueTasks ??[];
      groups= homeData?.groups??[];
      events= homeData?.events??[];
      notifyListeners();
    }else{
      notifyListeners();
    }
  }


  // int _selectedIndex = 0;



  // void updateTaskIndex(int index) {
  //   _selectedIndex = index;
  //   notifyListeners();
  // }

}