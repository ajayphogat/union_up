
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Task/Model/task_detail_model.dart';
import 'package:union_up/App/Task/View/task_screen.dart';
import 'package:union_up/App/Task/ViewModel/task_api.dart';

import '../../../Common/app_colors.dart';
import '../../../Common/image_path.dart';
import '../../../Common/snackbar.dart';
import '../../Home/ViewModel/home_controller.dart';
import '../../Issue/Model/detail_comment_model.dart';
import '../../Issue/Model/report_assign_model.dart';
import '../../Issue/View/issue_detail_sceen.dart';
import '../../Issue/ViewModel/api.dart';
import '../Model/group_model.dart';
import '../Model/task_model.dart';

class TaskController extends ChangeNotifier {

  TaskApi taskApi=TaskApi();
  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController replyCommentController = TextEditingController();


  TextEditingController assigneeController = TextEditingController();

  updateAssignController(){
    assigneeController.text =  "${selectedReports.isEmpty ? "" : "${selectedReports.length} User"} ${selectedReportsId.isEmpty ? "" : "${selectedReportsId.length} Group"}";

  }



  bool isExpanded = false;
  bool taskLoad=false;
  FocusNode commentFocusMode = FocusNode();
  int selectedIndex = -1;
  int selectedActivityIndex = 0;
  List<TaskListModel> task = [];
  List<TaskListModel> archiveList = [];
  final createTaskKey = GlobalKey<FormState>();
  TaskData? taskData;
  List<String> assigneeUserList = [];
  List<String> assigneeGroupList = [];
  List<CommentData> all = [];
  List<CommentData> commentData = [];
  List<CommentData> historyComment = [];
  FocusNode answerFocusNode = FocusNode();
  List<TaskGroupData> groupList= [];
  String? selectedPriority;
  DateTime selectedDate = DateTime.now();
  List<AssignReport> assignReport = [];
  String selectedReportIs= "";
  List<String> selectedReports = [];
  List<String> selectedReportsId = [];

  bool isFetching = false;
  bool pageLoader = false;
  bool pageIncrease = false;
  int pageNo1 = 1;

 bool isTaskDetailOpening = false;

  int? _activeReplyIndex;
  int? get activeReplyIndex => _activeReplyIndex;

  set activeReplyIndex(int? index) {
    if (_activeReplyIndex == index) {
      replyCommentController.clear();
    } else {
      _activeReplyIndex = index;
      replyCommentController.clear();
    }

    notifyListeners();
  }


 updateRoute(value){
   isTaskDetailOpening=value;
   notifyListeners();
 }

  updateExpand(){
     isExpanded = !isExpanded;
     notifyListeners();
  }

  updateFocusNode(){
    commentController.clear();
    commentFocusMode.unfocus();
     notifyListeners();
  }

  updateIndex(value){
    selectedIndex= value;
    notifyListeners();
  }

  updateActivityIndex(value){
    selectedActivityIndex= value;
    notifyListeners();
  }

  List<Map<String,dynamic>> list=[
    {
      "id":1,
      "title":"All"
    },
    {
      "id":2,
      "title":"Comment"
    },
    {
      "id":3,
      "title":"History"
    },
  ];

  getTaskList(BuildContext context)async {
    if(pageNo1==1) {
      taskLoad = true;
    }
    final result = await taskApi.taskListing(context,pageNo1);
    if(result != null){
      if(pageNo1 ==1){
        task.clear();
        task.addAll(result);

        taskLoad = false;
        notifyListeners();
      }else {
        task.addAll(result);
        taskLoad = false;
        notifyListeners();
      }
    }
  }

  addTaskList(BuildContext context,AddTaskModel data,ValueSetter<bool> onResponse)async {
    final result = await taskApi.addTask(context,data);
    if(result == true){
     onResponse(true);
     pageNo1 =1;
     var homeController = Provider.of<HomeController>(context, listen: false);
     homeController.getHomeData(context);
     // ScaffoldMessenger.of(context).showSnackBar(
     //     SnackBar(
     //       content: Text("Task added successfully",style: Theme.of(context).textTheme.labelLarge,),
     //       backgroundColor: AppColors.primary,
     //     ),);
     snackbar(context, "Task added successfully");
     getTaskList(context);
      notifyListeners();
    }
  }

  taskDetail(BuildContext context,String id,ValueSetter<bool> onResponse)async {


    try {
      updateRoute(true);
      taskData=null;
      assigneeUserList.clear();
      assigneeGroupList.clear();
      final result = await taskApi.taskDetail(context,id);
      if(result != null){
        updateRoute(false);
        taskData = result.data;
        assigneeUserList=result.data?.assigneDisplayName ??[];
        assigneeGroupList=result.data?.assigneGroupName ??[];
        getAllComment(context, id);
         onResponse(true);
        notifyListeners();
      }else{
       updateRoute(false);
      }
    } finally {
      // TODO
      updateRoute(false);
    }
  }

  addDetailComment(BuildContext context, AddIssueCommentModel data, ValueSetter<bool> onResponse) async {
    final result = await issueApi.addIssueComment(context, data);

    if (result == true) {
      print(true);
      answerFocusNode.requestFocus();
      onResponse(true);

      getAllComment(context, data.postId);

      notifyListeners();
    }
  }
  List<CommentMeta> commentMeta =[];

  getAllComment( BuildContext context, String id)async{

    commentData.clear();
    all.clear();
    historyComment.clear();

    final allComment = await issueApi.getDetailComment(context, id);
    if(allComment != null)  {
      if (allComment.data != []) {

        all = allComment.data ?? [];
        commentData = allComment.data!
            .where((element) => element.commentType == "comment")
            .toList();
        historyComment = allComment.data!
            .where((element) => element.commentType == "history")
            .toList();
        notifyListeners();
      }
    }else
    {
      all = [];
      commentData = [];
      historyComment = [];
      notifyListeners();
    }

  }

  taskGroup(BuildContext context,)async {
    final result = await taskApi.taskGroup(context,);
    if(result != null){
      groupList = result.data ?? [];
      notifyListeners();
    }
  }

  String formatDates(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Define the desired date format
    DateFormat formatter = DateFormat('dd MMM yyyy');

    String formattedDate = formatter.format(dateTime);

    return 'Updated $formattedDate';
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

    // Format the date to "MMM d, yyyy" (e.g., "Sep 24, 2024")
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    final String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }


  List<Map<String,dynamic>> priorityList= [
    {
      "id":1,
      "name": "High",
      "img" :highImage,
      "color": AppColors.red
    },
    {
      "id":2,
      "name": "Medium",
      "img" : mediumImage,
      "color": AppColors.orange
    },
    {
      "id":3,
      "name": "Low",
      "img" :lowImage,
      "color": AppColors.primary
    },
  ];

  setPriority(value){
    selectedPriority =value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context,) async {
    DateTime? initialDate;
    DateTime? firstDate;

    initialDate = selectedDate;

    firstDate = DateTime.now();



    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2101),
      selectableDayPredicate: (day) => true,
      initialDatePickerMode: DatePickerMode.day,

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.light(primary: AppColors.primary),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate = picked;
      dateToController.text = formatDate(picked);
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  reportTo(BuildContext context) async {
    print("calling api for find list");
    final result = await issueApi.reportToCategory(context);
    if (result != null) {
      assignReport = result.data ?? [];
      if (assignReport.isNotEmpty) {
        selectedReportIs = assignReport[0].displayName!;
        // print("=====$selectedReportIs");
      }
      print("asssss=== ${assignReport.length}");
      notifyListeners();
    }
  }

  void toggleReportSelection(String reportName) {
    if (selectedReports.contains(reportName)) {
      selectedReports.remove(reportName);
    } else {
      selectedReports.add(reportName);

    }
    notifyListeners();
  }

  void toggleReportSelection1(String id) {
    if (selectedReportsId.contains(id)) {
      selectedReportsId.remove(id);
    } else {
      selectedReportsId.add(id);

    }
    notifyListeners();
  }

  setValue(feched, load) {
    isFetching = feched;
    pageLoader = load;
    notifyListeners();
  }

  setPage() {
    pageIncrease = true;
    // pageNo1++;
    pageNo1 =1;
    notifyListeners();
  }

  bool isValid=false;
  bool isValidPriority=false;

  updateGroupValue(type,value){
    if(type==1){
      isValidPriority=value;
    }else{
      isValid=value;
    }

    notifyListeners();
  }

  IssueApi issueApi =IssueApi();


  TextEditingController editTitleController =TextEditingController();
  TextEditingController editDescriptionController =TextEditingController();
  TextEditingController editDateToController = TextEditingController();
  TextEditingController editAssigneeController = TextEditingController();
  String? selectedPriorityDetail;
  List<String> editSelectedReportsIdGroup = [];
  List<String> selectedReportsUser = [];


  setPriorityDetail(value){
    selectedPriorityDetail =value;
    notifyListeners();
  }

  void editDetail(String date, String title, String subtitle, String priority,
      List<String> assignToDelegateUser, List<String> assignToGroup) {

    // Assign the controllers
    editDateToController.text = date;
    editTitleController.text = title;
    editDescriptionController.text = subtitle;

    // Function to try parsing the date with different formats
    DateTime? parseDate(String dateString) {
      List<DateFormat> dateFormats = [
        DateFormat('MMMM d, yyyy'),   // Format for "September 18, 2024"
        DateFormat('MM/dd/yyyy'),     // Format for "09/30/2024"
        DateFormat('d-MMMM-yyyy'),    // Format for "16-September-2024"
      ];

      for (var format in dateFormats) {
        try {
          return format.parse(dateString);
        } catch (e) {
          // Ignore and try the next format
        }
      }
      // If no format works, return null or handle error
      return null;
    }

    // Parse the date using the helper function
    DateTime? parsedDate = parseDate(date);

    if (parsedDate != null) {
      selectedDate = parsedDate;
      print("Parsed Date: $selectedDate");
    } else {
      print("Invalid date format: $date");
    }

    // Handling priority selection
    if(priority != "") {
      selectedPriorityDetail = priorityList
          .firstWhere(
            (element) =>
                element['name'].toUpperCase() == priority.toUpperCase(),
          )['name']
          .toString();
    }else{
      selectedPriorityDetail =null;
    }

    // Clear and assign delegate users and groups
    selectedReportsUser.clear();
    editSelectedReportsIdGroup.clear();

    selectedReportsUser = assignToDelegateUser;
    editSelectedReportsIdGroup = assignToGroup;

    notifyListeners();
  }


  void toggleReportSelection1Detail(String id) {
    if (editSelectedReportsIdGroup.contains(id)) {
      editSelectedReportsIdGroup.remove(id);
    } else {
      editSelectedReportsIdGroup.add(id);

    }
    notifyListeners();
  }
  void toggleReportSelectionDetail(String reportName) {
    if (selectedReportsUser.contains(reportName)) {
      selectedReportsUser.remove(reportName);
    } else {
      selectedReportsUser.add(reportName);

    }
    notifyListeners();
  }

}