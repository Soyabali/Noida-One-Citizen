import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class BookAadvertisementRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future bookadvertisement(
      BuildContext context,
      String sRequestNo,
      dropDownValueAdvertisementPlaceType,
      dropDownValueAdvertisementPlace,
      String contentTypeText,
      dropDownValueAdvertisementPlan,
      String fromDate,
      String toDate,
      String sPostedBy) async {
      //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      print('----phsRequestNoone-----31--$sRequestNo');
      print('----dropDownValueAdvertisementPlaceType-----31--$dropDownValueAdvertisementPlaceType');
      print('----dropDownValueAdvertisementPlace-----31--$dropDownValueAdvertisementPlace');
      print('----contentTypeText-----31--$contentTypeText');
      print('----dropDownValueAdvertisementPlan-----31--$dropDownValueAdvertisementPlan');
      print('----fromDate-----31--$fromDate');
      print('----toDate-----31--$toDate');
      print('----sPostedBy-----31--$sPostedBy');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "PostAdvertisingRequest/PostAdvertisingRequest";
      var bookAdvertisementApi = "$baseURL$endPoint";
      print('------------17---Api---$bookAdvertisementApi');

      showLoader();
     // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request(
          'POST', Uri.parse('$bookAdvertisementApi'));
      request.body = json.encode(
          {
        "sRequestNo": sRequestNo ?? "0",
        "iAdSpaceCode": dropDownValueAdvertisementPlaceType ?? "0",
        "sAdType": dropDownValueAdvertisementPlace ?? "0",
        "sContent": contentTypeText ?? "",
        "iPlanCode": dropDownValueAdvertisementPlan ?? "0",
        "dFromDate": fromDate,
        "dToDate": toDate,
        "sPostedBy": sPostedBy ?? "0",
          });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---LOGINaPI RESPONSE----$map');

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----44-${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---bookAdvertisement RESPONSE----$map');
        hideLoader();
        print(response.reasonPhrase);
        return map;
      }
    } catch (e) {
      hideLoader();
      debugPrint("exception: $e");
      throw e;
    }
  }
}

