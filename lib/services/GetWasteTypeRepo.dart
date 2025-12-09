import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../app/loader_helper.dart';
import 'baseurl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class GetWasteTypeRepo
{
  List wasteTypleList = [];
  Future<List> getWaste() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sToken = prefs.getString('sToken');

    print('---19-  TOKEN---$sToken');

    try
    {
      showLoader();
      var baseURL = BaseRepo().baseurl;
      var endPoint = "GetWasteType/GetWasteType";
      var bindCityzenWardApi = "$baseURL$endPoint";
      var headers = {
        'token': '$sToken'
      };
      var request = http.Request('GET', Uri.parse('$bindCityzenWardApi'));

      // request.body = json.encode({
      //   "iUserId": "1000",
      // });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200)
      {
        hideLoader();
        var data = await response.stream.bytesToString();
        Map<String, dynamic> parsedJson = jsonDecode(data);
        wasteTypleList = parsedJson['Data'];
        print("Dist list Marklocation Api ----71------>:$wasteTypleList");
        return wasteTypleList;
      } else
      {
        hideLoader();
        return wasteTypleList;
      }
    } catch (e)
    {
      hideLoader();
      throw (e);
    }
  }
}
