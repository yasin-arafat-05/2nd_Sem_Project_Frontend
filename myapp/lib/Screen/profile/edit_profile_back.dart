import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../ip_address.dart';
import '../../token_handling.dart';

class EditProfileBack {
  Future<String> editProfileBack(
      String busName, String busDes, String city, String region) async {
    const String url = "http://${IP.ip}/update/profile";
    var token = await TokenHandiling.instance.getAccessToken();

    try {
      Map<String, String> header = {
        'content-type': 'application/json',
        'Authorization': 'bearer $token'
      };
      final Map<String, String> updateData = {
        "business_name": busName,
        "city": city,
        "region": region,
        "business_description": busDes,
      };
      final response = await http.put(Uri.parse(url),
          headers: header, body: jsonEncode(updateData));

      if (response.statusCode == 201) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return "";
  }
}
