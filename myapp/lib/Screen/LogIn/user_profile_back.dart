// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/token_handling.dart';
import 'package:myapp/ip_address.dart';

class UserProfileBack {
  Future<Map<String, dynamic>> GetUserData() async {
    const url = "http://${IP.ip}/user/me";

    //----------Need the access token to authenticate the user------------
    var token = await TokenHandiling.instance.getAccessToken();

    try {
      // Prepare headers with the access token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $token',
      };

      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to fetch data ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      return {};
    }
    return {};
  }
}
