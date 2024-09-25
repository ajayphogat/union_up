
import 'package:flutter/material.dart';
import 'package:union_up/App/Home/Model/home_model.dart';

import '../../../Common/app_urls.dart';
import '../../../Config/shared_prif.dart';
import '../../../Utils/http_network.dart';

class HomeApi {



  Future<HomeModel?> getHomeData(BuildContext context) async {
    try {

      var body= { "":""};

      final parse = await makeRequest(homeUrl, "POST", body);

      if (parse['status'] == "success") {
        return HomeModel.fromJson(parse);;
      }
      return  null;

    } catch (e) {
      throw Exception("Failed to load $e");
    } finally {}
  }

}