
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:union_up/App/Auth/ViewModel/auth_api.dart';
import 'package:union_up/Config/shared_prif.dart';

import '../View/login_screen.dart';
import '../View/register_screen.dart';

class AuthController extends ChangeNotifier {
  AuthApi authApi =AuthApi();

  final formKey = GlobalKey<FormState>();
  final rFormKey = GlobalKey<FormState>();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  FocusNode loginEmail = FocusNode();
  FocusNode loginPass = FocusNode();
  bool loginObscureText = true;
  bool registerObscureText = true;
  bool isChecked = false;

  /// register
  TextEditingController userNameController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();


  String selectedCountryCode = "91";
  Country countrys= Country(geographic: true, phoneCode: "91", countryCode: 'IND', e164Sc: 1, level: 1, name: 'India', example: '', displayName: '', displayNameNoCountryCode: '', e164Key: '');

  setCountry(phoneCode, countryValue){
    selectedCountryCode = phoneCode;

    countrys = countryValue;
    notifyListeners();
  }
  checkValue(value) {
    isChecked = value;
    notifyListeners();
  }

  bool validateEmail(String email) {
    final RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,3}$');
    return emailRegex.hasMatch(email);
  }

  // Initial state to obscure text

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    registerObscureText = !registerObscureText;
    notifyListeners(); // Notify UI to rebuild
  }
  void loginTogglePasswordVisibility() {
    loginObscureText = !loginObscureText;
    notifyListeners(); // Notify UI to rebuild
  }





  bool isRegisterLoad= false;
bool isLoginLoad= false;

  registerUser(BuildContext context,RegisterDataStoreModel data, ValueSetter<bool> onResponse)async{
    isRegisterLoad= true;
    final result = await authApi.registerApi(context,data);
    if(result != null){

      print("result====$result");
      String? token = result.data?.authToken ?? "";
      await SharedStorage.localStorage?.setString(SharedStorage.token, token ?? "");
      await SharedStorage.localStorage?.setBool(SharedStorage.isLogin, true);
      await SharedStorage.localStorage?.setString(SharedStorage.userRole, result.data?.userRole ??"worker");

      SharedStorage.instance.userDetail(
          username: result.data?.username ??"",
          email: result.data?.userEmail ??"",
          phone: "");

      fNameController.clear();
      lNameController.clear();
      emailController.clear();
      phoneController.clear();
      userNameController.clear();
      cPasswordController.clear();
      isRegisterLoad= false;
      onResponse(true);
      notifyListeners();
    }else{
      isRegisterLoad= false;
      onResponse(false);
      notifyListeners();
    }

  }


  loginUser(BuildContext context,LoginDataModel data, ValueSetter<bool> onResponse)async{
    isLoginLoad=true;
    final result = await authApi.loginApi(context,data);
    if(result != null){

      print("result====$result");

      String? token = result.data?.authToken ?? "";
      await SharedStorage.localStorage?.setString(SharedStorage.token, token ?? "");
      await SharedStorage.localStorage?.setBool(SharedStorage.isLogin, true);
      await SharedStorage.localStorage?.setString(SharedStorage.userRole, result.data?.userRole ??"worker");
      SharedStorage.instance.userDetail(
          username: result.data?.username ??"",
          email: result.data?.userEmail ??"",
          phone: "");

      loginEmailController.clear();
      loginPasswordController.clear();
      isLoginLoad=false;
      onResponse(true);
      notifyListeners();
    }else{
      isLoginLoad=false;
      onResponse(false);
      notifyListeners();
    }

  }


}