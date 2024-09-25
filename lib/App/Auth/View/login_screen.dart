import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:union_up/App/Auth/View/register_screen.dart';
import 'package:union_up/Common/image_path.dart';
import '../../../Common/app_colors.dart';
import '../../../Widget/app_button.dart';
import '../../Bottom/View/bottom_bar_screen.dart';
import '../ViewModel/auth_controller.dart';

final shorebirdCodePush = ShorebirdCodePush();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    shorebirdCodePush
        .currentPatchNumber()
        .then((value) => print('current patch number is $value'));
    super.initState();
  }

  Future<void> _checkForUpdates() async {
    // Check whether a patch is available to install.
    final isUpdateAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();

    if (isUpdateAvailable) {
      // Download the new patch if it's available.
      await shorebirdCodePush.downloadUpdateIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Consumer<AuthController>(
      builder: (context, authProvider, child) => Scaffold(
        // backgroundColor: AppColors.primary,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: authProvider.formKey,
              child: Container(
                height: height,
                width: width,
                child: Stack(
                  children: [
                    Container(
                        height: height,
                        child: Column(
                          children: [
                            Container(
                                height: height * .45,
                                child: Image.asset(
                                  loginImage,
                                  height: height * .5,
                                  width: width,
                                  fit: BoxFit.fill,
                                )),
                            const SizedBox()
                          ],
                        )),
                    Positioned(
                        top: height * .3,
                        left: 0,
                        right: 0,
                        child: bodyPart(context, height, width, authProvider)),
                    if(authProvider.isLoginLoad==true)
                       const Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Center(child: CircularProgressIndicator.adaptive(),))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyPart(BuildContext context, double height, double width,
      AuthController authProvider) {
    return Container(
      width: width,
      height: height * .7,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * .04,
            ),
            Text(
              "Login",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            const SizedBox(height: 15,),
            Text(
              "Login to access your unionUp account",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),

            SizedBox(
              height: height * .035,
            ),
            Text(
              "Email Address *",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Card(
              elevation: 5,
              surfaceTintColor: AppColors.primary,
              shadowColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: .06),
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  cursorColor: AppColors.primary,

                  controller: authProvider.loginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      // contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      fillColor: AppColors.white,
                      filled: true,
                      // prefixIcon: Icon(
                      //   Icons.mail,
                      //   color: AppColors.white,
                      // ),
                      hintText: 'Enter your email address',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.grey)),
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.black),
                  focusNode: authProvider.loginEmail,
                  textAlign: TextAlign.start,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Please enter email";
                    } else if (!authProvider.validateEmail(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            // RichText(text: TextSpan(
            //   children:
            //     [
            //       TextSpan(text: "Password")
            //     ]
            // )),
            Text(
              "Password *",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              shadowColor: AppColors.primary,
              surfaceTintColor: AppColors.primary,
              color: AppColors.white,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: .06),
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  cursorColor: AppColors.primary,

                  controller: authProvider.loginPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: authProvider.loginObscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                    fillColor: AppColors.white,
                    hintText: 'Enter your password',
                    filled: true,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: AppColors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        authProvider.loginObscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        authProvider.loginTogglePasswordVisibility();
                      },
                    ),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.black),
                  maxLines: 1,
                  focusNode: authProvider.loginPass,
                  textAlign: TextAlign.start,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter password";
                    }
                    // else if (value.length < 6 ||  value.length>16) {
                    //   return "Password should be 6 to 16 digit";
                    // }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // Get.to(ForgotPasswordScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Forgot Your Password?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                  ),
                )),
            SizedBox(
              height: height * .05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppButton(
                height: 55,
                radius: 10,
                bgColor: AppColors.primary,
                title: "LOGIN",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
                onTap: ()async {

                  _checkForUpdates();
                  if(authProvider.isLoginLoad==true){
                    return;
                  }

                  if (!authProvider.formKey.currentState!.validate()) {
                    return;
                  }
                   final data= LoginDataModel(
                       email: authProvider.loginEmailController.text,
                       password: authProvider.loginPasswordController.text);

                  authProvider.loginUser(context, data, (value) {
                    if(value){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomBarScreen(
                              index: 0,
                            ),
                          ));
                    }
                  },);


                },
              ),
            ),
            const Spacer(),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Don’t have an account? ",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.secondaryColor,
                          ),
                      children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ));
                        },
                      text: " Sign Up",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    )
                  ])),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
class LoginDataModel{
  String email;
  String password;
  LoginDataModel({required this.email,required this.password});
}