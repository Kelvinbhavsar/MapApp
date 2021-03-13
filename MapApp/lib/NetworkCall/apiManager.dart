import 'dart:async';
import 'dart:convert';

// import 'package:Optio/Models/Usermodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager {

  Future<http.Response> getAppVersion(String str) async {
    var response = await http.get(str);
    return response;
  }

  Future<http.Response> getRequestList(String str) async {
    SharedPreferences value = await SharedPreferences.getInstance();

    var response = await http.get(str, headers: {});
    print(response);
    return response;
  }

}
