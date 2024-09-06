
import 'package:flutter/material.dart';
import 'package:union_up/App/Home/Model/home_model.dart';

import '../../../Common/app_urls.dart';
import '../../../Config/shared_prif.dart';
import '../../../Utils/http_network.dart';

class HomeApi {

  String token = "";


  Future<HomeModel?> getHomeData(BuildContext context) async {
    try {
       token = SharedStorage.localStorage?.getString(SharedStorage.token) ??"";

      var headers = {
        'Authorization': 'Bearer $token',
        'Cookie':
        'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
      };
      var body= {

      };

      final parse = await HttpService.postRequest(
          url: homeUrl, context: context, headers: headers,body:body );

      if (parse['status'] == "success") {
        return HomeModel.fromJson(parse);;
      }
      return  null;


    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

}