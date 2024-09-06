import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Bottom/View/bottom_bar_screen.dart';

import 'App/Auth/View/login_screen.dart';
import 'App/Auth/ViewModel/auth_controller.dart';
import 'App/Home/ViewModel/home_controller.dart';
import 'App/Issue/ViewModel/issue_controller.dart';
import 'App/More/ViewModel/more_controller.dart';
import 'App/Task/ViewModel/controller.dart';
import 'Common/image_path.dart';
import 'Config/shared_prif.dart';
import 'Config/theme.dart';



// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Color of the status bar
    statusBarIconBrightness: Brightness.dark, // Brightness of status bar icons
    statusBarBrightness: Brightness.light, // Status bar brightness for iOS
    systemNavigationBarColor: Colors.white, // Color of the system navigation bar (Android)
    systemNavigationBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: true,
    // Brightness of navigation bar icons (Android)
  ));
  await SharedStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider<IssueController>(
          create: (context) => IssueController(),
        ),
        ChangeNotifierProvider<TaskController>(create: (context) => TaskController(),
        ),
        ChangeNotifierProvider<MoreController>(create: (context) => MoreController(),
        ),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      // theme: ThemeData(
      //
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool introSeen = false;
  bool isLogin = false;
  String? loggedRole;
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    a();
    // requestPermission();
    // getToken();

    introSeen = SharedStorage.localStorage?.getBool("introSeen") ?? false;
    isLogin = SharedStorage.localStorage?.getBool(SharedStorage.isLogin) ?? false;
    Timer(const Duration(seconds: 5), () => checklogin());
  }

  HomeController controller =HomeController();

  a(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller = Provider.of<HomeController>(context, listen: false);
      if(isLogin) {
        controller.getHomeData(context);
      }
    });

  }


  checklogin() {
    // Future.delayed(const Duration(seconds: 2)).then((value) {
    setState(() {
      // if (introSeen == false) {
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const IntroductionScreen(),
      //       ));
      // } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
            // const BottomBarScreen(type: 1,index: 0,),
            isLogin == false ? const LoginScreen() : const BottomBarScreen(type: 1,index: 0,),
          ));
      // }
    });
    // });
  }


  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }

  // void getToken() async {
  //   String token = await messaging.getToken() ?? "";
  //
  //  await SharedStorage.localStorage?.setString(SharedStorage.deviceId, token);
  //   print("Device Token: $token");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
              appLogo,
              width: MediaQuery.sizeOf(context).width
          ),
        ),
      ),
    );
  }



}

