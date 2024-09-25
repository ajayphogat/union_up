import 'package:shared_preferences/shared_preferences.dart';




class SharedStorage {

  SharedStorage._();

  static final SharedStorage instance = SharedStorage._();

  Future<void> userDetail ({
    required String username,
    required String email,
    required String phone,
    required String image,

  }) async{
    await localStorage!.setString("username", username);
    await localStorage!.setString("userEmail", email);
    await localStorage!.setString("userPhone", phone);
    await localStorage!.setString("userImage", image);
  }



  String? get userName => localStorage!.getString("username") ?? "";
  String? get userEmail => localStorage!.getString("userEmail") ?? "";
  String? get userPhone => localStorage!.getString("userPhone") ?? "";
  String? get userImage => localStorage!.getString("userImage") ?? "";
  String? get role => localStorage!.getString("role") ?? "";


  static const introSeen="introSeen";
  static const isLogin="isLogin";
  static const token="token";
  static const userRole="role";
  static const deviceId="deviceId";



  static SharedPreferences? localStorage;
  static Future init() async => localStorage = await SharedPreferences.getInstance();

}