import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Issue/ViewModel/api.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Common/snackbar.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../../Common/app_colors.dart';
import '../../Home/ViewModel/home_controller.dart';
import '../Model/detail_comment_model.dart';
import '../Model/issue_category_model.dart';
import '../Model/issue_detail_model.dart';
import '../Model/issue_model.dart';
import '../Model/palaces_model.dart';
import '../Model/report_assign_model.dart';
import '../View/issue_detail_sceen.dart';
import '../View/issue_screen.dart';

class IssueController extends ChangeNotifier {
  IssueApi issueApi = IssueApi();

  TextEditingController dateToController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController firstAnswerController = TextEditingController();
  TextEditingController secondAnswerController = TextEditingController();

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusMode = FocusNode();
  final issueAddFormKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();
  List<bool> expandedStates = [];

  List<bool> checkboxStates = [];

  updateFocusNode() {
    commentController.clear();
    commentImage.clear();
    commentFiles.clear();
    commentFocusMode.unfocus();
    notifyListeners();
  }

  int isIssue = 0;

  updateIssueT(value) {
    isIssue = value;
    notifyListeners();
  }

  Future<void> selectDate(
    BuildContext context,
  ) async {
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

  List<CategoryData> categoryList = [];
  List<CategoryData> filterCategoryList = [];
  List<AssignReport> assignReport = [];
  String? selectedCountryId;
  String? selectedCategory;
  CategoryData? selectedCategoryData;
  String? selectedCategoryId;

  getCategory(BuildContext context) async {
    final result = await issueApi.issueCategory(context);
    if (result != null) {
      categoryList = result.data ?? [];
      checkboxStates = List.generate(categoryList.length, (index) => false);
      notifyListeners();
    }
  }

  updateCheckBoxIndex(index, value) {
    checkboxStates[index] = value;
    notifyListeners();

    // if(filterCategoryList.isNotEmpty) {
    //
    //   for (var i = 0; i > filterCategoryList.length; i++) {
    //     filterIssueList =
    //         issueList.where((element) =>
    //         element.category.toString() == filterCategoryList[i].issueCategoryName.toString(),).toList();
    //     notifyListeners();
    //   }
    // }else{
    //   // filterIssueList.clear();
    //   notifyListeners();
    // }
  }

  List<IssueListModel> issueList = [];

  List<IssueListModel> filterIssueList = [];

  List<IssueListModel> archiveList = [];

  TextEditingController ansController = TextEditingController();

  TextEditingController saveController(String value) {
    ansController.text = value;
    return ansController;
  }

  bool isFetching = false;
  bool pageLoader = false;
  bool pageIncrease = false;
  int pageNo1 = 1;

  setValue(feched, load) {
    isFetching = feched;
    pageLoader = load;
    notifyListeners();
  }

  setPage() {
    pageIncrease = true;
    print("pageNo1====$pageNo1");
    pageNo1++;
    notifyListeners();
  }

  bool taskLoad = false;

  getIssueList(
    BuildContext context,
  ) async {
    if (pageNo1 == 1) {
      taskLoad = true;
    }
    final result = await issueApi.issueListing(context, pageNo1);
    if (result != null) {
      if (pageNo1 == 1) {
        issueList.clear();
        archiveList.clear();
        issueList.addAll(result);
        archiveList.addAll(result
            .where(
              (element) => element.issueArchive == "1",
            )
            .toList());
      }
      taskLoad = false;
      notifyListeners();
    } else {
      issueList.addAll(result ?? []);
      taskLoad = false;
      notifyListeners();
    }
  }

  void removeIssue(int index) {
    issueList.removeAt(index); // Remove the issue at the specified index
    notifyListeners(); // Notify the UI about the change
  }

  dayDiff(givenDateStr) {
    // Given date string
    // final givenDateStr = "2024-08-14T07:26:03";

    final givenDate = DateTime.parse(givenDateStr);

    final now = DateTime.now();

    final difference = now.difference(givenDate);
    return difference.inDays;
  }

  reportTo(BuildContext context) async {
    print("calling api for find list");
    final result = await issueApi.reportToCategory(context);
    if (result != null) {
      assignReport = result.data ?? [];
      if (assignReport.isNotEmpty) {
        // selectedReportIs = assignReport[0].displayName!;
        print("=====$selectedReportIs");
      }
      print("asssss=== ${assignReport.length}");
      notifyListeners();
    }
  }

  setCategory(
    value,
  ) {
    selectedCountryId = value;
    notifyListeners();
  }

  setCategoryName(id, name, data) {
    // selectedCountryId = value;
    selectedCategory = name;
    selectedCategoryId = id;
    selectedCategoryData = data;
    print(selectedCategory);
    notifyListeners();
  }

  String selectedIssueStatus = "Open";

  updateIssueStatus(value) {
    selectedIssueStatus = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> status = [
    {
      "id": 1,
      "name": "Open",
      "color": AppColors.lightGreen,
      "txt_clr": AppColors.green,
    },
    {
      "id": 2,
      "name": "Close",
      "color": AppColors.lightRed,
      "txt_clr": AppColors.red,
    },
  ];

  List<Map<String, dynamic>> priorityList = [
    {"id": 1, "name": "High", "img": highImage, "color": AppColors.red},
    {"id": 2, "name": "Medium", "img": mediumImage, "color": AppColors.orange},
    {"id": 3, "name": "Low", "img": lowImage, "color": AppColors.primary},
  ];

  bool isValid = false;
  bool isValidPriority = false;
  bool isValidNotify = false;

  updateGroupValue(type, value) {
    if (type == 1) {
      isValidPriority = value;
    } else if (type == 2) {
      isValid = value;
    } else {
      isValidNotify = value;
    }

    notifyListeners();
  }

  String? selectedPriority;

  String? selectedReportIs;
  String selectedReportId = "";
  List<AssignReport> selectedAssignNotify = [];

  List<String> selectedNotifyList = [];

  void updateSelectedItems(String item) {
    if (selectedNotifyList.contains(item)) {
      selectedNotifyList.remove(item);
    } else {
      selectedNotifyList.add(item);
    }
    notifyListeners(); // This will notify all listeners to rebuild
  }

  List<String> selectedReports = [];
  List<String> selectedReportsId = [];

  void toggleReportSelection(String image) {
    if (selectedReports.contains(image)) {
      selectedReports.remove(image);
    } else {
      selectedReports.add(image);
      print("--=-=-=-=" + selectedReports[0]);
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

  String selectedAssignTo = "High";
  String selectedNotify = "High";

  setPriority(value) {
    selectedPriority = value;
    notifyListeners();
  }

  setReport(value) {
    selectedReportIs = value;
    notifyListeners();
  }

  setReportId(value) {
    selectedReportId = value;
    notifyListeners();
  }

  setAssignTo(value) {
    selectedAssignTo = value;
    notifyListeners();
  }

  setNotify(value) {
    selectedAssignNotify = value;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  List<File> images = [];
  List<String> commentImage = [];
  List<File> files = [];
  List<String> commentFiles = [];
  VideoPlayerController? vController;
  VideoPlayerController? vPlayer;

  File? videoFile;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));

      notifyListeners();
    }
  }

  Future<void> pickCommentImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      commentImage.add(pickedFile.path);
      notifyListeners();
    }
  }

  XFile? video;
  bool videoLoader = false;

  Future<void> pickVideo() async {
    video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      videoLoader = true;
      // Compress the video
      MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        video!.path,
        quality: VideoQuality.MediumQuality, // Choose the quality you need
        deleteOrigin:
            false, // Set to true if you want to delete the original video
      );

      print("videoFile====$videoFile");
      if (compressedVideo != null) {
        videoFile =
            File(compressedVideo.path!); // Use the path of the compressed video
        VideoCompress.cancelCompression();
        vController = VideoPlayerController.file(videoFile!)
          ..initialize().then((_) {
            vController!.pause();
            notifyListeners();
          });
        videoLoader = false;
        notifyListeners();
      }
      notifyListeners();
    }
  }

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  VideoPlayerController get viController => _controller;

  Future<void> get initializeVideoPlayerFuture => _initializeVideoPlayerFuture;

  VideoPlayerProvider(String videoUrl) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    notifyListeners();
  }

  void play() {
    _controller.play();
    notifyListeners();
  }

  void pause() {
    _controller.pause();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    vController?.dispose();
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        commentFiles.add(result.files.single.path!);

        notifyListeners();
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  addIssue(BuildContext context, AddIssueModel data,
      ValueSetter<bool> onResponse) async {
    final result = await issueApi.addIssue(context, data);

    if (result == true) {
      print(true);
      onResponse(true);
      pageNo1 = 1;
      getIssueList(context);
      var homeController = Provider.of<HomeController>(context, listen: false);
      homeController.getHomeData(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Comment added successfully",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      notifyListeners();
    }
  }

  /// Issue Detail Screen

  TextEditingController showDateController = TextEditingController();

  IssueDeatilData? issueData;

  List<String> issueDetailImage = [];
  List<String> issueDetailVideo = [];
  List<QuestionsAnswers> questionsAnswers = [];

  getIssueDetail(
      BuildContext context, String id, ValueSetter<bool> onResponse) async {
    final result = await issueApi.getIssueDetail(context, id);

    if (result != null) {
      issueData = result.data;
      issueDetailImage = issueData!.issueImages == ""
          ? []
          : issueData!.issueImages!.split(",");
      issueDetailVideo = issueData!.issueVideos == ""
          ? []
          : issueData!.issueVideos!.split(",");
      questionsAnswers = issueData?.questionsAnswers ?? [];

      if (issueData?.issueLocation != "") {
        getLatLongFromAddress(issueData?.issueLocation ?? "");
      }

      getAllComment(context, id);
      print(issueDetailImage.length);
      onResponse(true);
      notifyListeners();
    }
  }

  List<CommentData> all = [];
  List<CommentData> commentData = [];
  List<CommentData> historyComment = [];

  getAllComment(BuildContext context, String id) async {
    commentData.clear();
    all.clear();
    historyComment.clear();

    final allComment = await issueApi.getDetailComment(context, id);
    if (allComment != null) {
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
    } else {
      all = [];
      commentData = [];
      historyComment = [];
      notifyListeners();
    }
  }

  searchCityList(String query) async {
    final res = await issueApi.searchAutocomplete(query);
    if (res != null) {
      searchPlace = res.predictions ?? [];

      notifyListeners();
    }

    // return _allJobModel;
  }

  List<Predictions> searchPlace = [];

  List<TextEditingController> controllerList = [];
  List<bool> _showSuffixIcon = [];

  void initialize() {
    if (controllerList.isEmpty ||
        controllerList.length != questionsAnswers.length) {
      controllerList = List.generate(questionsAnswers.length, (index) {
        return TextEditingController(text: questionsAnswers[index].answer);
      });

      _showSuffixIcon =
          List.generate(questionsAnswers.length, (index) => false);

      // Add listeners to track text changes and show suffix icon accordingly
      for (int i = 0; i < controllerList.length; i++) {
        controllerList[i].addListener(() {
          _showSuffixIcon[i] =
              controllerList[i].text != questionsAnswers[i].answer;
          notifyListeners(); // Notify UI to update icon visibility
        });
      }
    }
  }

  TextEditingController getController(int index) => controllerList[index];

  // Check whether the suffix icon should be shown for a specific index
  bool shouldShowSuffixIcon(int index) => _showSuffixIcon[index];

  // Update the answer and hide the suffix icon for that index
  void updateAnswer(int index) {
    questionsAnswers[index].answer = controllerList[index].text;
    _showSuffixIcon[index] = false;
    notifyListeners();
  }

  FocusNode answerFocusNode = FocusNode();

  bool commentAdded = false;

  addDetailComment(BuildContext context, AddIssueCommentModel data,
      ValueSetter<bool> onResponse) async {
    commentAdded = true;
    final result = await issueApi.addIssueComment(context, data);

    if (result == true) {
      print(true);
      commentAdded = false;
      answerFocusNode.requestFocus();
      onResponse(true);
      getAllComment(context, data.postId);

      notifyListeners();
    } else {
      commentAdded = false;
      onResponse(false);
      getAllComment(context, data.postId);
      notifyListeners();
    }
  }

  archiveIssue(
      BuildContext context, String id, ValueSetter<bool> onResponse) async {
    print(id);
    var result = await issueApi.addArchive(context, id);

    if (result == true) {
      // getIssueList(context);

      onResponse(true);
      notifyListeners();
    }
  }

  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location? location;

  Future<void> getLatLongFromAddress(String address) async {
    location = null;
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        location = locations.first;
        print(
            'Latitude: ${location?.latitude}, Longitude: ${location?.longitude}');
        notifyListeners();
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    // final Uint8List? markerIcon = await getBytesFromAsset(parkingIcon, 25);
    final marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId("point1"),
      position: LatLng(
        location!.latitude,
        location!.longitude,
      ),
    );

    markers[MarkerId("point1")] = marker;
    notifyListeners();
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  int selectedActivityIndex = 0;

  updateActivityIndex(value) {
    selectedActivityIndex = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> list = [
    {"id": 1, "title": "All"},
    {"id": 2, "title": "Comment"},
    {"id": 3, "title": "History"},
  ];
}
