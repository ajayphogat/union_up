import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:union_up/App/Auth/View/login_screen.dart';
import 'package:union_up/Common/image_path.dart';
import 'package:union_up/Common/snackbar.dart';
import '../../../Common/app_colors.dart';
import '../../../Widget/app_button.dart';
import '../../Bottom/View/bottom_bar_screen.dart';
import '../ViewModel/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Consumer<AuthController>(
      builder: (context, authProvider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height*1.27,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Form(
                key: authProvider.rFormKey,
                child: Stack(
                  children: [
                    Container(
                        height: height,
                        child: Column(
                          children: [
                            Container(
                                height: height * .4,
                                child: Image.asset(
                                  loginImage,
                                  height: height * .45,
                                  width: width,
                                  fit: BoxFit.fill,
                                )),
                            const SizedBox()
                          ],
                        )),
                    Positioned(
                        top: height * .25,
                        left: 0,
                        right: 0,
                        child: bodyPart(context, height, width, authProvider)),
                    if (authProvider.isRegisterLoad == true)
                      const Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ))
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
      // height: height * .75,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // physics: NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              "Sign Up",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Let’s get you all st up so you can access your personal account.",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
            SizedBox(
              height: height * .03,
            ),
            Text(
              "First Name",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              cursorColor: AppColors.primary,

              controller: authProvider.fNameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  // contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary, // Set the border color here
                      width: 2.0, // Set the border width here
                    ),
                    borderRadius:
                        BorderRadius.circular(8), // Set the border radius here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey, // Border color when not focused
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary, // Border color when focused
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColors.white,
                  filled: true,

                  // prefixIcon: Icon(
                  //   Icons.mail,
                  //   color: AppColors.white,
                  // ),
                  hintText: 'Enter your first name',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.grey)),
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.black),
              textAlign: TextAlign.start,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Please enter your First name";
                }
                return null;
              },
            ),
            SizedBox(
              height: height * .02,
            ),
            Text(
              "Last Name",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(

              cursorColor: AppColors.primary,
              controller: authProvider.lNameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary, // Set the border color here
                      width: 2.0, // Set the border width here
                    ),
                    borderRadius:
                        BorderRadius.circular(8), // Set the border radius here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey, // Border color when not focused
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary, // Border color when focused
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColors.white,
                  filled: true,
                  // prefixIcon: Icon(
                  //   Icons.mail,
                  //   color: AppColors.white,
                  // ),
                  hintText: 'Enter your last name',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.grey)),
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.black),
              textAlign: TextAlign.start,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Please enter your last name";
                }
                return null;
              },
            ),
            SizedBox(
              height: height * .02,
            ),
            Text(
              "Email",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(

              cursorColor: AppColors.primary,
              controller: authProvider.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary, // Set the border color here
                      width: 2.0, // Set the border width here
                    ),
                    borderRadius:
                        BorderRadius.circular(8), // Set the border radius here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey, // Border color when not focused
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary, // Border color when focused
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColors.white,
                  filled: true,
                  hintText: 'Enter your email Address',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.grey)),
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.black),
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
            SizedBox(
              height: height * .02,
            ),
            Text(
              "Mobile",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),

            TextFormField(
              cursorColor: AppColors.primary,

              controller: authProvider.mobileNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.grey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      countryListTheme: CountryListThemeData(
                        textStyle: TextStyle(fontSize: 16, color: AppColors.grey),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        searchTextStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.primary),
                        inputDecoration: InputDecoration(
                          hintText: 'Start typing to search',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.primary),
                          prefixIcon: Icon(Icons.search, color: AppColors.primary),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      onSelect: (Country country) {
                        print('Select country: ${country.phoneCode}');
                        authProvider.setCountry(country.phoneCode, country);
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide.none,
                      ),
                    ),
                    height: 45.0,
                    width: 70.0,
                    margin: const EdgeInsets.only(
                        right: 10.0, bottom: 3.0, top: 3.0, left: 3.0),
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Text(
                          "${authProvider.countrys.flagEmoji} + ${authProvider.countrys.phoneCode}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                fillColor: AppColors.white,
                filled: true,
                hintText: 'Enter your Mobile',
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.grey),
              ),
              maxLines: 1,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.black),
              textAlign: TextAlign.start,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                value = value?.replaceAll(' ', '');

                if (value == null || value.isEmpty) {
                  return "Please enter mobile no.";
                }

                if (value.length < 10) {
                  return "Please enter at least 10 digits";
                }
                final RegExp mobileNumberRegExp = RegExp(r'^[3-9][0-9]{9}$');
                if (!mobileNumberRegExp.hasMatch(value)) {
                  return "Invalid mobile number (cannot start with 0, 1, or 2)";
                }

                return null;
              },
              onFieldSubmitted: (value) async {
                // Async validation to check if number already exists
                // bool exists = await authProvider.checkMobileNumberExists(value);
                // if (exists) {
                //   return "Mobile number already exists";
                // }
              },
            ),


            SizedBox(
              height: height * .02,
            ),
            Text(
              "Password",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              cursorColor: AppColors.primary,

              controller: authProvider.cPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: authProvider.registerObscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary, // Set the border color here
                    width: 2.0, // Set the border width here
                  ),
                  borderRadius:
                      BorderRadius.circular(8), // Set the border radius here
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.grey, // Border color when not focused
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary, // Border color when focused
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColors.white,
                hintText: 'Enter your password',
                filled: true,
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    authProvider.registerObscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    authProvider.togglePasswordVisibility();
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
                }else if (value.length < 6 ||  value.length>16) {
                  return "Password should be 6 to 16 digit";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: authProvider.isChecked,
                    onChanged: (value) {
                      authProvider.checkValue(value);
                    },
                    activeColor: authProvider.isChecked
                        ? AppColors.primary
                        : AppColors.secondaryColor,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "I agree to all the ",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondaryColor,
                                  ),
                          children: [
                        TextSpan(
                          text: " Terms",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.normal),
                        ),
                        const TextSpan(
                          text: " and",
                        ),
                        TextSpan(
                          text: " Privacy policies",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.normal),
                        ),
                      ]))
                ],
              ),
            ),
            SizedBox(
              height: height * .04,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppButton(
                height: 55,
                radius: 10,
                bgColor: AppColors.primary,
                title: "Register",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
                onTap: () async {
                  if (!authProvider.rFormKey.currentState!.validate()) {
                    return;
                  }
                  if (authProvider.isChecked == false) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please check the T&Cs check box.",style: Theme.of(context).textTheme.labelLarge,),
                        backgroundColor: AppColors.primary,
                      ),);

                     return;
                  }

                  final data = RegisterDataStoreModel(
                      firstName: authProvider.fNameController.text,
                      lastName: authProvider.lNameController.text,
                      email: authProvider.emailController.text,
                      mobileNumber: authProvider.mobileNumberController.text,
                      password: authProvider.cPasswordController.text,
                      userName: authProvider.userNameController.text);

                  authProvider.registerUser(
                    context,
                    data,
                    (value) async {
                      if (value) {
                        // await SharedStorage.localStorage
                        //     ?.setBool(SharedStorage.isLogin, true);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomBarScreen(
                                index: 0,
                              ),
                            ));
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: height * .04,
            ),
            // const Spacer(),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Already have an account? ",
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
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                      text: " Login",
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

class RegisterDataStoreModel {
  String firstName;
  String lastName;
  String email;
  String mobileNumber;
  String password;
  String userName;

  RegisterDataStoreModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobileNumber,
      required this.password,
      required this.userName});
}
