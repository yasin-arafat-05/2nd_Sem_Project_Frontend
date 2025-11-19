// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ip_address.dart';

class LogIn {
  final LogIn instance = LogIn();

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    const String apiUrl = 'http://${IP.ip}/token';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        final Map<String, dynamic> data = json.decode(response.body);
        print(response.body);
        return {'success': true, 'token': data['access_token']};
      } else {
        // Failed login
        print(response.body);
        return {'success': false, 'error': 'Invalid username or password'};
      }
    } catch (error) {
      // Error during login
      return {'success': false, 'error': 'An error occurred during login'};
    }
  }
}
