
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:union_up/Common/app_urls.dart';
import 'package:union_up/Utils/http_network.dart';

import '../Model/auth_model.dart';
import '../View/login_screen.dart';
import '../View/register_screen.dart';

class AuthApi {

  Future<AuthModel?> registerApi(BuildContext context,RegisterDataStoreModel data)async{

    try {
     var body =json.encode({
        "mobile_no": data.mobileNumber,
        "password": data.password,
        "user_email": data.email,
        "first_name": data.firstName,
        "last_name": data.lastName
      });
      var headers = {
        'Content-Type': 'application/json'
      };
      print(body);
      final parse = await HttpService.postRequest(
          url: registerUrl, context: context, body: body,headers: headers);
      if (parse == null) {
        return null;
      }
      print("parse===$parse");
      if (parse["status"] == "success") {
       return AuthModel.fromJson(parse);
        } else  {
         return null;
        }

    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}

  }


  Future<AuthModel?>? loginApi(BuildContext context,LoginDataModel data)async{

    try {

     var body =json.encode({
        "email": data.email,
        "password": data.password,

      });
      var headers = {
        'Content-Type': 'application/json'
      };
      print(body);
      final parse = await HttpService.postRequest(
          url: loginUrl, context: context, body: body,headers: headers);
      if (parse == null) {
        return null;
      }
      print("parse===$parse");
      if (parse["status"] == "success") {
       return AuthModel.fromJson(parse);
        } else  {
         return null;
        }

    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}

  }

}