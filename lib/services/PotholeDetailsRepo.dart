import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/generalFunction.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PothoLedetailsRepo {

  // this is a loginApi call functin
  GeneralFunction generalFunction = GeneralFunction();

  Future photoledetail(
      BuildContext context, selectedWardId2, String? sContactNo, String random12digitNumber, uplodedImage, double? lat, double? long, locationAddress, potholeResponseBody) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    try {
      print('----phsRequestNoone-----31--$selectedWardId2');

      var baseURL = BaseRepo().baseurl;
      var endPoint = "PotholeDetails/PotholeDetails";
      var potholeDetailApi = "$baseURL$endPoint";
      print('------------17---Api---$potholeDetailApi');

      print("---30----selectedWardId2:  $selectedWardId2");
      print("---31----sContactNo:  $sContactNo");
      print("---32----random12digitNumber:  $random12digitNumber");
      print("---33----uplodedImage:  $uplodedImage");
      print("---34----lat:  $lat");
      print("---35----lat:  $long");
      print("---36----address:  $locationAddress");
      print("---37----sToken:  $sToken");
      print("----38----photoleImageBody--$potholeResponseBody");

      showLoader();
      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request(
          'POST', Uri.parse('$potholeDetailApi'));
      request.body = json.encode({
        "Sector": selectedWardId2,
        "UserId":sContactNo,
        "TranNo":random12digitNumber,
        "PotholeImage":uplodedImage,
        "Latitude":lat,
        "Longitude":long,
        "PotholLocation":locationAddress,
        "Json":'$potholeResponseBody'
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var map;
      var data = await response.stream.bytesToString();
      map = json.decode(data);
      print('----------20---LOGINaPI RESPONSE----$map');

      if (response.statusCode == 200) {
        // create an instance of auth class
        print('----65---${response.statusCode}');
        hideLoader();
        print('----------22-----$map');
        return map;
      } else {
        print('----------29---bookAdvertisement RESPONSE----$map');
        hideLoader();
        print('----72----${response.statusCode}');
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

