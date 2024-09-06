import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Task/View/task_screen.dart';
import '../../../Common/app_colors.dart';
import '../../../Common/image_path.dart';
import '../../../Config/shared_prif.dart';
import '../../Home/View/home_screen.dart';
import '../../Home/ViewModel/home_controller.dart';
import '../../Issue/View/issue_screen.dart';
import '../../Issue/ViewModel/issue_controller.dart';
import '../../More/View/more_screen.dart';
import '../../Task/ViewModel/controller.dart';

class BottomBarScreen extends StatefulWidget {
  final int? index;
  final int? type;

  const BottomBarScreen({
    super.key,
    this.index,
    this.type,
  });

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List _widgets = [
    const HomeScreen(),
    // Container(),
    Container(),
    IssueScreen(),
    const TaskScreen(),
    MoreScreen(),

  ];

  @override
  void initState() {
    _selectedIndex = widget.index ?? 0;
    a();
    super.initState();
  }


  IssueController issueController = IssueController();
  TaskController taskController = TaskController();
  HomeController controller = HomeController();

  a() {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      issueController = Provider.of<IssueController>(context, listen: false);
      taskController = Provider.of<TaskController>(context, listen: false);
      controller = Provider.of<HomeController>(context, listen: false);

        controller.getHomeData(context);

      issueController.getIssueList(context);
      issueController.getCategory(context);
      issueController.reportTo(context);

      taskController.reportTo(context);
      taskController.getTaskList(context);
      taskController.taskGroup(context);
      // taskController.reportTo(context);

    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String _getGreeting() {
    var currentHour = DateTime.now().hour;
    if (currentHour < 12) {
      return 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    getPlatformInfo();
    return Scaffold(
      key: _scaffoldkey,
      appBar: _selectedIndex==0 ?appBar():_selectedIndex==4?appBar():null,
      body: _widgets[_selectedIndex],
      backgroundColor: AppColors.scaffoldColor,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            elevation: 15.0,
            backgroundColor: AppColors.white,
            type: BottomNavigationBarType.fixed,

            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.secondaryColor,
            selectedIconTheme: IconThemeData(color: AppColors.primary),
            selectedLabelStyle: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: AppColors.secondaryColor),
            selectedFontSize: 20,
            unselectedFontSize: 20,
            onTap: (index) {
              if (index != 2) {
                _onItemTapped(index);
              }
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  homeIcon,
                  width: 20,
                  color: _selectedIndex == 0
                      ? AppColors.primary
                      : AppColors.secondaryColor,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  feedIcon,
                  width: 20,
                  color: _selectedIndex == 1
                      ? AppColors.primary
                      : AppColors.secondaryColor,
                ),
                label: 'Feeds',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  height: 22,
                ),
                label: 'Issue',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  taskIcon,
                  width: 20,
                  color: _selectedIndex == 3
                      ? AppColors.primary
                      : AppColors.secondaryColor,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  moreIcon,
                  color: _selectedIndex == 4
                      ? AppColors.primary
                      : AppColors.secondaryColor,
                  width: 20,
                ),
                label: 'More',
              ),
            ],
          ),

          platform == "Android" ?
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {
                    _onItemTapped(2);
                  },
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ):
          Positioned(
            bottom: 60,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: Container(
              width: 60,
              height: 56,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 6),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {
                    _onItemTapped(2);
                  },
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String platform="";

  void getPlatformInfo() {
    if (Platform.isAndroid) {
      platform = "Android";
      print("Running on Android");
    } else if (Platform.isIOS) {
      platform = "iOS";
      print("Running on iOS");
    } else if (Platform.isLinux) {
      platform = "Linux";
      print("Running on Linux");
    } else if (Platform.isMacOS) {
      platform = "macOS";
      print("Running on macOS");
    } else if (Platform.isWindows) {
      platform = "Windows";
      print("Running on Windows");
    }
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Image.asset(
          homeTitle,
          width: 100,
        ),
      ),
      leadingWidth: 170,
      actions: [
        Image.asset(
          notification,
          width: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Image.asset(
          homeMore,
          width: 20,
        ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
