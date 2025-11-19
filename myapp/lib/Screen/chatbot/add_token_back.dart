// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ip_address.dart';
import '../../token_handling.dart';

class AddToken {
  static Future<String> createToken(
    String facebook,
    String instagram,
    String linkedin,
    String expiresAt,
  ) async {
    var res = await TokenHandiling.instance.getAccessToken();

    try {
      // Prepare headers with the access token
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $res',
      };

      // Your token data
      Map<String, dynamic> tokenData = {
        "facebook": facebook,
        "instagram": instagram,
        "linkedin": linkedin,
        "expires_at": expiresAt,
      };

      // Make authenticated request
      var response = await http.post(
        Uri.parse('http://${IP.ip}/create/tokens'),
        headers: headers,
        body: jsonEncode(tokenData),
      );

      // Check the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Token created successfully
        print('Token created successfully');
        return response.body;
      } else {
        // Handle error
        print('Error creating token: ${response.statusCode}');
        print('Response body: ${response.body}');
        return response.body;
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return e.toString();
    }
  }
}

