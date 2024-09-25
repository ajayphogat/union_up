
import 'package:flutter/material.dart';
import 'package:union_up/Common/image_path.dart';

class MoreController extends ChangeNotifier {


  var community = [
    {
    "title":"Profile",
      "img": userIconImage
  },
    {
    "title":"Groups",
      "img": groupIcon
  },
    {
    "title":"Events",
      "img": eventIcon
  },
    {
    "title":"Headsup",
      "img": headsUpIcon
  },
    {
    "title":"Message",
      "img": messageIcon
  },
    {
    "title":"Member",
      "img": memberIcon
  },

  ];
  var libraries = [

    {
      "title":"Disputes",
      "img": disputeIcon
    },
    {
      "title":"EAs/Awards",
      "img": awardIcon
    },


  ];
  var stuff = [

    {
      "title":"Terms of use",
      "img": disputeIcon
    },
    {
      "title":"Settings",
      "img": awardIcon
    },


  ];
}